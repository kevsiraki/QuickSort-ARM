
QuickSort Implementation
========================

This repository contains implementations of the QuickSort algorithm in both ARM assembly language for Raspberry Pi and C programming language.

Contents
--------

1.  [ARM Assembly Implementation](#arm-assembly-implementation)
2.  [C Implementation](#c-implementation)
3.  [QuickSort Algorithm](#quicksort-algorithm)
4.  [Sample Output](#sample-output)

# ARM Assembly Implementation
---------------------------

The ARM assembly implementation of QuickSort is designed for bare-metal Raspberry Pi. It provides functions for sorting an integer array using the QuickSort algorithm. The implementation includes functions for partitioning the array and printing the sorted array.

```assembly
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
```

# C Implementation
----------------

The C implementation of QuickSort provides functions for sorting an integer array using the QuickSort algorithm. It includes a partition function and a QuickSort function.

### File: `quickSort.c`

c

Copy code

```c
#include <stdio.h>

int partition(int array[], int low, int high) {
    int pivot = array[high];
    int i = (low - 1);
    for (int j = low; j < high; j++) {
        if (array[j] <= pivot) {
            i++;
            int temp = array[i];
            array[i] = array[j];
            array[j] = temp;
        }
    }
    int temp = array[i + 1];
    array[i + 1] = array[high];
    array[high] = temp;
    return (i + 1);
}

void quickSort(int array[], int low, int high) {
    if (low < high) {
        int pi = partition(array, low, high);
        quickSort(array, low, pi - 1);
        quickSort(array, pi + 1, high);
    }
}

int main() {
    int array[] = {82, 45, 17, 64, 29, 53, 98, 12, 36, 71, 50, 24, 88, 5, 42, 67, 11, 78, 33, 60};
    int length = sizeof(array) / sizeof(array[0]);
    quickSort(array, 0, length - 1);
    printf("Sorted array: ");
    for (int i = 0; i < length; i++) {
        printf("%d ", array[i]);
    }
    printf("\n");
    return 0;
}

```

# QuickSort Algorithm
-------------------

QuickSort is a widely used sorting algorithm based on the divide-and-conquer strategy. It works by selecting a 'pivot' element from the array and partitioning the other elements into two sub-arrays according to whether they are less than or greater than the pivot. The process is then recursively applied to the sub-arrays.

## Sample Output
-------------

After sorting the given array using QuickSort algorithm, the output is as follows:


`Sorted array: 5 11 12 17 24 29 33 36 42 45 50 53 60 64 67 71 78 82 88 98`

This output demonstrates the sorted array after applying the QuickSort algorithm to the given array.

Usage
-----

To use these implementations:

1.  Clone the repository.
2.  Compile the ARM assembly program using the appropriate toolchain for Raspberry Pi.
	- as -o QuickSort.o QuickSort.s
	- gcc -o QuickSort QuickSort.o
	- chmod +x QuickSort
	- ./QuickSort
3.  Compile the C program using a C compiler.
	- gcc -o QuickSort QuickSort.c
	- chmod +x QuickSort
	- ./quickSort
5.  Execute the compiled programs to observe the sorting results.

Contribution
------------

Contributions are welcome! If you find any issues or have suggestions for improvements, feel free to open an issue or create a pull request.

License
-------

This project is licensed under the MIT License.
