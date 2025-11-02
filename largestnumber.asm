ASSUME DS:DATA, CS:CODE

DATA SEGMENT
    MSG1    DB 0AH,0DH,"ENTER NUMBER OF ELEMENTS (1-9): $"
    MSG2    DB 0AH,0DH,"ENTER NUMBER: $"
    MSG3    DB 0AH,0DH,"THE LARGEST NUMBER IS: $"
    
    ARRAY   DB 10 DUP(?) ; Array to store up to 10 single digits
    COUNT   DB 0         ; Variable to store the count of elements
    LARGEST DB 0         ; Variable to store the largest number found
DATA ENDS

CODE SEGMENT
START:
    ; ===== INITIALIZE DATA SEGMENT =====
    MOV AX, DATA
    MOV DS, AX
    
    ; ===== PROMPT FOR ARRAY SIZE =====
    LEA DX, MSG1
    MOV AH, 09H     ; Display string function
    INT 21H
    
    ; ===== READ THE SIZE =====
    MOV AH, 01H     ; Read character function
    INT 21H
    SUB AL, 30H     ; Convert ASCII '0'-'9' to binary 0-9
    MOV COUNT, AL   ; Store the count
    
    ; Prepare loop counter (CX) and array pointer (SI)
    MOV CL, AL
    MOV CH, 0       ; Clear CH so CX holds the count
    LEA SI, ARRAY   ; Point SI to the start of ARRAY
    
    ; ===== LOOP TO READ ARRAY ELEMENTS =====
READ_LOOP:
    ; Display "ENTER NUMBER: $"
    LEA DX, MSG2
    MOV AH, 09H
    INT 21H
    
    ; Read the digit
    MOV AH, 01H
    INT 21H
    
    ; Store the ASCII digit directly into the array
    MOV [SI], AL
    
    INC SI          ; Move pointer to the next array slot
    LOOP READ_LOOP  ; Repeat CX times
    
    ; ===== FIND THE LARGEST NUMBER =====
    
    ; Reset loop counter and array pointer
    MOV CL, COUNT
    MOV CH, 0       ; Clear CH so CX holds the count
    LEA SI, ARRAY   ; Point SI back to the start of ARRAY
    
    ; Assume the first element is the largest
    MOV AL, [SI]
    MOV LARGEST, AL
    
    ; If count was only 1, skip the loop
    CMP CX, 1
    JE  DISPLAY_RESULT
    
    ; Point to the *second* element to start comparison
    INC SI
    DEC CX          ; Decrement counter since we already handled one
    
FIND_LOOP:
    MOV AL, [SI]    ; Get the next array element
    CMP LARGEST, AL ; Compare with current largest (e.g., '5' vs '7')
    
    JNL SKIP_UPDATE ; Jump if Not Less (if LARGEST is >= AL)
    
    ; If we are here, AL was larger, so update LARGEST
    MOV LARGEST, AL 
    
SKIP_UPDATE:
    INC SI          ; Move to next element
    LOOP FIND_LOOP  ; Repeat loop
    
    
    ; ===== DISPLAY THE RESULT MESSAGE =====
DISPLAY_RESULT:
    LEA DX, MSG3
    MOV AH, 09H
    INT 21H
    
    ; ===== DISPLAY THE LARGEST NUMBER =====
    MOV DL, LARGEST ; Move the largest ASCII character to DL
    MOV AH, 02H     ; Display character function
    INT 21H
    
    ; ===== EXIT PROGRAM =====
    MOV AH, 4CH     ; Terminate program
    INT 21H
    
CODE ENDS
END START