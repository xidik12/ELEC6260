;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     Brian Arnberg - ELEC6260           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     Problem Set 3, Problem 2           ;;
;;       Execute the C program            ;;
;;                                        ;;
;;                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Define the CODE block
	AREA	RESET, CODE
	; Begin
	ENTRY
__main	LDR r13, =StackEnd
	; int a
	LDR r5, =aa		; Address of aa to r0
	; k = 0;
	LDR r0, =kk		; Get Address of kk
	MOV r1, #0		; Set r1 to 0
	STR r1, [r0]		; Store r1 (#0) to r0 ([kk])
	; f3(3)
	MOV r5, #3		; Put argument (#3) in r5
	STR r5, [r13, #-4]!	; Push argument (#3) to stack
	BL func3
	ADD r13, #4		; POP argument off of stack
	; a = f2(2)
	MOV r1, #2
	STR r1, [r13, #-4]!	; Push argument (#2) to stack
	BL func2
	LDR r0, =aa		; Get address for aa
	LDR r1, [r13], #4	; Get returned value from f2
	STR r1, [r0]		; Store returned value to aa
halt	B halt		; branch to self, halt program

;; int f1(int x1, int x2) {
;; 	return x1 + x2;
;; }
func1	
	LDR r0, [r13], #4	; Take 1st argument from stack, then change sp
	LDR r1, [r13], #4	; Take 2nd argument from stack, then change sp	
	ADD r0, r0, r1		; Add arg1 and arg2, then put in r0
	STR r0, [r13, #-4]!	; Store result to stack
	BX r14 ; Return from function
;; int f2(int x1) {
;; 	return x1 + 1;
;; }
func2
	LDR r0, [r13]		; Load argument from stack
	ADD r0, #1		; Add 1 to the argument
	STR r0, [r13]		; Store result to stack, save over previous value
	BX r14	; Return from function
;; void f3(int r) {
;;	int j;
;;	for (j=0; j<2; j++)
;;		k = k + f1(r+j, 5);
;; }
func3
	LDR r7, [r13]		; load argument from stack
	STR r14, [r13, #-4]!	; Put current return address in stack
	EOR r5, r5, r5		; Use r5 for j, Clear all bits
	MOV r6, #2		; Use for N
loopf3	CMP r5, r6	; Compare j to 2
	BGE endf3		; if j >= 2, branch to endf3
	ADD r0, r7, r5		; Compute r + j
	MOV r1, #5		; Set r1 to 5
	STR r5, [r13, #-4]!	; PUSH j to stack
	STR r6, [r13, #-4]!	; PUSH N to stack
	STR r7, [r13, #-4]!	; PUSH Argument to stack
	STR r0, [r13, #-4]!	; PUSH first argument to f1 to stack
	STR r1, [r13, #-4]!	; PUSH second argument to f1 to stack
	BL func1	; Call f1(r + j, 5)
	LDR r2, [r13], #4	; Get returned value	
	LDR r7, [r13], #4	; Get Argument from stack
	LDR r6, [r13], #4	; Get N
	LDR r5, [r13], #4	; Get j
	LDR r10, =kk		; Get address of kk
	LDR r3, [r10]		; Store current kk to r3
	ADD r2, r2, r3		; SUM k and result of the function call		
	STR r2, [r10]		; Store k
	ADD r5, r5, #1		; Increment j
	B loopf3
endf3	
	LDR r14, [r13], #4	; Get return address from stack
	BX r14	; Return from function

	; Define the  DATA block
	AREA	data1, DATA
	; Set aside stack area
Stack 	SPACE 40		; Make stack 10 words long
StackEnd
	; Set space aside for variables
kk	SPACE 4
aa	SPACE 4
	END