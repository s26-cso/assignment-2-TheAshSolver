.section .text
.global make_node
.global insert
.global get
.global getAtMost

# "Yggdrasil’s ash suffers more agony
# than men can know:
# a hart bites from above, it rots at the side,
# Nithhogg gnaws from below."

#first function to make is the make node that simply calls malloc
#arguments are a0- value.
#size of struct is 20. 4 for int, 8 for first pointer and 8 for second pointer
make_node:
    addi sp, sp, -16
    sd s1, 0(sp)
    sd ra, 8(sp)
    mv s1, a0
    li a0, 24
    call malloc
    sw s1, 0(a0)
    mv t1, x0
    sd t1, 8(a0)
    sd t1, 16(a0)
    ld s1, 0(sp)
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

#insert node. Here, a0 is the pointer to the root and a1 is the value to be inserted
#how to use this. Use a recursive function. If current a0 is null, call make node and return
# if not null, check if val is greater or lesser. Then, call insert on the left or the right
#store that value 
#question mentions set. So no repetition of integers
insert:
    addi sp, sp, -32            # store the current return value, first argument, second argument and t1
    sd ra, 0(sp)
    sd t1, 8(sp)
    sd a0, 16(sp)
    sd a1, 24(sp)
    beq a0, x0, base_case
    lw t1, 0(a0)                #this is the integer val
    bge a1, t1, right           #if current value is greater than root, go to right
    ld a0, 8(a0)                #left case
    call insert                 #recursive call
    ld t2, 16(sp)               #loading the address of the root once again
    sd a0, 8(t2)                #replacing the old left value with the new left value
common:                         #stuff common to both branches
    mv a0, t2
    ld a1, 24(sp)
    ld ra, 0(sp)
    ld t1, 8(sp)
    addi sp, sp, 32
    ret
right:
    ld a0, 16(a0)                #right case
    call insert                 #recursive call
    ld t2, 16(sp)               #loading the address of the root once again
    sd a0, 16(t2)               #replacing the old right value with the new left value
    j common


base_case:
    mv a0, a1
    call make_node
    ld ra, 0(sp)
    ld t1, 8(sp)
    ld a1, 24(sp)
    addi sp, sp, 32
    ret

# get. This should return pointer to the node or 0. 
#Another recursive function. If current node is 0, return. Else, check if value is equal or less. 
# if value is less, repeat in the left. 
# if value is greater, repeat in the right

get:
    addi sp, sp, -24
    sd a0, 0(sp)
    sd a1, 8(sp)
    sd ra, 16(sp)
    beqz a0, null_case              #check for null case
    lw t1, 0(a0)                    #load the value
    beq t1, a1, found_case          #check if current value has value we are looking for
    blt t1, a1, right_case          #since value of root less than value, go right     
    ld a0, 8(a0)                    #load the left value of the current pointer
    call get                        #do recrusive call
    ld ra, 16(sp)                   #a0, contains the pointer
    addi sp, sp, 24                 #increase the stack
    ret                             #return the value
    

right_case:
    ld a0, 16(a0)                   #load the right value of the current pointer
    call get                        #do recrusive call
    ld ra, 16(sp)                   #a0, contains the pointer
    addi sp, sp, 24                 #increase the stack
    ret                             #return the value

found_case:
    ld ra, 16(sp)                   #found, so get return address
    addi sp, sp, 24                
    ret                             #pointer is the current argument only, so return itself

null_case:
    ld ra, 16(sp)
    addi sp, sp, 24
    ret
    


#getAtMost
#do this via loop for a change. 
#store a temporary variable with -1.
#run loop till root becomes 0. if value of root is smaller, put that into temp and go right
# else go left without updating temp
getAtMost:
    li t1, -1
    mv a3, a1                           #store address in temp variable
    mv a4, a0                           #store the value in temp variable
loop:
    beqz a3, base_case_1                #check if address is 0
    lw t2, 0(a3)                        #load the value
    bgt t2, a4, go_left                 #if current value is higher than lookup value, go left
    mv t1, t2                           #update temp variable
    ld a3, 16(a3)                       #go right
    j loop
go_left:
    ld a3, 8(a3)
    j loop
base_case_1:
    mv a0, t1
    ret
