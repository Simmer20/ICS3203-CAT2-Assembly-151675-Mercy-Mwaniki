section .data
    msg_prompt db "Enter a number: ", 0    ; Prompt message
    msg_positive db "POSITIVE", 10, 0     ; Message for positive
    msg_negative db "NEGATIVE", 10, 0     ; Message for negative
    msg_zero db "ZERO", 10, 0             ; Message for zero

section .bss
    input resb 5                         ; Buffer for user input

section .text
    global _start

_start:
    ; Print the prompt message
    mov eax, 4                           ; sys_write syscall
    mov ebx, 1                           ; File descriptor (stdout)
    mov ecx, msg_prompt                  ; Message address
    mov edx, 15                          ; Message length
    int 0x80                             ; Call kernel

    ; Read user input
    mov eax, 3                           ; sys_read syscall
    mov ebx, 0                           ; File descriptor (stdin)
    mov ecx, input                       ; Buffer address
    mov edx, 5                           ; Buffer size
    int 0x80                             ; Call kernel

    ; Convert input to number
    mov eax, 0                           ; Clear eax
    mov esi, input                       ; Point to input buffer
    call atoi                            ; Convert string to integer

    ; Branching logic
    cmp eax, 0                           ; Compare with 0
    je is_zero                           ; Jump if eax == 0
    jl is_negative                       ; Jump if eax < 0
    jmp is_positive                      ; Unconditional jump

is_positive:
    ; Print "POSITIVE"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_positive
    mov edx, 9
    int 0x80
    jmp exit                             ; Exit program

is_negative:
    ; Print "NEGATIVE"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_negative
    mov edx, 9
    int 0x80
    jmp exit                             ; Exit program

is_zero:
    ; Print "ZERO"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_zero
    mov edx, 5
    int 0x80

exit:
    ; Exit program
    mov eax, 1                           ; sys_exit syscall
    xor ebx, ebx                         ; Exit code 0
    int 0x80

; Subroutine: atoi (convert string to integer)
atoi:
    xor ebx, ebx                         ; Clear ebx (result)
atoi_loop:
    movzx edx, byte [esi]                ; Load byte from input
    cmp edx, 10                          ; Check for newline
    je atoi_done                         ; Exit loop if newline
    sub edx, '0'                         ; Convert ASCII to integer
    imul ebx, ebx, 10                    ; Multiply result by 10
    add ebx, edx                         ; Add digit to result
    inc esi                              ; Move to next character
    jmp atoi_loop                        ; Repeat
atoi_done:
    mov eax, ebx                         ; Move result to eax
    ret