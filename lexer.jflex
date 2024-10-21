package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

%%

%class Lexer
%implements sym
%public
%unicode
%line
%column
%cup
%char
%{
	

    public Lexer(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Lexer(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }
    
    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }
    
    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}

Newline    = \r | \n | \r\n
Whitespace = [ \t\n\r]+ | {Newline}
Number     = [0-9]+



ident = ([:jletter:] | "_" ) ([:jletterdigit:] | [:jletter:] | "_" )*


%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG
%state ATTRSTATE
%state CONTENTSTATE
%state HREF_STATE
%%  

<YYINITIAL> {
	"<html>"           { return symbolFactory.newSymbol("HTML_START", HTML_START); }
    "</html>"          { return symbolFactory.newSymbol("HTML_END", HTML_END); }
    "<head>"           { return symbolFactory.newSymbol("HEAD_START", HEAD_START); }
    "</head>"          { return symbolFactory.newSymbol("HEAD_END", HEAD_END); }
    "<body>"           { return symbolFactory.newSymbol("BODY_START", BODY_START); }
    "</body>"          { return symbolFactory.newSymbol("BODY_END", BODY_END); }
    "<p>"              { return symbolFactory.newSymbol("P_START", P_START); }
    "</p>"             { return symbolFactory.newSymbol("P_END", P_END); }
    "<a"               { return symbolFactory.newSymbol("A_START", A_START); } 
    "</a>"             { return symbolFactory.newSymbol("A_END", A_END); }
    "<img"             { return symbolFactory.newSymbol("IMG", IMG); }  
    "<br/>"            { return symbolFactory.newSymbol("BR", BR); }  
    "<h1>"             { return symbolFactory.newSymbol("H1_START", H1_START); }
    "</h1>"            { return symbolFactory.newSymbol("H1_END", H1_END); }
    "<h2>"             { return symbolFactory.newSymbol("H2_START", H2_START); }
    "</h2>"            { return symbolFactory.newSymbol("H2_END", H2_END); }
	{Whitespace}       {}
     [^<]+               { return symbolFactory.newSymbol("TEXT_CONTENT", TEXT_CONTENT, yytext().trim()); }

// Catch-all for unrecognized characters
.                   { emit_warning("Unrecognized character here '" + yytext() + "' -- ignored"); }

}


