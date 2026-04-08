#use a stack. A stack is going to be a custom array along with a pointer keeping track of remaining space
.section .rodata
fmt:
.asciz "%d "
.section .bss
buffer:
stack:
.space 10000
array:
.space 10000
result:
.space 100000
.section .text
.global main
#a0 stores the number of command line arguments
#a1 stores the address to the array of elements.
#note that these are string pointer so I need to use atoi to convert them properly
main:
addi sp, sp, -48
sd ra, 0(sp)
sd a0, 8(sp)
sd a1, 16(sp)
sd s1, 24(sp)
sd s2, 32(sp)
                        #now, initialize the array in the the array space. This will help going through the array in the future
mv s1, a0               #s1 stores the number of command line arguments
addi s1, s1, -1
addi a1, a1, 8          #first argument is program name
loop:
ld a1, 16(sp)
beqz s1, done           #if s1 goes zero, go out of the loop
slli s2, s1, 3          #multiply the pointer by 8
add s2, s2, a1          #take the address of the last element
ld s2, 0(s2)            #take the string from that address
mv a0, s2               #move it into a0
call atoi               #call atoi to convert that into int
lla a3, array          #store the address of array in a3
slli s2, s1, 2          #since int, shift left by 2
addi s2, s2, -4         #make array 0 indexed
add a3, a3, s2          #go to that place
sw a0, 0(a3)            #store the int in that place
addi s1, s1, -1         #decrement by one after the loop
j loop                  #go to the top of the loop

done:                   #now, all ints have been stored in array
li s2, 0                #stores the size of the stack
ld a0, 8(sp)            #store the number of elements in a0 again
ld a1, 16(sp)           #restores a1 again
mv t1, a0               #t1 stores the number of elements
addi t1, t1, -1         #removing one because I later learnt a0 includes file name as well
lla a3, array          #stores the address of the array at 3
lla a4, stack          #stores starting value of stack
lla a5, result          #array for result
second_loop:
beqz t1, cooked         #if number of elements goes to 0, we are finished
addi t1, t1, -1         #subtract by one because 0 indexing and this works naturally
slli t2, t1, 2          #shift by 2 cause integer
add a6, t2, a5          #result array position
add t2, t2, a3         #address of the integer
lw t3, 0(t2)            #load integer itself
    #<---------------- ACTUAL LOGIC BEGINS MY BELOVED TA ----------------------->
stack_loop:
beqz s2, negative_one   #if size of stack is 0, put -1
addi s3, s2, -1         #decrease s2 by 1
slli s3, s3, 2          #multiply by 2 since stack stores integers
add s3, a4, s3         #go to the spot in the array
lw s3, 0(s3)            #Load the value itself
slli s5, s3, 2          #multiply by 2 cause index
add s5, s5, a3          #now, increment to get to array position
lw s5, 0(s5)            #load the number
bgt s5, t3, sufficient  #the stack element is greater than the element from the array
addi s2, s2, -1         #decrease size of stack by 1
j stack_loop            #go back to stack loop
sufficient:
sw s3, 0(a6)            #store the stack value in the original array
slli s4, s2, 2          #shift left by 2 the size of the stack
add s4, s4, a4         #the free spot in the stack
sw t1, 0(s4)            #store the current value in the stack
addi s2, s2, 1          #increment stack by 1
j second_loop

negative_one:
li s3, -1               #goes one below
sw s3, 0(a6)            #store the stack value in the original array
slli s4, s2, 2          #shift left by 2 the size of the stack
add s4, s4, a4         #the free spot in the stack
sw t1, 0(s4)            #store the current value in the stack
addi s2, s2, 1          #increment stack by 1
j second_loop

cooked:
mv s2, a0               
addi s2, s2, -1         #number of elements is one less than number of arguments
li s1, 0                #start the counter and 0
last_loop:
beq s1, s2, done_2        #check if counter reaches a0
lla a3, array          #load the start of the array
lla a6, result          #load the result array
slli s3, s1, 2          #shift by 2
add s3, a6, s3          #identify address
lw s3, 0(s3)            #load the value
mv a1, s3               #put it as argumnet
lla a0, fmt             #put string argumnet
call printf             #if you dont understand what this means, you cannot be taing this course
addi s1, s1, 1          #what do you think this does?
j last_loop            

done_2:
ld ra, 0(sp)
ld a0, 8(sp)
ld a1, 16(sp)
ld s1, 24(sp)
ld s2, 32(sp)
addi sp, sp, 48
ret


#<------------after 3 hours of debugging, this works. Atleast I hope so ----------------->











