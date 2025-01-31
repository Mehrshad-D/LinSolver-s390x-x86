
.data
    print_int_format:  .asciz "%d"
    print_uint_format: .asciz "%u"
    read_int_format:   .asciz "%d"
    read_uint_format:  .asciz "%u"
    read_float_format:   .asciz "%lf"
    print_float_format:  .asciz "%.3lf"

    impossible: .asciz "Impossible\0"

    A: .zero 8000000
    B: .zero 8000 
    N: .zero 8

    zero: .zero 8
    neg:  .long   -1074790400
          .long   0

    result: .zero 8000

    tmp1: .zero 8
    tmp2: .zero 8
    tmp3: .zero 8

.text
.globl print_int
.globl print_char
.globl print_nl
.globl print_string
.globl read_int
.globl read_uint
.globl read_char
.globl print_float
.globl read_float
.globl asm_main

print_int:
	stg     %r14, -4(%r15)
    lay     %r15, -8(%r15)
    lr      %r3,  %r2
    larl    %r2,  print_int_format
    brasl   %r14, printf
	lay     %r15, 8(%r15)
	lg      %r14, -4(%r15)
    br      %r14

print_float:
	stg     %r14, -8(%r15)
    lay     %r15, -168(%r15)
    lr      %r3,  %r2
    larl    %r2,  print_float_format
    brasl   %r14, printf
	lay     %r15, 168(%r15)
	lg      %r14, -8(%r15)
    br      %r14


print_uint:
	stg     %r14, -4(%r15)
    lay     %r15, -8(%r15)
    lr      %r3,  %r2
    larl    %r2,  print_uint_format
    brasl   %r14, printf
	lay     %r15, 8(%r15)
	lg      %r14, -4(%r15)
    br      %r14


print_char:
	stg     %r14, -4(%r15)
    lay     %r15, -8(%r15)
    brasl   %r14, putchar
	lay     %r15, 8(%r15)
	lg      %r14, -4(%r15)
    br      %r14


print_nl:
	stg     %r14, -4(%r15)
    lay     %r15, -8(%r15)
	la      %r2,  10
    brasl   %r14, putchar
	lay     %r15, 8(%r15)
	lg      %r14, -4(%r15)
    br      %r14

	
print_string:
	stg     %r14, -4(%r15)
    lay     %r15, -8(%r15)
    brasl   %r14, puts
	lay     %r15, 8(%r15)
	lg      %r14, -4(%r15)
    br      %r14


read_int:
	stg     %r14, -4(%r15)
    lay     %r15, -8(%r15)
    lay     %r3,  0(%r15)
    larl    %r2,  read_int_format
    brasl   %r14, scanf
	l       %r2,  0(%r15)
	lay     %r15, 8(%r15)
	lg      %r14, -4(%r15)
    br      %r14
        

read_float:
	stg     %r14, -8(%r15)
    lay     %r15, -168(%r15)
    larl    %r2,  read_float_format
    brasl   %r14, scanf
	lay     %r15, 168(%r15)
	lg      %r14, -8(%r15)
    br      %r14


read_uint:
	stg     %r14, -4(%r15)
    lay     %r15, -8(%r15)
    lay     %r3,  0(%r15)
    larl    %r2,  read_uint_format
    brasl   %r14, scanf
	l       %r2,  0(%r15)
	lay     %r15, 8(%r15)
	lg      %r14, -4(%r15)


read_char:
	stg     %r14, -4(%r15)
    lay     %r15, -8(%r15)
    brasl   %r14, getchar
	lay     %r15, 8(%r15)
	lg      %r14, -4(%r15)
    br      %r14
 



asm_main:
	stg     %r14, -4(%r15)
	lay     %r15, -8(%r15)
	
	# ---------------------------	
	# Write Your Code here
    larl 6, N
	brasl %r14, read_int
    stg 2, 0(, 6)

    lg 8, 0(, 6) # n
    sllg 8, 8, 3 # 8 * n -> r8
    lghi 9, -8 # i
    lghi 10, -8 # j


# take input (
input_loop1:
    aghi 9, 8
    cr 9, 8
    jge fin
    lghi 10, -8
