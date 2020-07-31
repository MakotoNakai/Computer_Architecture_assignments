
# SPIM S20 MIPS simulator.
# simple array addition routine (to be adapted by students for multiplication)
# $Header: $


	.data
saved_ret_pc:	.word 0		# Holds PC to return from main
m3:	.asciiz "The next few lines should contain exception error messages\n"
m4:	.asciiz "Done with exceptions\n\n"
m5:	.asciiz "Expect an address error exception:\n	"
m6:	.asciiz "Expect two address error exceptions:\n"

# here's our array data, two args and a result
	.data
	.globl array1
	.globl array2
	.globl array3
array1:	.float 3.14159265, 2.71828183, 1.0, -0.10, 1.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 1.0, -1.0, 1.0, -1.0, 1.0
array2:	.float 2.71828183, 1.0, 3.14159265, 1.0, 1.0, 0.0, 1.0, 0.0, -1.0, 1.0, -1.0, 1.0, 3.0, 2.0, 1.0, 0.0
array3:	.float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0

	.text
	.globl main
main:
	sw $31 saved_ret_pc

	.data
lb_:	.asciiz "Vector Multiplication\n"
lbd_:	.byte 1, -1, 0, 128
lbd1_:	.word 0x76543210, 0xfedcba98
	.text
	li $v0 4	# syscall 4 (print_str)
	la $a0 lb_
	syscall

# main program: add array1 & array2, store in array3
# first, the setup

	addi $t0 4	# iのloop counter

	la $t1 array1 
	la $t2 array2
	la $t3 array3

	addi $t4 0 #jのloop counter
	addi $t5 0 #kのloop counter

#### 現状：１番内側のループはできた ####

#### 計算結果：最初の要素しか計算できてない ####

#  Vector Multiplication
#  Done Multiplying
#  9.95801544
#  0.00000000
#  0.00000000
#  0.00000000
#  0.00000000
#  0.00000000
#  0.00000000
#  0.00000000
#  0.00000000
#  0.00000000
#  0.00000000
#  0.00000000
#  0.00000000
#  0.00000000
#  0.00000000
#  0.00000000
#  0.00000000

#### やりたいこと： 外側のループ(i, j)を実装して、array3の他の行・列の計算がしたい####


start_loop2: # jのloop

	beq $t4 4 end_loop2 # if j == 4 break

	start_loop3:  # kのloop

		beq $t5 4 end_loop3 # if k == 4 break

		lwc1 $f0 0($t1) # array1の値を取得
		lwc1 $f1 0($t2) # array2の値を取得

		nop
		mul.s $f2 $f1 $f0 # array1の値 x array2の値
		add.s $f3 $f3 $f2 # 和を表す変数に足す
		nop

		addi $t5 $t5 1 # k += 1
		addi $t1 $t1 4 # array1の1個右の要素に移動
		addi $t2 $t2 16 # array2の1個下の要素に移動

		swc1 $f3 0($t3) # array3の要素に計算結果をロード

		j start_loop3 # ループの最初に戻る

	end_loop3:	

	addi $t4 $t4 1 # j += 1
	addi $t2 $t2 -44 # array2の1個右の行の1番上に移動
	addi $t3 $t3 4 # array3の1つ右の要素に移動

	j start_loop2

end_loop2:




# Done adding...
	.data
sm:	.asciiz "Done Multiplying\n"
	.text
	li $v0 4	# syscall 4 (print_str)
	la $a0 sm
	syscall

# see the list of syscalls at e.g.
# http://www.inf.pucrs.br/~eduardob/disciplinas/arqi/mips/spim/syscall_codes.html
	la $a1 array3
	addi $t0 $0 16
ploop:	lwc1 $f12 0($a1)
	li $v0 2	# syscall 2 (print_float)
	syscall
	.data
sm2:	.asciiz "\n"
	.text
	li $v0 4	# syscall 4 (print_str)
	la $a0 sm2
	syscall

	addi $t0 $t0 -1
	addi $a1 $a1 4
	bne $t0 $0 ploop

# Done with the program!
	lw $31 saved_ret_pc
	jr $31		# Return from main