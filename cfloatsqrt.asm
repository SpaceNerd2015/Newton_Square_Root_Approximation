;	File Name:			cfloatsqrt.asm
;	Author:				Hayley Johnsey
;	Date:				11-26-18
;	Description:		CS 308-01 Programming Assignment 4

.586
.MODEL FLAT
.STACK 4096

.DATA
accuracy	REAL8	0.00001
lower		REAL8	1.00
upper		REAL8	0.00
guess		REAL8	0.00
number		REAL8	7.00
two			REAL8	2.00
result		REAL8	0.00

.CODE
main	PROC

	finit
	
	fld number				;push n onto the stack
	fstp upper				;copy n and store it in upper (ST popped off the stack)

whileLoop:
	finit

	fld upper				;push upper onto the stack
	fld lower				;push lower onto the stack

	fsub					;pops ST and ST(1), subtracts ST from ST(1), pushes result onto stack

	fcomp accuracy			;compare ST (upper-lower) and accuracy
	fstsw ax				;copies condition code bits to AX
	sahf					;shift condition code bits to flags
	jbe endWhileLoop		;jump to endWhileLoop if less than or equal to

	;guess = (lower + upper) / 2
	fld upper				;push upper onto the stack
	fld lower				;push lower onto the stack
	fadd					;pops ST and ST(1), adds them, pushes sum onto the stack
	fdiv two				;divide ST by integer found at two, replaces ST by the quotient
	fst guess				;stores ST as guess

	fst st(1)				;copy ST to ST(1)
	fmul					;pops ST and ST(1), multiplies them, pushes product onto the stack

	fcomp number				;compares ST (product) and number
	fstsw ax				;copies condition code bits to AX
	sahf					;shift condition code bits to flags
	ja greaterThan			;jump to greaterThan if greater than

	fld guess
	fstp lower				;copy ST to lower
	jmp whileLoop

greaterThan:
	fld guess
	fstp upper				;copy ST to upper and pop ST
	
	jmp whileLoop			;jump to whileLoop

endWhileLoop:

	fld upper				;push upper onto the stack
	fld lower				;push lower onto the stack
	fadd					;pops ST and ST(1), adds them, pushes sum onto the stack
	fdiv two				;divide ST by integer found at two, replaces ST by the quotient

	fst result

;C CODE
;double sqrtX(double x)
;{
;	const double ACCURACY=0.00001;			*
;	double lower, upper, guess;				*
;	double number;							*
;
;	number = x;								*
;	lower = 1;								*
;	upper = number;							*
;
;	while((upper-lower)>ACCURACY)			*
;	{
;		guess = (lower + upper) / 2;		*
;		if((guess * guess) > number)
;		{
;			upper = guess;
;		}
;		else
;		{
;			lower = guess;
;		}
;	}
;	return (lower + upper) / 2;
;}

main	ENDP

END
