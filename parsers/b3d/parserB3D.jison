/* description: Parses Basic3D language input */

/* lexical grammar */
%lex
%%

/*EXPRESINOES REGULARES*/

\s+                   				/* skip whitespace */
"%"[^\n]* 							/* comentario de una sola linea*/
"¿"[^\?]*"?"						/* comentario de varias lineas */

/*OPERADORES*/

"+"		return '+'
"-"		return '-'
"*"		return '*'
"/"		return '/'
"%"		return '%'
"^"		return '^'

"=="	return '=='
"!="	return '!='
">"		return '<'
"<"		return '<'
">="	return '>='
"<="	return '<='

"||"	return '||'
"|?"	return '|?'
"&&"	return '&&'
"&?"	return '&?'
"|&"	return '|&'
"!"		return '!'

/*SIMBOLOS*/
"("		return '('
")"		return ')'
"["		return '['
"]"		return ']'
"{"		return '{'
"}"		return '}'

":"		return ':'
","		return ','
";"		return ';'
".."	return '..'
"="		return '='
"."		return '.'

/*PALABRAS RESERVADAS*/
"bool"								return 'tipo_bool'
"num"								return 'tipo_num'
"str"								return 'tipo_str'
"void"								return 'tipo_void'

"array"								return 'array'
"of"								return 'of'

"element"							return 'element'
"create"							return 'create'

"Principal"							return 'Principal'

"if"								return 'if'
"then"								return 'then'
"else"								return 'else'
"switch"							return 'switch'
"case"								return 'case'
"default"							return 'default'
"break"								return 'break'
"continue"							return 'continue'
"return"							return 'return'
"while"								return 'while'
"do"								return 'do'
"repeat"							return 'repeat'
"until"								return 'until'
"for"								return 'for'
"loop"								return 'loop'
"count"								return 'count'
"whilex"							return 'whilex'

"getBool"							return 'getBool'
"getNum"							return 'getNum'
"\"bin\""							return 'bin'
"\"hex\""							return 'hex'
"\"dec\""							return 'dec'

"outStr"							return 'outStr'
"outNum"							return 'outNum'
"inStr"								return 'inStr'
"inNum"								return 'inNum'
"show"								return 'show'

"getRandom"							return 'getRandom'
"getLength"							return 'getLength'

"throws"							return 'throws'
"NullPointerException"				return 'NullPointerException'
"MissingReturnStatement"			return 'MissingReturnStatement'
"ArithmeticException"				return 'ArithmeticException'
"StackOverFlowException"			return 'StackOverFlowException'
"HeapOverFlowException"				return 'HeapOverFlowException'
"PoolOverFlowException"				return 'PoolOverFlowException'


"true"								{return 'verdadero';}
"false"								{return 'falso';}
"NULL"								{return 'null';}
"\""(.|\n)*"\"" 					{return 'cad1';}
"'"(.|\n)*"'"						{return 'cad2';}
[0-9]+("."[0-9]+)?\b  				{return 'NUM';}
[a-zA-Z]([a-zA-Z]|[0-9]|_)*			{return 'ID';}


<<EOF>>               				return 'EOF'
.                     				{console.log("[" + yytext + "]");return 'INVALID'}

/lex

/* operator associations and precedence */

%left '+' '-'
%left '*' '/' '%'
%left '^'
%left UMINUS
%left '==' '!=' '>' '<' '>=' '<='
%left '||' '|?'
%left '&&' '&?'
%left '|&' 
%right '!'


%start INICIO


%% 

/* language grammar */

INICIO	:	 LELEMENT EOF	{typeof console !== 'undefined' ? console.log('EXITO') : print('exito');}
			|LSENTGLOB EOF	{typeof console !== 'undefined' ? console.log('EXITO') : print('exito');};

/*****************************************************************************************************************************************
														ESTRUCTURAS
*****************************************************************************************************************************************/
				
LELEMENT	:	 LELEMENT ELEMENT
				|ELEMENT
				;
				
ELEMENT		: 	 'element' ':' ID '{' LATR '}'
				;
				
LATR	:	 LATR ATR
			|ATR
			;
				
ATR		:	 DEC_ASG_VAR ';'
			|ELEMENT
			;