input_loop2:
    aghi 10, 8
    cr 10, 8
    jge do_sth
    larl 6, N
    lg 7, 0(, 6)
    mr 6, 9 # n * i -> r7
    ar 7, 10 # n * i + j -> r7
    brasl %r14, read_float
    larl 6, A
    std  %f0, 0(7, 6) # A[n * i + j]
    j input_loop2

do_sth:
    brasl %r14, read_float
    larl 6, B
    std  %f0, 0(9, 6) # B[i]
    j input_loop1    
       
fin:    
# take input )

# algorithm : making the matrix upper trangular (
# 1 : pushing max element of each coloumn to the top (

    larl 6, N
    lg 8, 0(, 6) # n
    sllg 8, 8, 3 # 8 * n -> r8
    lghi 9, -8 # i
    lghi 10, 0 # j
    lghi 13, 0 # k


loop1:
    aghi 9, 8
    cr 9, 8
    jge finn
    lr 10, 9
loop2:
    aghi 10, 8
    cr 10, 8
    jge loop1
    larl 6, N
    lg 7, 0(, 6)
    mr 6, 9 # n * i -> r7
    ar 7, 9 # n * i + i -> r7
    strl 7, tmp1 # save r7 to memory
    larl 6, N
    lg 7, 0(, 6)
    mr 6, 10 # n * j
    ar 7, 9 # n * j + i
    strl 7, tmp2 # save r7 to  memory

# if implementation (
    larl 6, A
    lrl 7, tmp1
    ld %f0, 0(7, 6)
    lrl 7, tmp2
    ld %f1, 0(7, 6)
    larl 6, zero
    kdb 0, 0(, 6)
    jnl ok   
    lcdbr 0, 0
ok:     
    larl 6, zero
    kdb 1, 0(, 6)
    jnl ok1
    lcdbr 1, 1
ok1:
    lrl 7, tmp1   
    larl 6, A
    kdb 1, 0(7, 6) 
    jh loop3
    j loop2   
   
# if implementation )

loop3:
    larl 6, B
    ld %f0, 0(9, 6) # B[i]
    ld %f1, 0(10, 6) # B[j]
    std %f0, 0(10, 6)
    std %f1, 0(9, 6)
    lghi 13, 0
loop4:    
    larl 6, N
    lg 7, 0(, 6)
    mr 6, 9 # n * i -> r7
    ar 7, 13 # n * i + k -> r7
    strl 7, tmp1 # save r7 to memory
    larl 6, N
    lg 7, 0(, 6)
    mr 6, 10 # n * j
    ar 7, 13 # n * j + k
    strl 7, tmp2 # save r7 to  memory

    larl 6, A
    lrl 7, tmp1
    ld %f0, 0(7, 6) # A[i][k]
    lrl 7, tmp2
    ld %f1, 0(7, 6) # A[j][k]
    std %f0, 0(7, 6)
    lrl 7, tmp1
    std %f1, 0(7, 6)

    aghi 13, 8
    cr 13, 8
    jge loop2
    j loop4

finn:
# 1 : pushing max element of each coloumn to the top )

    
# 2 : gaussian elimination (
    larl 6, N
    lg 8, 0(, 6) # n
    sllg 8, 8, 3 # 8 * n -> r8
    lghi 9, -8 # i
    lghi 10, 0 # j
    lghi 13, 0 # k


loopp1:
    aghi 9, 8
    aghi 8, -8
    cr 9, 8
    jge finnn
    aghi 8, 8
    lr 10, 9
loopp2:
    aghi 10, 8
    cr 10, 8
    jge loopp1
    larl 6, N
    lg 7, 0(, 6)
    mr 6, 9 # n * i -> r7
    ar 7, 9 # n * i + i -> r7
    strl 7, tmp1 # save r7 to memory
    larl 6, N
    lg 7, 0(, 6)
    mr 6, 10 # n * j
    ar 7, 9 # n * j + i
    strl 7, tmp2 # save r7 to  memory
