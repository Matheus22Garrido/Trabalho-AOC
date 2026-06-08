.data
    msg1: .asciiz "\nDigite o valor em binario digito por digito (unidade p/ frente) (deve estar entre 1 e 1000000000): "
    msg2: .asciiz "\nEsse valor nao e binario "
    msg3: .asciiz "\nO valor digitado em binario transformado em decimal é: "
    msgzero: .asciiz "\nO valor nao pode ser zero  "
    msgdeum: .asciiz "\nO valor nao pode ser um  "
.text
main:
    add $s1, $s1, 1   # declara que o registrador que guarda o valor exponenciado é 1 ( porque se for 0 o valor nunca vai sair de 0 e da errado)

#               *ANOTAÇÕES* 
#               $t0 = espaço temporario para armazenamento do valor digitado para verificaçao
#               $t4 = contador1
#               $t5 = contador usado para exponenciação 
#               $s0 = espaço para a soma dos valores
#               $s1 = espaço para as exponenciações
#               $s2 = espaço para a potencia

recebeValor:   # Recebe o valor digito por digito
    li $v0, 4
    la $a0, msg1
    syscall
    li $v0, 5
    syscall
    add $t0, $v0, 0

    j verificaDigito

verificaDigito:   # Verifica se digito é valido, se nao, pula pra parte que mostra mensagem de que não é binario
    beq $t0, 0, valorValido
    beq $t0, 1, valorValido
    j msgNaoBinario

#               $s0 = espaço para a soma dos valores
#               $s1 = registrador que guarda o valor ja potenciado (Ex: 2³)
#               $s2 = espaço para a potencia

    # o valor digitado, que já foi verificado, é 0 ou 1
    # converte o digito 0 ou 1 para decimal e armazena para fazer as somas no $s0
valorValido:
    j enquantoCont2

valorValidoePronto:
    mul $s1, $t0, $s1   # multiplica o digito binario (0 ou 1) pela potencia e joga pro registrador que guarda o valor da potencia
    add $s0, $s0, $s1   # adiciona o resultado da operação anterior no registrador que guarda a soma dos valores até o momento 
    j enquantoCont2p2

enquantoCont2:    # while (cont2<=cont1): pula pra potencia
    blt $t5, $t4, potencia
    j valorValidoePronto

potencia:    
    # fica multiplicando por 2 o valor até chegar no valor da potencia
    # multiplica o valor (0 ou 1) por 2 e soma 1 no contador
    mul $s1, $s1, 2
    add $t5, $t5, 1
    j enquantoCont2

enquantoCont2p2:
    add $t4, $t4, 1    # cont1 += 1
    mul $s1, $s1, 0    # zera o valor da potencia
    add $s1, $s1, 1    # aqui ele adiciona 1 pra conseguir acertar as proximas potencias
    mul $t5, $t5, 0    # aqui ele zera o contador2 (parcial)
    ble $t4, 9, recebeValor    # while (cont1<=10): recebe valor novo // else: pula pra parte que mostra a soma
    j Soma

Soma:
    # aqui o algoritmo verifica se a soma dos números digitados é 0 ou 1 (pq o enunciado fala q tem q ser <1)
    beq $s0, 0, mostramsgzero
    beq $s0, 1, mostramsgdeum
    j mostraResultado

mostramsgzero:    # aqui ele mostra a mensagem dizendo que o valor digitado é zero e volta todo o algoritmo do zero
    li $v0, 4
    la $a0, msgzero
    syscall
    j fim    # acaba o algoritmo se for zero falando que é zero

mostramsgdeum:    # aqui ele mostra a mensagem dizendo que o valor digitado é um e volta todo o algoritmo do zero
    li $v0, 4
    la $a0, msgdeum
    syscall
    j fim    # acaba o algoritmo se for um falando que é um

msgNaoBinario:
    li $v0, 4
    la $a0, msg2
    syscall
    j recebeValor

mostraResultado:    # aqui o resultado é valido (1<N<1024) e mostra o resultado
    li $v0, 4
    la $a0, msg3
    syscall
    li $v0, 1
    add $a0, $s0, 0
    syscall

fim: