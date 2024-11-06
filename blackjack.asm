    .data
welcome_msg:    .asciiz "Bem-vindo ao Blackjack!\n"
player_hand_msg: .asciiz "O jogador recebe: "
dealer_hand_msg: .asciiz "O dealer revela: "
total_hand_msg: .asciiz "Sua mão: "
ask_action_msg: .asciiz "O que você deseja fazer? (1 - Hit, 2 - Stand): "
game_over_msg:  .asciiz "O jogo acabou! "
play_again_msg: .asciiz "Deseja jogar novamente? (1 - Sim, 2 - Não): "
player_wins_msg:.asciiz "Você venceu!\n"
dealer_wins_msg:.asciiz "O dealer venceu!\n"
draw_msg:       .asciiz "Empate!\n"

player_hand:    .word 0, 0, 0      # Mão do jogador
dealer_hand:    .word 0, 0, 0      # Mão do dealer
player_total:   .word 0
dealer_total:   .word 0
deck:          .space 52            # Espaço para as cartas
new_card:      .word 0

    .text
    .globl main
main:
    # Mensagem de boas-vindas
    li a7, 4
    la a0, welcome_msg
    ecall

    # Iniciar o jogo
    jal start_game

exit:
    li a7, 10
    ecall

start_game:
    # Distribuir cartas
    jal deal_cards
    jal player_turn
    jal dealer_turn
    jal determine_winner
    jal ask_play_again
    ret

deal_cards:
    # O jogador e o dealer recebem 2 cartas
    li t0, 0          # Contador de cartas
    li t1, 0          # Total do jogador
    li t2, 0          # Total do dealer

deal_player:
    jal get_random_card
    sw a0, player_hand(t0)
    add t1, t1, a0
    addi t0, t0, 1
    bne t0, 2, deal_player

    # Atualizar total do jogador
    sw t1, player_total

deal_dealer:
    li t0, 0          # Reset contador de cartas do dealer
    jal get_random_card
    sw a0, dealer_hand(t0)
    add t2, t2, a0
    addi t0, t0, 1
    bne t0, 1, deal_dealer  # O dealer recebe apenas uma carta visível

    # Atualizar total do dealer
    sw t2, dealer_total

    # Mostrar mãos
    jal show_hands
    ret

get_random_card:
    li a7, 0          # Chamada para gerar número aleatório
    ecall
    andi a0, a0, 0x0F # Limitar a carta entre 1 e 13
    addi a0, a0, 1   # Ajustar para 1 a 13
    ret

show_hands:
    # Mostrar a mão do jogador
    li a7, 4
    la a0, player_hand_msg
    ecall

    lw t0, player_hand(0)
    lw t1, player_hand(1)
    mv a0, t0
    mv a1, t1
    jal print_card

    # Mostrar mão do dealer
    li a7, 4
    la a0, dealer_hand_msg
    ecall

    lw t0, dealer_hand(0)
    mv a0, t0
    jal print_card

    # Mostrar total do jogador
    li a7, 4
    la a0, total_hand_msg
    ecall
    lw t0, player_total
    mv a0, t0
    jal print_total
    ret

print_card:
    # Função para imprimir uma carta
    li a7, 1
    ecall
    ret

print_total:
    # Função para imprimir o total
    li a7, 1
    ecall
    ret

player_turn:
    # Lógica da vez do jogador
    li t3, 0          # Jogador ainda não estourou
prompt_player_action:
    li a7, 4
    la a0, ask_action_msg
    ecall
    li a7, 5          # Ler entrada do jogador
    ecall
    beq a0, 1, hit
    beq a0, 2, stand
    j prompt_player_action

hit:
    jal get_random_card
    lw t1, player_total
    add t1, t1, a0
    sw t1, player_total

    # Verifica se estourou
    bgt t1, 21, player_bust

    # Mostrar mãos após Hit
    jal show_hands
    j prompt_player_action

stand:
    ret

player_bust:
    # Jogador estourou
    li a7, 4
    la a0, dealer_wins_msg
    ecall
    j end_game

dealer_turn:
    # Lógica da vez do dealer
    li t4, 0
dealer_play:
    lw t1, dealer_total
    bge t1, 17, dealer_stand

    jal get_random_card
    lw t1, dealer_total
    add t1, t1, a0
    sw t1, dealer_total

    # Verifica se dealer estourou
    bgt t1, 21, dealer_bust
    j dealer_play

dealer_stand:
    ret

dealer_bust:
    # Dealer estourou
    li a7, 4
    la a0, player_wins_msg
    ecall
    j end_game

determine_winner:
    # Lógica para determinar o vencedor
    lw t1, player_total
    lw t2, dealer_total
    bgt t1, t2, player_wins
    bgt t2, t1, dealer_wins
    j draw

player_wins:
    li a7, 4
    la a0, player_wins_msg
    ecall
    j end_game

dealer_wins:
    li a7, 4
    la a0, dealer_wins_msg
    ecall
    j end_game

draw:
    li a7, 4
    la a0, draw_msg
    ecall

end_game:
    # Finaliza o jogo
    ret

ask_play_again:
    # Pergunta se deseja jogar novamente
    li a7, 4
    la a0, play_again_msg
    ecall
    li a7, 5          # Ler entrada do jogador
    ecall
    beq a0, 1, start_game
    j exit