/*****************************************************************************************************************************************
														METODOS Y FUNCIONES
*****************************************************************************************************************************************/

LSENTGLOB	:	 LSENTGLOB SENTGLOB
				|SENTGLOB
				;

SENTGLOB	:	 DEC_VAR ';'
				|DEC_ARR ';'
				|DEC_ASG_VAR ';'
				|DEC_FUNC
				|DEC_PRINCIPAL
				;

DEC_VAR		:	 TIPOVAR LID
					;
					
DEC_ASG_VAR	:	 DEC_VAR ':' ASG_EXP
				;

DEC_ARR		:	 'array' ':' ARREGLO 'of' TIPOVAR
				;					
LDIM	:	 LDIM DIM
			|DIM
			;
DIM		:	 '[' NUM ']'
			|'[' NUM '..' NUM ']'
			;
			
DEC_FUNC	:	 TIPOVAR ':' ID PARAMETROS CUERPO
				|tipo_void ':' ID PARAMETROS CUERPO
				|TIPOVAR LCOR ':' ID PARAMETROS CUERPO
				;
PARAMETROS	:	 '(' ')'
				|'(' LPAR ')'
				;
LPAR		: 	 LPAR ',' PAR
				|PAR
				;
PAR			:	 TIPOVAR '*' ID
				|TIPOVAR ID
				|TIPOVAR ARREGLO
				;
				
DEC_PRINCIPAL	:	 'Principal' '(' ')' CUERPO
					;

/*****************************************************************************************************************************************
														CUERPO
*****************************************************************************************************************************************/

CUERPO		:	 '{' '}'
				|'{' LSENTLOC '}'
				;
LSENTLOC	:	 LSENTLOC SENTLOC
				|SENTLOC
				;				
SENTLOC		:	 DEC_VAR ';'
				|DEC_ASG_VAR ';'
				|DEC_ARR ';'
				|ASG ';'
				
				|CALL ';'
				
				|IF
				|IFELSE
				|SWITCH
				
				|BREAK ';'
				|CONTINUE ';'
				|RETURN ';'
				
				|WHILE
				|DOWHILE
				|REPEAT
				|FOR
				|LOOP
				|COUNT
				|DOWHILEX
				
				|IO ';'
				|EXCEPCION ';'
				;

ASG			:	 ID '=' ASG_EXP
				|PROPIEDAD '=' ASG_EXP
				|ARREGLO '=' ASG_EXP
				;
PROPIEDAD	:	 PROPIEDAD '.' ID
				|ID '.' ID
				;
	 
CALL		:	 ID ARGUMENTOS
				;
ARGUMENTOS	:	 '(' ')'
				|'(' LE ')'
				;

COND		:	 '(' E ')'
				;
				

/*****************************************************************************************************************************************
														CONTROL
*****************************************************************************************************************************************/				
				
IF			:	 'if' COND 'then' CUERPO
				;				
IFELSE		:	IF 'else' CUERPO
				;
SWITCH		:	 'switch' '(' E ',' BOOL ')' '{' LCASO '}'
				|'switch' '(' E ',' BOOL ')' '{' LCASO DEFAULT '}'
				;
LCASO		:	 LCASOS
				|LCASOR
				;
LCASOS		:	 LCASOS CASOS
				|CASOS;
LCASOR		:	 LCASOR CASOR
				|CASOR				
				;
CASOS		:	 V ':' LSENTLOC
				;
CASOR		:	 V '-' V ':' LSENTLOC
				;
V			:	 NUM
				|CAD
				;
BREAK		: 	 'break'
				|'break' ID
				;
CONTINUE	: 	 'continue'
				;
RETURN		: 	 'return'
				|'return' E
				;

/*****************************************************************************************************************************************
														CICLOS
*****************************************************************************************************************************************/

WHILE		:	 'while' COND CUERPO
				;
DOWHILE		:	 'do' CUERPO 'while' COND
				;
REPEAT		:	 'repeat' CUERPO 'until' COND 
				;
FOR			:	 'for' '(' CONTROL ';' E ';' E ')' CUERPO
				;
CONTROL		:	 DEC_ASG_VAR
				|ASG
				;
LOOP		:	 'loop' CUERPO
				|'loop' ID CUERPO
				;
