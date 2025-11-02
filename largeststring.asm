ASSUME DS:DATA, CS:CODE

DATA SEGMENT
    MSG1    DB 0AH,0DH,"ENTER NUMBER OF STRINGS (1-9): $"
    MSG2    DB 0AH,0DH,"ENTER STRING: $"
    MSG3    DB 0AH,0DH,"THE LONGEST STRING IS: $"
    
    ; An array to hold the POINTERS to the strings
    ARRAY   DW 10 DUP(?)
    COUNT   DB 0         ; How many strings the user will enter
    
    ; A large buffer to store all the string characters
    STR_BUFFER  DB 256 DUP(?)
    
    ; A pointer to keep track of the next free spot in the buffer
    BUFF_PTR    DW STR_BUFFER
    
    ; --- NEW VARIABLES ---
    LONGEST_LEN DW 0     ; Stores the LENGTH of the longest string
    LONGEST_PTR DW 0     ; Stores the OFFSET of the longest string
DATA ENDS

CODE SEGMENT
START:
    ; ===== INITIALIZE DATA SEGMENT =====
    MOV AX, DATA
    MOV DS, AX
    
    ; ======================================================
    ;  PART 1: READ ALL STRINGS (Identical to before)
    ; ======================================================
    
    LEA DX, MSG1
    MOV AH, 09H
    INT 21H
    
    MOV AH, 01H
    INT 21H
    SUB AL, 30H
    MOV COUNT, AL
    
    MOV CL, AL
    MOV CH, 0
    LEA SI, ARRAY   ; SI points to the start of the pointer array

READ_LOOP:
    LEA DX, MSG2
    MOV AH, 09H
    INT 21H
    
    MOV DI, BUFF_PTR
    MOV [SI], DI

READ_CHAR_LOOP:
    MOV AH, 01H
    INT 21H
    
    CMP AL, 0DH
    JE  END_STRING
    
    MOV [DI], AL
    INC DI
    JMP READ_CHAR_LOOP

END_STRING:
    MOV AL, '$'
    MOV [DI], AL
    INC DI
    
    MOV BUFF_PTR, DI
    ADD SI, 2
    LOOP READ_LOOP

    ; ======================================================
    ;  PART 2: FIND THE LONGEST STRING (New Logic)
    ; ======================================================

    ; Initialize loop
    LEA SI, ARRAY       ; SI points to the start of the pointer array
    MOV CL, COUNT
    MOV CH, 0
    MOV CX, CX          ; CX now holds the count
    
FIND_LOOP:
    ; Get the offset of the current string
    MOV DI, [SI]
    
    ; Save registers used by outer loop
    PUSH SI
    PUSH CX
    
    ; --- INNER LOOP: Count characters of current string ---
    XOR CX, CX          ; Use CX as the length counter
    
COUNT_LOOP:
    CMP BYTE PTR [DI], '$'
    JE  COUNT_DONE
    
    INC CX              ; Increment length
    INC DI              ; Move to next char
    JMP COUNT_LOOP
    
COUNT_DONE:
    ; Now CX holds the length of the current string
    
    ; Compare current length (CX) with the longest found so far
    CMP CX, LONGEST_LEN
    JBE KEEP_OLD_LONGEST ; Jump if Below or Equal

    ; --- Found a new longest string ---
    MOV LONGEST_LEN, CX  ; Save new longest length
    
    ; Restore SI (which points to ARRAY)
    POP CX               ; (Popping CX just to get to SI)
    POP SI
    
    ; Get offset of the string we just measured (it's the new longest)
    MOV AX, [SI]
    MOV LONGEST_PTR, AX  ; Save the offset of the new longest string
    
    ; Put registers back for outer loop
    PUSH SI
    PUSH CX
    JMP DONE_COMPARE
    
KEEP_OLD_LONGEST:
    ; Do nothing, just pop registers and continue
DONE_COMPARE:
    POP CX
    POP SI
    
    ADD SI, 2           ; Move to the next string pointer in ARRAY
    LOOP FIND_LOOP      ; Repeat outer loop
    

    ; ===== DISPLAY THE RESULT MESSAGE =====
DISPLAY_RESULT:
    LEA DX, MSG3
    MOV AH, 09H
    INT 21H
    
    ; ===== DISPLAY THE LONGEST STRING =====
    MOV DX, LONGEST_PTR ; DX now holds the offset of the longest string
    MOV AH, 09H
    INT 21H
    
    ; ===== EXIT PROGRAM =====
    MOV AH, 4CH
    INT 21H
    
CODE ENDS
END START