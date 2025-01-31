
segment .data
print_int_format: db        "%ld", 0

read_int_format: db         "%ld", 0

read_float_format db         "%lf", 0

print_float_format: db        "%.3lf", 0

impossible: db 'Impossible', 0

A: dq 1000000 dup(0)
B: dq 1000 dup(0)
N: dq 1 dup(0)

zero: dq 1 dup(0.0)

res: dq 1000 dup(0)
remainder: dq 1 dup(0.0)

segment .text
    global print_int
    global print_float
    global print_char
    global print_string
    global print_nl
    global read_int
    global read_float
    global read_char
    global asm_main
    extern printf
    extern putchar
    extern puts
    extern scanf
    extern getchar
    extern  read_int, print_int, print_string
	extern	read_char, print_char, print_nl

print_int:
    sub rsp, 8

    mov rsi, rdi

    mov rdi, print_int_format
    mov rax, 1 ; setting rax (al) to number of vector inputs
    call printf
    
    add rsp, 8 ; clearing local variables from stack

    ret

print_float:
    sub rsp, 8

    mov rsi, rdi

    mov rdi, print_float_format
    mov rax, 1 ; setting rax (al) to number of vector inputs
    call printf
    
    add rsp, 8 ; clearing local variables from stack

    ret


print_char:
    sub rsp, 8

    call putchar
    
    add rsp, 8 ; clearing local variables from stack

    ret


print_string:
    sub rsp, 8

    call puts
    
    add rsp, 8 ; clearing local variables from stack

    ret


print_nl:
    sub rsp, 8

    mov rdi, 10
    call putchar
    
    add rsp, 8 ; clearing local variables from stack

    ret


read_int:
    sub rsp, 8

    mov rsi, rsp
    mov rdi, read_int_format
    mov rax, 1 ; setting rax (al) to number of vector inputs
    call scanf

    mov rax, [rsp]

    add rsp, 8 ; clearing local variables from stack

    ret

read_float:
    sub rsp, 8

    mov rsi, rsp
    mov rdi, read_float_format
    mov rax, 1 ; setting rax (al) to number of vector inputs
    call scanf

    mov rax, [rsp]

    add rsp, 8 ; clearing local variables from stack

    ret


read_char:
    sub rsp, 8

    call getchar

    add rsp, 8 ; clearing local variables from stack

    ret


 

asm_main:
	push rbp
    push rbx
    push r12
    push r13
    push r14
    push r15

    sub rsp, 8

    ; -------------------------
    ; write your code here
    

    call read_int
    mov qword N[0], rax ; store in memory
    mov r12, rax ; n
    mov r13, rax ; n
    mov rbp, 0 ; i
    mov rbx, 0 ; j


; take input (
input_loop1:
    mov rax, qword N[0]
    imul rbp ; n * i -> rax
    mov r14, rax
input_loop2:
    mov r15, r14
    add r15, rbx
    call read_float
    movsd qword A[r15], xmm0 ; A[n * i + j]
    add rbx, 8
    dec r13 ; inner loop counter
    jnz input_loop2
    call read_float
    movsd qword B[rbp], xmm0
    mov r13, qword N[0]
    mov rbx, 0
    add rbp, 8
    dec r12 ; outer loop counter
    jnz input_loop1
; take input )


