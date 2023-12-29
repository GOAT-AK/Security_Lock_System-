include emu8086.inc          ; Include emu8086 library for assembly code
.MODEL SMALL                 ; Define the memory model as SMALL
.DATA   
        SIZE EQU 10          ; Define a constant SIZE with the value 10
        HEAD DB '________________Security lock________________','$'    ; Define a string for the header
        MSG1 DB 13, 10, 'Enter your ID:$'     ; Define a string for the ID input prompt
        MSG2 DB 13, 10, 'Enter your Password:$'      ; Define a string for the password input prompt
        MSG3 DB 13, 10, 'ERROR ID not Found!$'       ; Define  a string for ID not found error message
        MSG4 DB 13, 10, 'Wrong Password! Access denied$'     ; Define a string for the wrong password error message
        MSG5 DB 13, 10, 'Correct! Welcome to the Safe$'     ; Define a string for the correct password access message
        MSG6 DB 13, 10, 'Too Long password!$'  ; Define a string for the too long password error message
        TEMP_ID DW 1 DUP(?),0      ; Define a temporary buffer for storing the entered ID
        TEMP_Pass DB 1 DUP(?)     ; Define a temporary for buffer for storing the entered password
        IDSize = $-TEMP_ID       ; Calculate the size of the ID buffer
        PassSize = $-Temp_Pass     ; Calculate the size of the password buffer
        ID  DW        'A150', 'B255', 'CE20', 'BB71', 'D111', 'E500', 'F432', 'EC12', '5321', '9876'   ; Define an array of valid account IDs
        Password DB   1,      2,      3,      4,       7,     10,     11,     13,     12,      14      ; Define an array of corresponding passwords
    
.CODE
MAIN        PROC
            MOV AX,@DATA     ; Iinitialize the data segment 
            MOV DS,AX        ; Set DS to point to the data segment
            MOV AX,0000H     ; Initialize AX register with 0
            

Title:      LEA DX,HEAD      ; Load the effective address of the header into DX
            MOV AH,09H       ; Set AH to 09H for printing string function
            INT 21H          ; Call interrupt to print the header 

ID_PROMPT:  LEA DX,MSG1      ; Load the effective address of the ID input prompt into DX
            MOV AH,09H       ; Set AH to 09H for printing string function
            INT 21H          ;  Call interrupt to print the ID input prompt
            
            
ID_INPUT:   MOV BX,0         ; Initialize BX register to 0
            MOV DX,0         ; Initialize DX register to 0
            LEA DI,TEMP_ID   ; Load the effective address of TEMP_ID into DI
            MOV DX,IDSize    ; Load the size of ID buffer into DX
            CALL get_string  ; Call a subroutine to get a string input from the user
            

CheckID:    MOV BL,0         ; Initialize BL register to 0
            MOV SI,0         ; Initialize SI register to 0

AGAIN:      MOV AX,ID[SI]    ; Load the value from the ID array into AX
            MOV DX,TEMP_ID   ; Load the value from TEMP_ID into DX
            CMP DX,AX        ; Compare the entered ID with the valid ID
            JE  PASS_PROMPT  ; Jump to PASS_PROMPT if they match 
            INC BL           ; Increment BL (counter)
            ADD SI,4         ; Move to the next ID in the array
            CMP BL,SIZE      ; Compare BL with size
            JB  AGAIN        ; Jump to AGAIN if BL is less than size
            
ERRORMSG: 
            LEA DX,MSG3      ; Load the effective address of the ID not found error message into DX
            MOV AH,09H       ; Set AH to 09H for printing string function
            INT 21H          ; Call interrupt to print the error message
            JMP ID_PROMPT    ; Jump to ID_PROMPT to re-enter the ID
                            
            
PASS_PROMPT:LEA DX,MSG2      ; Load the effective address of the password input prompt into DX
            MOV AH,09H       ; Set AH to 09H for printing string function
            INT 21H          ; Call interrupt to print the password input prompt
            
Pass_INPUT: CALL   scan_num  ; Call a subroutine to scan a numerical input
            CMP  CL,0FH      ; Compare the length of the entered password with 15 (0FH)
            JAE  TooLong     ; Jump to TooLong if the password is too long
            MOV  BH,00H      ; Initalize BH register to 0
            MOV  DL,Password[BX]  ; Load the value from the password array into DL
            CMP  CL,DL       ; Compare the length of the entered password with the valid password
            JE   CORRECT     ; Jump to CORRECT if they match

            
INCORRECT:  LEA DX,MSG4      ; Load the effective address of the wrong password error message into DX
            MOV AH,09H       ; Set AH to 09H for printing string function
            INT 21H          ; Call interrupt to print the error message 
            JMP ID_PROMPT    ; Jump to ID_PROMPT to re-enter the ID
            
CORRECT:    LEA DX,MSG5      ; Load the effective address of the correct access message into DX
            MOV AH,09H       ; Set AH to 09H for printing string function
            INT 21H          ; Call interrupt to print the message 
            JMP Terminate    ; Jump to Terminate to end the program

TooLong:    LEA DX,MSG6      ; Load the effective address of the too long password error message into DX
            MOV AH,09H       ; Set AH to 09H for printing string function
            INT 21H          ; Call interrupt to print the error message 
            JMP PASS_PROMPT  ; Jump to PASS_PROMPT to re-enter the password
            

DEFINE_SCAN_NUM
DEFINE_GET_STRING
Terminate:        
END MAIN         ; End of the MAIN procedure    
        
    
     