# if no answer (
    lrl 7, tmp1
    larl 6, A
    ld %f0, 0(7, 6) # A[i][i]
    larl 6, zero
    kdb %f0, 0(, 6)
    je no_answer
    lrl 7, tmp2
    larl 6, A
    ld %f0, 0(7, 6) # A[j][i]
    lrl 7, tmp1
    ddb %f0, 0(7, 6) # A[j][i] / A[i][i] -> f0 (f0 = f)
   

# if no answer )    

loopp3:
    larl 6, B
    ldr 1, 0
    mdb 1, 0(9, 6) # B[i] * f -> f1
    sdb %f1, 0(10, 6) # B[j] - f1 -> f1
    lcdbr 1, 1
    std %f1, 0(10, 6)
    lghi 13, 0

loopp4:
    larl 6, N
    lg 7, 0(, 6)
    mr 6, 9 # n * i -> r7
    ar 7, 13 # n * i + k -> r7
    strl 7, tmp1 # save r7 to memory
    larl 6, N
    lg 7, 0(, 6)
    mr 6, 10 # n * j
    ar 7, 13 # n * j + k
    strl 7, tmp2 # save r7 to  memory


    larl 6, A
    ldr 1, 0
    lrl 7, tmp1
    mdb 1, 0(7, 6) # A[i][k] * f -> f1
    lrl 7, tmp2
    sdb 1, 0(7, 6) # A[j][k] - f1 -> f1
    lcdbr 1, 1 # negate f1
    std %f1, 0(7, 6)

    aghi 13, 8
    cr 13, 8
    jge loopp2
    j loopp4

no_answer:
    larl 6, impossible
    lr 2, 6
    brasl %r14, print_string
    j end_function

finnn:
# 2 : gaussian elimination )


# 3 : calculate answers (
    larl 6, N
    lg 8, 0(, 6) # n
    sllg 8, 8, 3 # 8 * n -> r8
    lr 9, 8 # i
    lghi 10, 0 # j

looppp1:
    aghi 9, -8
    cghi 9, 0
    jl finnnn
    larl 6, B
    ld %f0, 0(9, 6) # B[i]
    larl 6, result
    std %f0, 0(9, 6)
    lr 10, 9

looppp2:
    aghi 10, 8
    cr 10, 8
    jge do_sth1

    larl 6, N
    lg 7, 0(, 6)
    mr 6, 9 # n * i -> r7
    ar 7, 10 # n * i + j -> r7
    strl 7, tmp1
    larl 6, A
    ld %f0, 0(7, 6) # A[i][j]
    larl 6, result
    mdb 0, 0(10, 6)
    sdb 0, 0(9, 6)
    lcdbr 0, 0
    std %f0, 0(9, 6)

    j looppp2

do_sth1:
    larl 6, N
    lg 7, 0(, 6)
    mr 6, 9 # n * i -> r7
    ar 7, 9 # n * i + i -> r7
    strl 7, tmp1 # save r7 to memory
    larl 6, A
    ld %f0, 0(7, 6) # A[i][i]
    larl 6, result
    ld %f1, 0(9, 6)
    larl 6, zero
    kdb 0, 0(6)
    je no_answer
    larl 6, A
    ddb 1, 0(7, 6) # res[i] / A[i][i]
    larl 6, result
    std %f1, 0(9, 6)

    j looppp1
finnnn:

# 3 : calculate answers )

 
# 4 : printing answers (
    larl 6, N
    lg 8, 0(, 6) # n
    sllg 8, 8, 3 # 8 * n -> r8
    lghi 9, -8 # i

print_loop:
    aghi 9, 8
    cr 9, 8
    jge end_function

    larl 6, result
    ld %f0, 0(9, 6)

    larl 6, zero
    kdb 0, 0(6)
    jne edame
    ld %f0, 0(6)
edame:
    brasl %r14, print_float
    lghi 2, ' '
    brasl %r14, print_char
    j print_loop

# 4 : printing answers )    

end_function:	
    brasl %r14, print_nl
# algorithm )
	# ---------------------------	

	lay     %r15, 8(%r15)
	lg      %r14, -4(%r15)
    br      %r14


