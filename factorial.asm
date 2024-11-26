section .data
    prompt db "Enter a number: ", 0
    result_msg db "Factorial is: ", 0
    newline db 10, 0                  ; Newline character for output
    error_msg db "Invalid input!", 10, 0

section .bss
    input resb 10                     ; Reserve 10 bytes for input
    result resb 20                    ; Buffer to store factorial result as a string

section .text
    global _start

_start:
    ; Prompt user for input
    mov eax, 4                        ; Syscall number for sys_write
    mov ebx, 1                        ; File descriptor (stdout)
    mov ecx, prompt                   ; Address of prompt message
    mov edx, 17                       ; Length of prompt
    int 0x80                          ; Make syscall

    ; Read user input
    mov eax, 3                        ; Syscall number for sys_read
    mov ebx, 0                        ; File descriptor (stdin)
    mov ecx, input                    ; Address to store input
    mov edx, 10                       ; Number of bytes to read
    int 0x80                          ; Make syscall

    ; Null-terminate the input string
    mov byte [input + 9], 0

    ; Convert input ASCII to integer
    mov ecx, 0                        ; Initialize ECX (number accumulator)
    mov esi, input                    ; Pointer to input buffer

convert_input:
    lodsb                             ; Load next byte from input into AL
    cmp al, 10                        ; Check for newline
    je calculate_factorial            ; If newline, end of input
    sub al, '0'                       ; Convert ASCII to integer
    jl invalid_input                  ; If less than '0', invalid input
    cmp al, 9                         ; If greater than '9', invalid input
    jg invalid_input
    imul ecx, ecx, 10                 ; Multiply current number by 10
    add ecx, eax                      ; Add the new digit
    jmp convert_input

invalid_input:
    ; Display error message
    mov eax, 4
    mov ebx, 1
    mov ecx, error_msg
    mov edx, 14
    int 0x80
    jmp exit_program

calculate_factorial:
    ; Calculate factorial
    mov eax, ecx                      ; Move the input number to EAX
    call factorial                    ; Call factorial subroutine

    ; Convert result to string
    mov edi, result + 19              ; Point to the end of the result buffer
    call int_to_str                   ; Convert EAX to string

    ; Display result message
    mov eax, 4                        ; Syscall number for sys_write
    mov ebx, 1                        ; File descriptor (stdout)
    mov ecx, result_msg               ; Address of result message
    mov edx, 14                       ; Length of result message
    int 0x80                          ; Make syscall

    ; Display factorial result
    mov eax, 4
    mov ebx, 1
    mov ecx, edi                      ; Address of result string
    mov edx, result + 19
    sub edx, edi                      ; Calculate string length
    int 0x80                          ; Make syscall

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

exit_program:
    ; Exit the program
    mov eax, 1                        ; Syscall number for sys_exit
    xor ebx, ebx                      ; Exit code 0
    int 0x80

; Factorial subroutine
factorial:
    push ebp
    mov ebp, esp
    mov ebx, eax                      ; Copy input number to EBX
    mov eax, 1                        ; Initialize factorial result to 1

factorial_loop:
    cmp ebx, 1                        ; Check if counter is 1
    jle end_factorial                 ; If yes, end loop
    mul ebx                           ; EAX = EAX * EBX
    dec ebx                           ; Decrement counter
    jmp factorial_loop                ; Repeat loop

end_factorial:
    pop ebp
    ret

; Integer to string conversion
int_to_str:
    xor edx, edx                      ; Clear remainder
    mov esi, 10                       ; Divisor (base 10)

convert_loop:
    xor edx, edx                      ; Clear remainder
    div esi                           ; EAX = EAX / 10, remainder in EDX
    add dl, '0'                       ; Convert remainder to ASCII
    dec edi                           ; Move buffer pointer backward
    mov [edi], dl                     ; Store character in buffer
    test eax, eax                     ; Check if quotient is 0
    jnz convert_loop                  ; Repeat if not zero
    mov byte [edi - 1], 0             ; Null-terminate the string (optional)
    ret
