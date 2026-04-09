#use open at and lseek to do this
#first thing is to get the file pointer using openat
#use read to get it from the file   
.section .bss
left_string:
.byte 0
right_string:
.byte 0

.section .rodata
success:
.asciz "Yes"
failure:
.asciz "No"
filename:
.asciz "input.txt"
.section .text
.globl main
main:
    addi sp, sp, -32
    sd ra, 0(sp)
    sd s1, 8(sp)
    sd s2, 16(sp)
    sd s3, 24(sp)
    li a0, -100             #first argument
    lla a1, filename        #second argument
    li a2, 0                #third argument - makes it read only
    li a3, 0                #last argument, required only for writing
    call openat             #calls the function itself

    #<---------------------- now a0 contains the file pointer ------------------------->
    mv s0, a0               #store the file pointer in permanent register
    li a1, 0                #calling lseek to get the total lenght of the string
    li a2, 2                #specifying lseek end
    call lseek              #goes to the end and returns length of the string in a0
    mv s1, a0               #store the length of the string in s1
    addi s1, s1, -1         #last position is one less than the length of the string, assuming no backslash n
    #<--------------------- Do the comparison now ---------------------------------->
    li s2, 0                #left variable 
    mv s3, s1               #right variable
loop:
    blt s3, s2, true
    mv a0, s0               #a0, contains file pointer
    mv a1, s2               #a1 contains 0ffset
    li a2, 0                #specifies lseek start
    call lseek              #goes to that spot in the file
    mv a0, s0               #again put file pointer in a0
    lla a1, left_string     #store address in a1
    li a2, 1                #how much to read
    call read               #stores left value at left_string

    mv a0, s0               #repeating the same for right
    mv a1, s3               #initialize offset
    li a2, 0                #lseek zero only
    call lseek              #call lseek zero
    mv a0, s0               #initialize for read
    lla a1, right_string    #store the value
    li a2, 1                #same one byte only
    call read               # call read

    lbu a1, left_string     #read a1
    lbu a2, right_string    #read a2
    bne a1, a2, not_true    #go to not true branch
    addi s2, s2, 1
    addi s3, s3, -1
    j loop

not_true:
    lla a0, failure
    call printf
    ld ra, 0(sp)
    ld s1, 8(sp)
    ld s2, 16(sp)
    ld s3, 24(sp)
    ret
true:
    lla a0, success
    call printf
    ld ra, 0(sp)
    ld s1, 8(sp)
    ld s2, 16(sp)
    ld s3, 24(sp)
    ret












