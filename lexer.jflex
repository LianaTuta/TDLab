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


hrefToken = "href"

// Define pattern for attribute values as double or single-quoted strings
stringValue = "\"" ([^\"\\\n\r]|\\.)* "\"" | "'" ([^'\\\n\r]|\\.)* "'"
%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state TEXT
%state CODESEG
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
    "<a>"          	 { return symbolFactory.newSymbol("A_START", A_START); } 
    "</a>"             { return symbolFactory.newSymbol("A_END", A_END); }
	"class"          { return symbolFactory.newSymbol("ATTRIBUTE_NAME_CLASS", ATTRIBUTE_NAME_CLASS); }
	{hrefToken}  	   { return symbolFactory.newSymbol("ATTRIBUTE_NAME_HREF", ATTRIBUTE_NAME_HREF); }
	{stringValue}      { return symbolFactory.newSymbol("ATTRIBUTE_VALUE", ATTRIBUTE_VALUE, yytext()); }
	"style"            { return symbolFactory.newSymbol("ATTRIBUTE_NAME_STYLE", ATTRIBUTE_NAME_STYLE); }
    "="                { return symbolFactory.newSymbol("EQUALS", EQUALS); }
	"\""               { return symbolFactory.newSymbol("QUOTE", QUOTE); }
	"'"                { return symbolFactory.newSymbol("QUOTE", QUOTE);}
	";"                { return symbolFactory.newSymbol("SEMICOLON", SEMICOLON); }
    "<img>"             { return symbolFactory.newSymbol("IMG", IMG); }  
    "<br/>"            { return symbolFactory.newSymbol("BR", BR); }  
    "<b>"              { return symbolFactory.newSymbol("B_START", B_START); } 
    "</b>"              { return symbolFactory.newSymbol("B_END", B_END); }  
    "<h1>"             { return symbolFactory.newSymbol("H1_START", H1_START); }
    "</h1>"            { return symbolFactory.newSymbol("H1_END", H1_END); }
    "<h2>"             { return symbolFactory.newSymbol("H2_START", H2_START); }
    "</h2>"            { return symbolFactory.newSymbol("H2_END", H2_END); }
    "<title>"          { return symbolFactory.newSymbol("TITLE_START", TITLE_START); }
    "</title>"         { return symbolFactory.newSymbol("TITLE_END", TITLE_END); }
    "<h3>"             { return symbolFactory.newSymbol("H3_START", H3_START); }
    "</h3>"            { return symbolFactory.newSymbol("H3_END", H3_END); }
    "<h4>"             { return symbolFactory.newSymbol("H4_START", H4_START); }
    "</h4>"            { return symbolFactory.newSymbol("H4_END", H4_END); }
    "<h5>"             { return symbolFactory.newSymbol("H5_START", H5_START); }
    "</h5>"            { return symbolFactory.newSymbol("H5_END", H5_END); }
    "<h6>"             { return symbolFactory.newSymbol("H6_START", H6_START); }
    "</h6>"            { return symbolFactory.newSymbol("H6_END", H6_END); }
    "<ul>"             { return symbolFactory.newSymbol("UL_START", UL_START); }
    "</ul>"            { return symbolFactory.newSymbol("UL_END", UL_END); }
    "<ol>"             { return symbolFactory.newSymbol("OL_START", OL_START); }
    "</ol>"            { return symbolFactory.newSymbol("OL_END", OL_END); }
    "<li>"             { return symbolFactory.newSymbol("LI_START", LI_START); }
    "</li>"            { return symbolFactory.newSymbol("LI_END", LI_END); }
    "<table>"          { return symbolFactory.newSymbol("TABLE_START", TABLE_START); }
    "</table>"         { return symbolFactory.newSymbol("TABLE_END", TABLE_END); }
    "<tr>"             { return symbolFactory.newSymbol("TR_START", TR_START); }
    "</tr>"            { return symbolFactory.newSymbol("TR_END", TR_END); }
    "<td>"             { return symbolFactory.newSymbol("TD_START", TD_START); }
    "</td>"            { return symbolFactory.newSymbol("TD_END", TD_END); }
    "<th>"             { return symbolFactory.newSymbol("TH_START", TH_START); }
    "</th>"            { return symbolFactory.newSymbol("TH_END", TH_END); }
    "<form>"           { return symbolFactory.newSymbol("FORM_START", FORM_START); }
    "</form>"          { return symbolFactory.newSymbol("FORM_END", FORM_END); }
    "<input>"           { return symbolFactory.newSymbol("INPUT", INPUT); }
    "<button>"         { return symbolFactory.newSymbol("BUTTON_START", BUTTON_START); }
    "</button>"        { return symbolFactory.newSymbol("BUTTON_END", BUTTON_END); }
    "<select>"         { return symbolFactory.newSymbol("SELECT_START", SELECT_START); }
    "</select>"        { return symbolFactory.newSymbol("SELECT_END", SELECT_END); }
    "<option>"         { return symbolFactory.newSymbol("OPTION_START", OPTION_START); }
    "</option>"        	{ return symbolFactory.newSymbol("OPTION_END", OPTION_END); }
    "<address>"         { return symbolFactory.newSymbol("ADDRESS_START", ADDRESS_START); }
    "</address>"        { return symbolFactory.newSymbol("ADDRESS_END", ADDRESS_END); }
    "<applet>"         	{ return symbolFactory.newSymbol("APPLET_START", APPLET_START); }
    "</applet>"        	{ return symbolFactory.newSymbol("APPLET_END", APPLET_END); }
    "<basefont>"        { return symbolFactory.newSymbol("BASEFONT_START", BASEFONT_START); }
    "</basefont>"       { return symbolFactory.newSymbol("BASEFONT_END", BASEFONT_END); }
    "<big>"        		{ return symbolFactory.newSymbol("BIG_START", BIG_START); }
    "</big>"        	{ return symbolFactory.newSymbol("BIG_END", BIG_END); }
    "<blockquote>"      { return symbolFactory.newSymbol("BLOCKQOUTE_START", BLOCKQOUTE_START); }
    "</blockquote>"     { return symbolFactory.newSymbol("BLOCKQOUTE_END", BLOCKQOUTE_END); }
    "<center>"        	{ return symbolFactory.newSymbol("CENTER_START", CENTER_START); }
    "</center>"        	{ return symbolFactory.newSymbol("CENTER_END", CENTER_END); }
     "<dir>"        	{ return symbolFactory.newSymbol("DIR_START", DIR_START); }
    "</dir>"        	{ return symbolFactory.newSymbol("DIR_END", DIR_END); }
    "<div>"        		{ return symbolFactory.newSymbol("DIV_START", DIV_START); }
    "</div>"        	{ return symbolFactory.newSymbol("DIV_END", DIV_END); }
    "<dd>"        		{ return symbolFactory.newSymbol("DD_START", DD_START); }
    "</dd>"        		{ return symbolFactory.newSymbol("DD_END", DD_END); }
    "<dt>"        		{ return symbolFactory.newSymbol("DT_START", DT_START); }
    "</dt>"        		{ return symbolFactory.newSymbol("DT_END", DT_END); }
    "<dl>"        		{ return symbolFactory.newSymbol("DL_START", DL_START); }
    "</dl>"        		{ return symbolFactory.newSymbol("DL_END", DL_END); }
    "<textarea>"        { return symbolFactory.newSymbol("TEXTAREA_START", TEXTAREA_START); }
    "</textarea>"       { return symbolFactory.newSymbol("TEXTAREA_END", TEXTAREA_END); }
    "<listing>"        	{ return symbolFactory.newSymbol("LISTING_START", LISTING_START); }
    "</listing>"       	{ return symbolFactory.newSymbol("LISTING_END", LISTING_END); }
    "<menu>"        	{ return symbolFactory.newSymbol("MENU_START", MENU_START); }
    "</menu>"       	{ return symbolFactory.newSymbol("MENU_END", MENU_END); }
    "<nobr>"        	{ return symbolFactory.newSymbol("NOBR_START", NOBR_START); }
    "</nobr>"       	{ return symbolFactory.newSymbol("NOBR_END", NOBR_END); }
    "<pre>"        		{ return symbolFactory.newSymbol("PRE_START", PRE_START); }
    "</pre>"       		{ return symbolFactory.newSymbol("PRE_END", PRE_END); }
    "<caption>"        		{ return symbolFactory.newSymbol("CAPTION_START", CAPTION_START); }
    "</caption>"       		{ return symbolFactory.newSymbol("CAPTION_END", CAPTION_END); }
	{Whitespace}       {}
	[ \t\n\r]+           { /* ignore whitespace */ }
	[^<\n\r]+             { return symbolFactory.newSymbol("TEXT_CONTENT", TEXT_CONTENT, yytext().trim()); }
    
  

// Catch-all for unrecognized characters
.                   { emit_warning("Unrecognized character here '" + yytext() + "' -- ignored"); }

}

<TEXT> {
    [^<\n\r]+             { return symbolFactory.newSymbol("TEXT_CONTENT", TEXT_CONTENT, yytext().trim()); }
    {Whitespace}       {}
    [\r\n]+ 		   {}
}
