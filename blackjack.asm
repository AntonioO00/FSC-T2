.data
msg_boas_vindas: .string "Bem-vindo ao Blackjack!\n"
msg_jogador_recebe: .string "O jogador recebe: "
msg_dealer_revela: .string "O dealer revela: "
msg_mao_jogador: .string "Sua mão: "
msg_continuar: .string "O que você deseja fazer? (1 - Hit, 2 - Stand): "
msg_mao_dealer: .string "O dealer tem: "
msg_dealer_estourou: .string "O dealer estourou! Você venceu!"
msg_vitoria: .string "Você venceu!\n"
msg_derrota: .string "O dealer venceu!\n"
msg_empate: .string "Empate!\n"
msg_jogar_novamente: .string "Deseja jogar novamente? (1 - Sim, 2 - Não): "

.text
.globl main

# Função principal
main:
    la a0, msg_boas_vindas          # Carrega e imprime a mensagem de boas-vindas
    jal imprime_texto

jogar_novamente:
    jal distribui_mao_inicial       # Distribui cartas iniciais para o jogador e dealer

turno_jogador:
    jal calcula_soma_jogador        # Calcula e imprime a soma das cartas do jogador

decisao_jogador:
    la a0, msg_continuar            # Pergunta se o jogador quer "Hit" ou "Stand"
    jal imprime_texto

    li a7, 5                        # Leitura da decisão do jogador
    ecall
    addi t0, a0, 0                  # Salva a escolha do jogador em t0

    li t1, 1                        # Compara para "Hit"
    beq t0, t1, hit_jogador

    li t1, 2                        # Compara para "Stand"
    beq t0, t1, turno_dealer

hit_jogador:
    jal distribui_carta_jogador     # Jogador pede carta
    jal calcula_soma_jogador        # Atualiza a soma do jogador

    li t2, 21
    bgt a0, t2, dealer_vence        # Verifica se estourou (soma > 21)
    j decisao_jogador               # Volta para a decisão do jogador

turno_dealer:
    jal calcula_soma_dealer         # Calcula e imprime a soma das cartas do dealer

hit_dealer:
    li t2, 17
    blt a0, t2, continua_dealer     # Dealer continua se soma < 17

dealer_fim:
    jal determina_vencedor          # Determina o vencedor do jogo

jogar_ou_sair:
    la a0, msg_jogar_novamente      # Pergunta se o jogador quer jogar de novo
    jal imprime_texto

    li a7, 5                        # Lê a entrada do jogador
    ecall
    li t1, 1
    beq a0, t1, jogar_novamente     # Se 1, joga novamente

    li a7, 10                       # Se 2, sai do programa
    ecall

continua_dealer:
    jal distribui_carta_dealer      # Dealer recebe carta
    jal calcula_soma_dealer         # Calcula nova soma

    li t2, 21
    bgt a0, t2, jogador_vence       # Verifica se o dealer estourou
    j hit_dealer                    # Volta para pedir outra carta, se necessário

# Determina o vencedor
determina_vencedor:
    li t0, 21

    blt a1, a2, dealer_vence        # Dealer vence se tiver mão maior
    blt a2, a1, jogador_vence       # Jogador vence se tiver mão maior
    j empate                        # Caso contrário, é empate

dealer_vence:
    la a0, msg_derrota
    jal imprime_texto
    j jogar_ou_sair

jogador_vence:
    la a0, msg_vitoria
    jal imprime_texto
    j jogar_ou_sair

empate:
    la a0, msg_empate
    jal imprime_texto
    j jogar_ou_sair

# Funções auxiliares

imprime_texto:                      # Imprime texto armazenado em a0
    li a7, 4
    ecall
    ret

distribui_mao_inicial:              # Dá duas cartas iniciais para jogador e dealer
    jal distribui_carta_jogador
    jal distribui_carta_jogador
    jal distribui_carta_dealer
    jal distribui_carta_dealer
    ret

distribui_carta_jogador:            # Função exemplo para distribuir carta para jogador
    li t0, 1                        # Randomização (exemplo simplificado)
    add a0, a0, t0
    ret

distribui_carta_dealer:             # Função exemplo para distribuir carta para dealer
    li t0, 1                        # Randomização (exemplo simplificado)
    add a1, a1, t0
    ret

calcula_soma_jogador:               # Calcula a soma da mão do jogador
    # Soma as cartas do jogador (exemplo simplificado)
    ret

calcula_soma_dealer:                # Calcula a soma da mão do dealer
    # Soma as cartas do dealer (exemplo simplificado)
    ret
