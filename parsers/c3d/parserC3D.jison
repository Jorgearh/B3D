/* description: Parses C3D input */

/* lexical grammar */
%lex
%%

/*EXPRESINOES REGULARES*/

\s+                   				/* skip whitespace */
"//"[^\n]* 							/* comentario de una sola linea*/
"/*"[^\*]*"*/"						/* comentario de varias lineas */

/*OPERADORES*/

"+"		return '+'
"-"		return '-'
"*"		return '*'
"/"		return '/'
"%"		return '%'

"=="	return '=='
"!="	return '!='
">"		return '<'
"<"		return '<'
">="	return '>='
"<="	return '<='
"!"		return '!'

/*SIMBOLOS*/
"("		return '('
")"		return ')'
"["		return '['
"]"		return ']'
"{"		return '{'
"}"		return '}'

";"		return ';'
","		return ','
"="		return '='
":"		return ':'

/*PALABRAS RESERVADAS*/
"void"								return 'void'
"int"								return 'int'

"if"								return 'if'
"then"								return 'then'
"goto"								return 'goto'

"$$_getBool()"						return 'getBool'
"$$_getNum()"						return 'getNum'

"$$_outStr()"						return 'outStr'
"$$_outNum()"						return 'outNum'
"$$_inStr()"						return 'inStr'
"$$_inNum()"						return 'inNum'
"$$_show()"							return 'show'

"$$_getRandom()"					return 'getRandom'
"$$_getArrLength()"					return 'getArrLength'
"$$_getStrLength()"					return 'getStrLength'

"$$_SGC"							return 'SGC'

"printf"							return 'printf'
"c"		    						return 'paramC'
"d"	     							return 'paramD'
"f" 								return 'paramF'

"exit"								return 'exit'


"stack"								{return 'STACK';}
"heap"								{return 'HEAP';}
"pool"								{return 'POOL';}
"t"[0-9]+							{return 'TEMP';}
"L"[0-9]+							{return 'LABEL';}

"s"									{return 'S';}
"h"									{return 'H';}
"p"									{return 'P';}

[0-9]+("."[0-9]+)?\b  				{return 'NUM';}
[a-zA-Z]([a-zA-Z]|[0-9]|_)*			{return 'ID';}


<<EOF>>               				return 'EOF'
.                     				{console.log("[" + yytext + "]");return 'INVALID'}

/lex

/* operator associations and precedence */
%left '+' '-'
%left '*' '/' '%'

%start INICIO

%% 

/* language grammar */

INICIO	:	 LSENT EOF	{typeof console !== 'undefined' ? console.log('EXITO') : print('exito');}
			;
			
LSENT	:	 LSENT SENT
			|SENT
			;
			
SENT	:	 DEC ';'
			|MET
			;			
			

DEC		:	 'int' PTR '[' NUM ']'
			|'int' TEMP
			|'int' PTR '=' NUM
			;
			
MET		:	 'void' ID '(' ')' '{' LINSTR '}'
			;
			
LINSTR	:	 LINSTR INSTR
			|INSTR
			;
			
INSTR	:	 LBL ':'
			|ASG ';'
			|JMPI ';'
			|JMPC ';'
			|CALL ';'
			|CORE ';'
			|PRINTF ';'
			|EXIT ';'
			;
			
LBL		:	 LABEL
			;
			
ASG		:	 DESTINO '=' EXP
			;
DESTINO	:	 TEMP
			|ID
			|ACCESO
			;

EXP		:	 EXP '+' EXP
			|EXP '-' EXP
			|EXP '*' EXP
			|EXP '/' EXP
			|EXP '%' EXP
			|NUM
			|TEMP
			|ACCESO
			|PTR
			;

ACCESO	:	 PTR POS
			;
			
PTR		:	 STACK
			|HEAP
			|POOL
			;

POS		:	 '[' VAL ']';			

JMPI	:	 'goto' LABEL
			;
			
JMPC	:	 'if' '(' VAL OPREL VAL ')' 'then' 'goto' LABEL
			;
OPREL	:	 '=='
			|'!='
			|'<'
			|'>'
			|'<='
			|'>='
			;			

CALL	:	 ID '(' ')'
			;
			
CORE	:	 getBool
			|getNum
			|outStr
			|outNum
			|inStr
			|inNum
			|show
			|getRandom
			|getArrLength
			|getStrLength
			
			|SGB
			;


SGC		:	'SGC' '(' VAL ',' VAL ')'
			;
			
PRINTF	:	 printf '(' PARAM ',' VAL ')'
			;
PARAM	:	 '%' paramC
			|'%' paramD
			|'%' paramF
			;
			
EXIT	:	 'exit' NUM
			;
			
VAL		:	 TEMP
			|NUM
			;
			
PTR		:	 S
			|H
			|P
			;			
