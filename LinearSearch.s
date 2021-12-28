#-----------intializatian of data----------------------------------------------------
.data  
array:.space 40 
st1:.asciiz "Enter the length of array:"        # asking for length of array
st2:.asciiz "Enter the items without repeat:"   #asking for items of array
st3:.asciiz "Enter item to search:"             #It asks for the item to be searched
errfound:.asciiz " : is the Index of item"      #If the item is found 
errNotFound: .asciiz "Item is not in the array" #If the item is found
#------------------------------------------------------------------------------------
.text
main:
  li $v0,4                            # it is used for printing string1
  la $a0,st1 
  syscall 
  
  li $v0,5                            # it is used for reading integer (the length of array)
  syscall
  
  add $t2,$v0,$0
  
  li $v0,4                            # it is used for printing string2
  la $a0,st2 
  syscall 
  
  mul $t3,$t2,4
  add $t4,$t4,$0
  jal arr
  li $v0, 10
  syscall
#---------------------------------------------------------------------------------------- 
arr:
  beq $t4,$t3,find
  li $v0,5 
  syscall
  sw $v0,array($t4) 
  add $t4,$t4,4 
  j arr
#-------------------------------------------------------------------------------------------  
find:
  li $v0,4 # it is used for printing string3
  la $a0,st3 
  syscall 
  
  li $v0,5# it is used for reading integer (the item of array)
  syscall
  
  add $t5,$v0,$0
  j main2
#----------------------------------------------------------------------------------------------
main2:
  addi $sp, $sp, -4           # Lower Stack Pointer
  sw $ra, 0($sp)              # Store return address into memory
  la $a0, array               # Load array into $a0        
  jal linearSearch            # Linear search the array
  li $t0, -1                  # Load not found flag for bne
  bne $v0, $t0, found         # If found:
  j notFound                  # If not found
#------------------------------------------------------------------------------------------
found:
  add $a0, $v0, $0            # Move $v1 into $a0  
  li $v0, 1                   # Load print integer sys
  syscall                     # Print the integer
  li $v0,4                    # it is used for printing string4
  la $a0,errfound
  syscall 
  j exit                      # Exit the program
#-------------------------------------------------------------------------------------------
notFound:
  la $a0, errNotFound         # Load not found text into $a0
  li $v0, 4                   # Load print string syscall
  syscall                     # Print the string
  j exit                      # Exit the program
#------------------------------------------------------------------------------------------
exit:
  lw $ra, 0($sp)              # Load the return address
  addi $sp, $sp, 4            # Raise the stack pointer
  jr $ra                      # Return
#---------------------------------------------------------------------------------------------
linearSearch:
  li $t0, 0                   # Load 0 into the index
  j linearLoop                # Loop
#---------------------------------------------------------------------------------------------
linearLoop:
  bge $t0, $t2, linearFailed  # If $t0 > $a2, we are outside the array
  lw $t1, 0($a0)              # Load the element into t1
  beq $t1, $t5, linearFound   # Found the element
  addi $a0, $a0, 4            # Add 4 (1 word index) to the array
  addi $t0, $t0, 1            # Add one to the index
  j linearLoop
#---------------------------------------------------------------------------------------------
linearFound:
  add $v0, $t0, $0            # Move $t0 into $v0
  jr $ra                      # Return
#---------------------------------------------------------------------------------------------
linearFailed:
  li $v0, -1                  # Load failed search
  jr $ra                      # Return
