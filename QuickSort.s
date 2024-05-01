@ QuickSort.s
@ Kevin Siraki
@ 1/09/2024
@
@ QuickSort implementation in 32-bit ARM Assembly for Raspberry Pi

.data
.balign 4
format: .asciz "%d "
new: .byte '\n'
array: .int 82, 45, 17, 64, 29, 53, 98, 12, 36, 71, 50, 24, 88, 5, 42, 67, 11, 78, 33, 60

.text
.global main
.extern printf

print_array:
    push {ip, lr}
    mov r7, #0
    mov r4, r0               @ r0 contains the address of the sorted array
    mov r5, r1               @ r1 contains the length of the array
looper:
    ldr r0, =format         @ formatting to print
    ldr r1, [r4, r7, lsl #2]
    bl printf               @ print the element
    add r7, #1              @ for(int i=0;i<length, i++)
    cmp r7, r5
    blt looper
    ldr r0, =new                @ newline character
    bl printf
    pop {ip, pc}

quicksort:
    push {r4, r5, r6, ip, lr}   @ create a stack frame    
    mov r4, r0                 @ r0 contains the address of the array
    mov r5, r1                 @ r1 contains the low index
    mov r6, r2                 @ r2 contains the high index
    cmp r5, r6                  @ if low>high
    bge end                     @ return
    bl partition                @ call partition subroutine
    mov r8, r0                 @ r8 contains the pivot index
    sub r8, r8, #1             @ r8 contains the pivot index - 1
    add r9, r0, #1             @ r9 contains the pivot index + 1
    mov r0, r4
    mov r1, r5
    mov r2, r8
    bl quicksort                @ left call
    mov r0, r4
    mov r1, r9
    mov r2, r6
    bl quicksort                @ right call
end:
    pop {r4, r5, r6, ip, pc}    @ pop the stack, return

partition:
    push {ip, lr}
    mov r4, r0                 @ r0 contains the address of the array
    mov r5, r1                 @ r1 contains the low index
    mov r6, r2                 @ r2 contains the high index
    ldr r7, [r4, r6, lsl #2]    @ pivot = array[high]
    mov r8, r5  
    sub r8, #1                  @ i = low - 1;
    mov r3, r5                  @ j = low
loop:
    ldr r9, [r4, r3, lsl #2]    @ load array[j]
    cmp r9, r7                  @ if(array[j]>pivot)                                
    bgt endif                   @ skip
    add r8, #1                  @ i++
    ldr r10, [r4, r8, lsl #2]   @ load array[i] into r10 (swap)
    str r9, [r4, r8, lsl #2]    @ store array[j] into array[i]
    str r10, [r4, r3, lsl #2]   @ store array[i] into array[j]
endif:
    add r3, #1                  @ for(int j=low, j<high; j++)
    cmp r3, r6
    bne loop
endloop:
    add r8, #1
    ldr r9, [r4, r8, lsl #2]    @ load the value at array[pivot index] (swap)
    str r7, [r4, r8, lsl #2]    @ store the pivot into array[pivot index]
    str r9, [r4, r6, lsl #2]    @ store the original value (at pivot index) into array[high]
    pop {ip, lr}
    mov r0, r8                  @ return (i+1)
    bx lr

main:                           @ entry point
    push {ip, lr}
    ldr r0, =array
    mov r1, #0
    mov r2, #19
    bl quicksort                @ quicksort(array, 0, length-1)
    ldr r0, =array
    mov r1, #20
    bl print_array              @ print_array(array, length)
    pop {ip, pc}