; algorithm : making the matrix upper trangular (
; 1 : pushing max element of each coloumn to the top (

    mov rbp, -8 ; i loop1 counter
    mov rbx, 0 ; j loop2 counter
    mov r12, 0 ; k loop3 counter
    mov r13, qword N[0] ; n
    shl r13, 3 ; 8 * n -> r13
    


loop1:
    add rbp, 8 ; i++
    cmp rbp, r13
    jge fin
    mov rbx, rbp ; j = i
loop2:
    add rbx, 8 ; j++
    cmp rbx, r13
    jge loop1
    mov rax, qword N[0]
    imul rbp ; n * i -> rax
    add rax, rbp ; n * i + i
    mov r14, rax 
    mov rax, qword N[0]
    imul rbx ; n * j -> rax
    add rax, rbp ; n * j + i

; if implementation (
    movsd xmm0, qword A[r14]
    fabs
    movsd xmm1, xmm0
    movsd xmm0, qword A[rax]
    fabs 
    comisd xmm0, xmm1  
    ja loop3
    jmp loop2   

; if implementation )



loop3: ; swap
    movsd xmm0, qword B[rbp]
    movsd xmm1, qword B[rbx]
    movsd qword B[rbx], xmm0
    movsd qword B[rbp], xmm1
    ; get ready for simd
    mov r12, 0
    mov rax, r13
    xor rdx, rdx
    mov rsi, 32
    idiv rsi
    mov rax, r13
    sub rax, rdx
    mov r15, rax
    mov qword remainder[0], rdx ; save remainder to memeory

loop4:
    mov rax, qword N[0]
    imul rbp ; n * i -> rax
    mov rcx, rax
    add rcx, r12 ; n * i + k
    mov rax, qword N[0]
    imul rbx ; n * j -> rax
    add rax, r12 ; n * j + k

    vmovupd ymm0, A[rcx]
    vmovupd ymm1, A[rax] 
    vmovupd A[rax], ymm0
    vmovupd A[rcx], ymm1

    add r12, 32
    cmp r12, r15
    jge rest
    jmp loop4
     
rest:  
    mov r12, -8
    add rax, 32
    add rcx, 32
remainder_loop:
    add r12, 8
    mov rdx, qword remainder[0]
    cmp r12, rdx
    jge loop2
    add rax, r12
    add rcx, r12

    movsd xmm0, qword A[rcx]
    movsd xmm1, qword A[rax] 
    movsd qword A[rax], xmm0
    movsd qword A[rcx], xmm1

    jmp remainder_loop
fin:
; 1 : pushing max element of each coloumn to the top )


; 2 : gaussian elimination (
    mov rbp, -8 ; i loopp1 counter
    mov rbx, 0 ; j loopp2 counter
    mov r12, 0 ; k loopp3 counter
    mov r13, qword N[0] ; n
    shl r13, 3 ; 8 * n -> r13
    mov r14, r13
    sub r14, 8 ; 8 * (n-1)


loopp1:
    add rbp, 8 ; i++
    cmp rbp, r14
    jge finn
    mov rbx, rbp ; j = i
loopp2:
    add rbx, 8 ; j++
    cmp rbx, r13
    jge loopp1
    mov rax, qword N[0]
    imul rbp ; n * i -> rax
    add rax, rbp ; n * i + i
    mov r15, rax 
    mov rax, qword N[0]
    imul rbx ; n * j -> rax
    add rax, rbp ; n * j + i

; if implementation for no possible answer (
    movsd xmm0, qword A[r15]
    ;call print_float
    comisd xmm0, qword zero[0]
    je no_answer
    movsd xmm1, qword A[rax]
    divsd xmm1, xmm0 ; xmm1 = f = A[j][i] / A[i][i]
; if implementation )

loopp3:
    movsd xmm2, qword B[rbx]
    movsd xmm3, qword B[rbp]
    mulsd xmm3, xmm1 ; f * B[i] -> xmm3
    subsd xmm2, xmm3
    movsd qword B[rbx], xmm2
    ; get ready for simd
    mov r12, 0
    mov rax, r13
    xor rdx, rdx
    mov rsi, 32
    idiv rsi
    mov rax, r13
    sub rax, rdx
    mov r15, rax
    mov qword remainder[0], rdx ; save remainder to memeory
loopp4:
    mov rax, qword N[0]
    imul rbp ; n * i -> rax
    mov rcx, rax
    add rcx, r12 ; n * i + k
    mov rax, qword N[0]
    imul rbx ; n * j -> rax
    add rax, r12 ; n * j + k

    vmovupd ymm2,  A[rax]
    vmovupd ymm3,  A[rcx]
    vbroadcastsd ymm1, xmm1
    vmulpd ymm3, ymm1
    vsubpd ymm2, ymm3
    vmovupd  A[rax], ymm2

    add r12, 32
    cmp r12, r15
    jge rest1
    jmp loopp4
rest1:
    mov r12, -8
    add rax, 32
    add rcx, 32
remainder_loop1:
    add r12, 8
    mov rdx, qword remainder[0]
    cmp r12, rdx
    jge loopp2

    add rax, r12
    add rcx, r12

    movsd xmm2, qword A[rax]
    movsd xmm3, qword A[rcx]
    mulsd xmm3, xmm1
    subsd xmm2, xmm3
    movsd qword A[rax], xmm2

    jmp remainder_loop1
no_answer:
    mov rdi, impossible
    call print_string
    jmp end_function

finn:    

; 2 : gaussian elimination )
    


; 3 : calculate answers (
    mov r13, qword N[0] ; n
    shl r13, 3 ; 8 * n -> r13
    mov rbp, r13 ; i looppp1 counter
    mov rbx, 0 ; j looppp2 counter
    

looppp1:
    sub rbp, 8
    cmp rbp, 0
    jl finnn
    movsd xmm0, qword B[rbp]
    movsd qword res[rbp], xmm0
    mov rbx, rbp
looppp2:   
    add rbx, 8
    cmp rbx, r13
    jge do_sth


; if implementation for i != j (
    cmp rbp, rbx
    je looppp2
    mov rax, qword N[0]
    imul rbp ; n * i -> rax
    add rax, rbx ; n * i + j -> rax
    movsd xmm0, qword A[rax]
    movsd xmm1, qword res[rbx]
    mulsd xmm0, xmm1 ; A[i][j] * res[j] -> xmm0
    comisd xmm0, qword zero[0]
    movsd xmm2, qword res[rbp]
    subsd xmm2, xmm0 ; res[i] - (A[i][j] * res[j]) -> xmm2
    movsd qword res[rbp], xmm2
    
    jmp looppp2
; if implementation )

do_sth: ; res[i] / A[i][i]
    movsd xmm0, qword res[rbp] ; res[i]
    mov rax, qword N[0]
    imul rbp ; n * i -> rax
    add rax, rbp ; n * i + i -> rax
    movsd xmm2, qword A[rax]
    comisd xmm2, qword zero[0]
    je no_answer
    divsd xmm0, xmm2
    movsd qword res[rbp], xmm0

    jmp looppp1

finnn:

; 3 : calculate answers )

; 4 : printing answers (
    mov rbp, -8 ; i loopp1 counter
    mov r13, qword N[0] ; n
    shl r13, 3 ; 8 * n -> r13

print_loop:
    add rbp, 8
    cmp rbp, r13
    jge end_function
    movsd xmm0, qword res[rbp]
    comisd xmm0, qword zero[0]
    jne edame
    movsd xmm0, qword zero[0]
edame:
    call print_float
    mov rdi, ' '
    call print_char
    jmp print_loop    
; 4 : printing answers )

; algorithm )    





end_function:
    call print_nl
    ;--------------------------

    add rsp, 8

	pop r15
	pop r14
	pop r13
	pop r12
    pop rbx
    pop rbp

	ret


