.data
msg_boas_vindas: .string "BEM-VINDO AO BLACKJACK!\n"
msg_mao_jogador: .string "Sua mão inicial: "
msg_mao_atual: .string "Mão atual: "
msg_total_cartas: .string "(TOTAL):"
msg_cartas: .string "Cartas: "
msg_continuar: .string "O que você deseja fazer? (1 - Hit, 2 - Stand): "
msg_encerramento: .string "Obrigado por jogar!\n"
msg_voce_venceu: .string "Você venceu! Parabéns!\n"
msg_dealer_iniciado: .string "Turno Dealer!\n"
msg_mao_dealer: .string "Mão dealer: "
msg_dealer_vence: .string "O dealer venceu!\n"
msg_estouro_jogador: .string "Você estourou! O dealer venceu.\n"
msg_estouro_dealer: .string "O dealer estourou! Você venceu!\n"
msg_empate: .string "Empate\n"
msg_perguntar_continuar: .string "Deseja continuar jogando? (1 - Sim, 2 - Não): "
virgula: .string ", "
newline: .string "\n"

.text 
.globl main

main:
    li a7, 4                       # a7 <= 4 (print string)
    la a0, msg_boas_vindas         # Imprime a string apontada por a0
    ecall

    j jogo                            # Inicia o loop do jogo

jogo:
    jal distribui_mao_inicial        # Distribui a mão inicial do jogador
    jal mostra_mao_inicial           # Exibe a mão inicial do jogador
    jal decisao_jogador

decisao_jogador:
    li a7, 4                  # Pergunta se o jogador quer "Hit" ou "Stand"
    la a0, msg_continuar
    ecall

    li a7, 5                  # Solicita entrada do jogador
    ecall

    mv s1, a0                 # Armazena a entrada do jogador em s1

    li t1, 1                  # Se escolha for "Hit"
    beq s1, t1, hit_jogador   # Vai para hit

    li t1, 2                  # Se escolha for "Stand"
    beq s1, t1, turno_dealer  # Entra no turno do dealer

hit_jogador:
    jal distribui_carta_jogador    # Dá outra carta ao jogador
    jal mostra_mao_atual           # Exibe a mão do jogador atualizada
    jal verifica_estouro_jogador   # Verifica se o jogador estourou
    j decisao_jogador              # Pergunta novamente

turno_dealer:
    # Exibe a mensagem de início do turno do dealer
    li a7, 4
    la a0, msg_dealer_iniciado
    ecall

    jal mao_inicial_dealer         # Distribui as cartas iniciais para o dealer
    jal mostra_mao_dealer          # Exibe as cartas do dealer
    jal verifica_estouro_dealer    # Verifica se o dealer estourou
    jal verifica_vencedor          # Verifica o vencedor

fim_jogo:
    li a7, 4
    la a0, msg_encerramento        # Mensagem de encerramento
    ecall

    jal perguntar_continuar        # Pergunta se o jogador quer jogar novamente
    ret

perguntar_continuar:
    li a7, 4
    la a0, msg_perguntar_continuar # Pergunta se quer continuar
    ecall

    li a7, 5
    ecall                           # Solicita entrada (1 - Sim, 2 - Não)
    mv s1, a0                       # Armazena a resposta em s1

    li t1, 1                        # Se escolha for "Sim"
    beq s1, t1, jogo                # Inicia uma nova rodada

    li t1, 2                        # Se escolha for "Não"
    beq s1, t1, fim_programa        # Encerra o programa

fim_programa:
    li a7, 10                      # Finaliza o programa
    ecall

vencedor:
    li a7, 4
    la a0, msg_voce_venceu         # Mensagem de vitória
    ecall
    j fim_jogo

dealer_vencedor:
    li a7, 4
    la a0, msg_dealer_vence        # Mensagem do dealer vencendo
    ecall
    j fim_jogo

distribui_mao_inicial:
    li a0, 0
    li t0, 5                       # Carta fixa 1
    add a0, a0, t0                 # Soma ao total da mão
    li t1, 7                       # Carta fixa 2
    add a0, a0, t1                 # Soma ao total da mão
    mv t2, a0                      # Total
    mv t3, t0                      # Carta 1
    mv t4, t1                      # Carta 2
    ret

distribui_carta_jogador:
    li t0, 3                       # Nova carta
    add t2, t2, t0                 # Atualiza o total
    mv t5, t0                      # Armazena a nova carta
    ret

mostra_mao_inicial:
    li a7, 4
    la a0, msg_mao_jogador
    ecall

    li a7, 4
    la a0, msg_cartas
    ecall

    li a7, 1
    mv a0, t3                      # Carta 1
    ecall

    li a7, 4
    la a0, virgula
    ecall

    li a7, 1
    mv a0, t4                      # Carta 2
    ecall

    li a7, 4
    la a0, msg_total_cartas
    ecall

    li a7, 1
    mv a0, t2
    ecall

    li a7, 4
    la a0, newline
    ecall

    ret

mostra_mao_atual:
    li a7, 4
    la a0, msg_mao_atual
    ecall

    li a7, 4
    la a0, msg_cartas
    ecall

    li a7, 1
    mv a0, t3
    ecall

    li a7, 4
    la a0, virgula
    ecall

    li a7, 1
    mv a0, t4
    ecall

    li a7, 4
    la a0, virgula
    ecall

    li a7, 1
    mv a0, t5
    ecall

    li a7, 4
    la a0, msg_total_cartas
    ecall

    li a7, 1
    mv a0, t2
    ecall

    li a7, 4
    la a0, newline
    ecall

    ret

mao_inicial_dealer:
    li a0, 0
    li t0, 9
    add a0, a0, t0
    li t1, 8
    add a0, a0, t1
    li t2, 1
    add a0, a0, t2
    mv t6, a0
    mv t3, t0
    mv t4, t1
    mv t5, t2
    ret

mostra_mao_dealer:
    li a7, 4
    la a0, msg_mao_dealer
    ecall

    li a7, 4
    la a0, msg_cartas
    ecall

    li a7, 1
    mv a0, t3
    ecall

    li a7, 4
    la a0, virgula
    ecall

    li a7, 1
    mv a0, t4
    ecall

    li a7, 4
    la a0, virgula
    ecall

    li a7, 1
    mv a0, t5
    ecall

    li a7, 4
    la a0, msg_total_cartas
    ecall

    li a7, 1
    mv a0, t6
    ecall

    li a7, 4
    la a0, newline
    ecall

    ret

verifica_estouro_jogador:
    li t0, 21                      # Pontuação máxima (21)
    bgt t2, t0, jogador_estourou   # Se o jogador estourar (pontuação > 21)
    ret

jogador_estourou:
    li a7, 4
    la a0, msg_estouro_jogador
    ecall
    j fim_jogo

verifica_estouro_dealer:
    li t0, 21
    bgt t6, t0, dealer_estourou    # Se o dealer estourar (pontuação > 21)
    ret

dealer_estourou:
    li a7, 4
    la a0, msg_estouro_dealer
    ecall
    j vencedor

verifica_vencedor:
    li t0, 21
    blt t2, t6, dealer_vencedor    # Se a pontuação do jogador for menor que a do dealer
    bgt t2, t6, vencedor           # Se a pontuação do jogador for maior
    li a7, 4
    la a0, msg_empate
    ecall
    j fim_jogo
