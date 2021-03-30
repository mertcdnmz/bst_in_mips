# bst_in_mips
Implement of some binary search tree operations in MIPS assembly language

Operations:

build (list, tree): This procedure will construct a binary search tree data structure from a list of integers. The address
of the first integer is in the list argument (assume the list is terminated by a special value,
-MAXINT (the negative integer with the largest possible absolute value)), and the address of the
place where the procedure should create the data structure in tree argument (assume there is enough
space for the tree structure). 

insert (value, tree): This procedure will create and put a new node (the value is given in $a0 register) to the binary
search tree (the address of the root node of the tree is in tree argument). The procedure will require
new space in memory for the new tree node, which can be obtained with the MIPS system call sbrk.
The address of the location where the new node was inserted should be stored in $v0 register.


find (value, tree): This procedure will try to find the value (given in $a0 register) in the binary search tree (the address
of the root node of the tree is in tree argument). The search result should be stored in $v0 register (If
found $v0 = 0, if not $v0 = 1). If the value is found in the tree, $v1 should should contain its
address.

print (tree) : This procedure will print the binary search tree (the address of the root node of the tree is in tree
argument) to the screen.


You can use SPIM simulator to develop and test your code. 

You can download SPIM simulator via http://spimsimulator.sourceforge.net/

