# Blackjack em Assembly RISC-V
# Este código implementa uma versão simplificada do jogo de Blackjack (21)
# Jogado contra o "dealer" (computador)
# Autor: [Seu Nome]

.data
msg_boas_vindas: .asciiz "Bem-vindo ao Blackjack!\n"
msg_opcoes: .asciiz "O que deseja fazer? (1 - Hit, 2 - Stand): "
msg_mao_jogador: .asciiz "Sua mão: "
msg_dealer_oculto: .asciiz "O dealer revela: uma carta oculta\n"
msg_jogador_venceu: .asciiz "O dealer estourou! Você venceu!\n"
msg_jogador_perdeu: .asciiz "Você estourou! O dealer venceu.\n"
msg_deseja_jogar: .asciiz "Deseja jogar novamente? (1 - Sim, 2 - Não): "

# Variáveis para o jogo
# 1 representa Ás, 11 = Valete, 12 = Dama, 13 = Rei
baralho: .word 1,2,3,4,5,6,7,8,9,10,11,12,13
# Armazena a pontuação atual
pontuacao_jogador: .word 0
pontuacao_dealer: .word 0

.text
.globl _start

_start:
    # Exibe mensagem de boas-vindas
    la a0, msg_boas_vindas
    jal ra, print_string

    # Distribui duas cartas iniciais para jogador e dealer
    jal ra, distribui_cartas_iniciais

    # Laço principal do jogo
jogar:
    # Mostra pontuação do jogador
    la a0, msg_mao_jogador
    jal ra, print_string
    lw a0, pontuacao_jogador
    jal ra, print_int
    jal ra, nova_linha

    # Pergunta ao jogador o que deseja fazer
    la a0, msg_opcoes
    jal ra, print_string
    jal ra, ler_opcao
    
    # Verifica decisão do jogador
    li t0, 1          # 1 para Hit
    beq a0, t0, hit
    j dealer_turno    # Caso contrário, Stand, vai para o turno do dealer

# Hit: Jogador pede uma nova carta
hit:
    jal ra, distribuir_carta_jogador
    lw t0, pontuacao_jogador
    li t1, 21
    bgt t0, t1, jogador_perdeu
    j jogar           # Continua o jogo se pontuação <= 21

# Turno do Dealer
dealer_turno:
    jal ra, turno_dealer
    # Verifica se o dealer ultrapassou 21
    lw t0, pontuacao_dealer
    li t1, 21
    bgt t0, t1, dealer_estourou
    j verifica_vencedor

# Dealer estourou: Jogador vence
dealer_estourou:
    la a0, msg_jogador_venceu
    jal ra, print_string
    j finalizar

# Jogador estourou: Dealer vence
jogador_perdeu:
    la a0, msg_jogador_perdeu
    jal ra, print_string
    j finalizar

# Verificação de quem venceu
verifica_vencedor:
    lw t0, pontuacao_jogador
    lw t1, pontuacao_dealer
    bgt t0, t1, jogador_vence   # Jogador ganha se tiver maior pontuação
    blt t0, t1, dealer_vence    # Dealer ganha se tiver maior pontuação

# Empate
empate:
    # Exibe mensagem de empate
    la a0, msg_empate
    jal ra, print_string
    j finalizar

# Jogador vence
jogador_vence:
    la a0, msg_jogador_vence
    jal ra, print_string
    j finalizar

# Dealer vence
dealer_vence:
    la a0, msg_dealer_vence
    jal ra, print_string
    j finalizar

# Funções auxiliares

# Função: print_string
# Imprime uma string
print_string:
    li a7, 4         # syscall para print_string
    ecall
    ret

# Função: print_int
# Imprime um número inteiro
print_int:
    li a7, 1         # syscall para print_int
    ecall
    ret

# Função: nova_linha
# Imprime uma nova linha
nova_linha:
    li a0, '\n'
    jal ra, print_char
    ret

# Função: print_char
# Imprime um caractere
print_char:
    li a7, 11
    ecall
    ret

# Função: distribui_cartas_iniciais
# Distribui duas cartas para o jogador e duas para o dealer
distribui_cartas_iniciais:
    # Distribui primeira carta para o jogador
    jal ra, distribuir_carta_jogador
    # Distribui segunda carta para o jogador
    jal ra, distribuir_carta_jogador
    # Distribui primeira carta para o dealer
    jal ra, distribuir_carta_dealer
    # Distribui segunda carta para o dealer (oculta)
    ret

# Função: distribuir_carta_jogador
# Adiciona carta à pontuação do jogador
distribuir_carta_jogador:
    jal ra, gerar_carta
    lw t0, pontuacao_jogador
    add t0, t0, a0      # Atualiza pontuação do jogador
    sw t0, pontuacao_jogador
    ret

# Função: distribuir_carta_dealer
# Adiciona carta à pontuação do dealer
distribuir_carta_dealer:
    jal ra, gerar_carta
    lw t0, pontuacao_dealer
    add t0, t0, a0      # Atualiza pontuação do dealer
    sw t0, pontuacao_dealer
    ret

# Função: gerar_carta
# Gera um número aleatório entre 1 e 13 (valor de uma carta)
gerar_carta:
    li a0, 13
    li a7, 42         # Chamada de sistema RARS para gerar número aleatório
    ecall
    addi a0, a0, 1    # Adiciona 1 para obter valor entre 1 e 13
    ret

# Função: ler_opcao
# Lê a entrada do jogador (1 - Hit, 2 - Stand)
ler_opcao:
    li a7, 5         # syscall para ler um inteiro
    ecall
    ret

finalizar:
    # Mensagem para jogar novamente ou sair
    la a0, msg_deseja_jogar
    jal ra, print_string
    jal ra, ler_opcao
    li t0, 1
    beq a0, t0, _start  # Reinicia o jogo se opção for 1 (Sim)
    li a7, 10          # syscall para encerrar o programa
    ecall