COUNT		:	 'count' '(' EXP ')' CUERPO
				;
DOWHILEX	:	 'do' CUERPO 'whilex' '(' E ',' E ')'
				;

/*****************************************************************************************************************************************
														FUNCIONES PRIMITIVAS: Entradas y salidas
*****************************************************************************************************************************************/

IO			:	 OUTSTR
				|OUTNUM
				|INSTR
				|INNUM
				|SHOW
				;

OUTSTR		:	 'outStr' '(' EXP ')'
				;
OUTNUM		:	'outNum' '(' EXP ',' BOOL ')'
				;
INSTR		:	 'inStr' '(' ID ',' EXP ')'
				;
INNUM		:	 'inNum' '(' EXP ',' NUM ')'
				;
SHOW		:	 'show' '(' EXP ')'
				;
				

/*****************************************************************************************************************************************
														EXCEPCIONES
*****************************************************************************************************************************************/

EXCEPCION	:	 'throws' '(' EXCP ')'
				;
EXCP		:	 'NullPointerException'
				|'MissingReturnStatement'
				|'ArithmeticException'
				|'StackOverFlowException'
				|'HeapOverFlowException'
				|'PoolOverFlowException'
				;
/*****************************************************************************************************************************************
														EXPRESIONES
*****************************************************************************************************************************************/

ASG_EXP	:	 E
			|CREATE
			;

E	:  	 E '||' E		
		|E '|?' E
		|E '&&' E
		|E '&?' E
		|E '|&' E
		|'!' E
		|REL
		;
		
REL	:	 EXP OPREL EXP
		|EXP
		;

EXP	:	 EXP '+' EXP
		|EXP '-' EXP
		|EXP '*' EXP
		|EXP '/' EXP
		|EXP '%' EXP
		|EXP '^' EXP
		|'-' EXP %prec UMINUS
		|'(' E ')'
		|VAL
		|ID
		|null
		
		|ARREGLO
		|CALL
		|PROPIEDAD
		|CONVERSIONES
		|OTRAS
		;

VAL		:	 NUM	{$$ = $1;}
			|CAD	{$$ = $1;}
			|BOOL	{$$ = $1;}
			;		
BOOL	:	 verdadero	{$$ = $1;}
			|falso		{$$ = $1;}
			;
CAD		:	 cad1	{$$ = $1;}
			|cad2	{$$ = $1;}
			;
			
CREATE	:	 'create' '(' ID ')'
			;
		
OPREL	:	 '=='
			|'!='
			|'<'
			|'>'
			|'<='
			|'>='
			;
					
					

/*****************************************************************************************************************************************
														FUNCIONES PRIMITIVAS: Conversiones
*****************************************************************************************************************************************/

CONVERSIONES	:	 GETBOOL
					|GETNUM
					;

GETBOOL		:	 'getBool' '(' CAD ')'
				;
				
GETNUM		:	 'getNum' '(' CAD ',' BASE ',' NUM ')'
				;
BASE		:	 bin
				|hex
				|dec
				;	

/*****************************************************************************************************************************************
														FUNCIONES PRIMITIVAS: Otras
*****************************************************************************************************************************************/

OTRAS		:	 GETRANDOM
				|GETLENGTH
				;

GETRAMDOM	:	 'getRandom' '(' ')'
				;
GETLENGTH	:	 'getLength' '(' ID ',' EXP ')'
				|'getLength' '(' EXP ')'
				;


					
/*****************************************************************************************************************************************
														TIPOS
*****************************************************************************************************************************************/
			
TIPOVAR	:	 TIPOVAL
			|ID
			;
			
TIPOVAL	:	 tipo_bool		{$$ = $1;}
			|tipo_num		{$$ = $1;}
			|tipo_str		{$$ = $1;}
			;
			
			
/*****************************************************************************************************************************************
														LISTAS
*****************************************************************************************************************************************/			
			
LID	:	 ID
		|LID ',' ID
		;
		
LE	:	 LE ',' E
		|E
		;
		
/*****************************************************************************************************************************************
														ARREGLOS
*****************************************************************************************************************************************/		
		
ARREGLO	:	 ID LDIM
			;	
	
LCOR	:	 LCOR '[' ']'
			|'[' ']'
			;
