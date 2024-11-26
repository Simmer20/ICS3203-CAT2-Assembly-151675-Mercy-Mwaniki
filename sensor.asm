section .data
    sensor_value db 0           ; Sensor value (water level)
    motor_status db 0           ; Motor state: 0 = off, 1 = on
    alarm_status db 0           ; Alarm state: 0 = off, 1 = on

    high_threshold db 8         ; High water level threshold
    moderate_threshold db 5     ; Moderate water level threshold

    msg_motor_on db "Motor is ON", 10, 0
    msg_motor_off db "Motor is OFF", 10, 0
    msg_alarm_on db "Alarm is ON", 10, 0
    msg_alarm_off db "Alarm is OFF", 10, 0
    msg_high_level db "High water level detected!", 10, 0
    msg_moderate_level db "Moderate water level detected.", 10, 0
    msg_low_level db "Low water level detected.", 10, 0

section .text
    global _start

_start:
    ; Read sensor value
    mov al, [sensor_value]      ; Load sensor value into AL

    ; Compare with thresholds
    mov bl, [high_threshold]    ; Load high threshold
    cmp al, bl                  ; Compare sensor value with high threshold
    jg high_water_level         ; If > high threshold, go to high_water_level

    mov bl, [moderate_threshold]; Load moderate threshold
    cmp al, bl                  ; Compare sensor value with moderate threshold
    jg moderate_water_level     ; If > moderate threshold, go to moderate_water_level

    ; Default action: low water level
    call low_water_level
    jmp end_program

high_water_level:
    ; High water level: turn on alarm, stop motor
    mov byte [alarm_status], 1  ; Set alarm on
    mov byte [motor_status], 0  ; Turn off motor

    ; Display messages
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_high_level
    mov edx, 27
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_alarm_on
    mov edx, 14
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_motor_off
    mov edx, 15
    int 0x80

    jmp end_program

moderate_water_level:
    ; Moderate water level: stop motor, no alarm
    mov byte [motor_status], 0  ; Turn off motor
    mov byte [alarm_status], 0  ; Turn off alarm

    ; Display messages
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_moderate_level
    mov edx, 32
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_alarm_off
    mov edx, 14
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_motor_off
    mov edx, 15
    int 0x80

    jmp end_program

low_water_level:
    ; Low water level: turn on motor, no alarm
    mov byte [motor_status], 1  ; Turn on motor
    mov byte [alarm_status], 0  ; Turn off alarm

    ; Display messages
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_low_level
    mov edx, 26
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_motor_on
    mov edx, 14
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_alarm_off
    mov edx, 14
    int 0x80

    ret

end_program:
    ; Exit program
    mov eax, 1                  ; syscall: sys_exit
    xor ebx, ebx                ; exit code 0
    int 0x80                    ; call kernel
