.data
msg_boas_vindas: .string "Bem-vindo ao Blackjack!\n"  # Mensagem de boas-vindas
msg_jogador_recebe: .string "O jogador recebe: "  # Mensagem indicando que o jogador recebe as cartas
msg_dealer_revela: .string "O dealer revela: "  # Mensagem indicando que o dealer revela as cartas
msg_mao_jogador: .string "Sua mão: "  # Mensagem indicando as cartas do jogador
msg_continuar: .string "O que você deseja fazer? (1 - Hit, 2 - Stand): "  # Pergunta ao jogador se ele quer 'Hit' ou 'Stand'
msg_mao_dealer: .string "O dealer tem: "  # Mensagem indicando as cartas do dealer
msg_dealer_estourou: .string "O dealer estourou! Você venceu!"  # Mensagem indicando que o dealer estourou
msg_vitoria: .string "Você venceu!\n"  # Mensagem de vitória do jogador
msg_derrota: .string "O dealer venceu!\n"  # Mensagem de derrota do jogador
msg_empate: .string "Empate!\n"  # Mensagem de empate
msg_jogar_novamente: .string "Deseja jogar novamente? (1 - Sim, 2 - Não): "  # Pergunta se o jogador quer jogar novamente

.text
.globl main

# Função principal
main:
    la a0, msg_boas_vindas          # Carrega o endereço da mensagem de boas-vindas em a0
    jal imprime_texto               # Chama a função imprime_texto para exibir a mensagem
    
    jal distribui_mao_inicial       # Distribui as cartas iniciais para jogador e dealer
    j turno_jogador                 # Vai para o turno do jogador

jogar_novamente:
    jal distribui_mao_inicial       # Chama a função para distribuir as cartas iniciais

turno_jogador:
    jal calcula_soma_jogador        # Chama a função para calcular e exibir a soma das cartas do jogador

decisao_jogador:
    la a0, msg_continuar            # Carrega o endereço da mensagem de decisão do jogador em a0
    jal imprime_texto               # Chama a função imprime_texto para exibir a mensagem

    li a7, 5                        # Solicita a entrada do jogador (1 para Hit, 2 para Stand)
    ecall
    addi t0, a0, 0                  # Salva a escolha do jogador em t0

    li t1, 1                        # Compara se a escolha foi "Hit"
    beq t0, t1, hit_jogador         # Se "Hit", pula para o código do "Hit" do jogador

    li t1, 2                        # Compara se a escolha foi "Stand"
    beq t0, t1, turno_dealer        # Se "Stand", pula para o turno do dealer

hit_jogador:
    jal distribui_carta_jogador     # Chama a função para o jogador pedir uma carta
    jal calcula_soma_jogador        # Chama a função para atualizar a soma das cartas do jogador

    li t2, 21                       # Carrega o valor 21 em t2 (soma máxima do Blackjack)
    bgt a0, t2, dealer_vence        # Se a soma do jogador for maior que 21, o dealer vence
    j decisao_jogador               # Caso contrário, volta para a decisão do jogador

turno_dealer:
    jal calcula_soma_dealer         # Chama a função para calcular a soma das cartas do dealer

hit_dealer:
    li t2, 17                       # Carrega o valor 17 em t2 (soma mínima para o dealer continuar jogando)
    blt a0, t2, continua_dealer     # Se a soma do dealer for menor que 17, continua pedindo cartas

dealer_fim:
    jal determina_vencedor          # Chama a função para determinar o vencedor do jogo

jogar_ou_sair:
    la a0, msg_jogar_novamente      # Carrega o endereço da mensagem perguntando se o jogador quer jogar novamente
    jal imprime_texto               # Chama a função para exibir a mensagem

    li a7, 5                        # Solicita a entrada do jogador (1 para jogar novamente, 2 para sair)
    ecall
    li t1, 1
    beq a0, t1, jogar_novamente     # Se a entrada for 1, chama jogar_novamente para recomeçar o jogo

    li a7, 10                       # Se a entrada for 2, encerra o programa
    ecall

continua_dealer:
    jal distribui_carta_dealer      # Chama a função para o dealer pedir uma carta
    jal calcula_soma_dealer         # Chama a função para atualizar a soma das cartas do dealer

    li t2, 21                       # Carrega o valor 21 em t2 (soma máxima do Blackjack)
    bgt a0, t2, jogador_vence       # Se a soma do dealer for maior que 21, o jogador vence
    j hit_dealer                    # Caso contrário, volta para o dealer pedir outra carta

# Determina o vencedor
determina_vencedor:
    li t0, 21                        # Carrega 21 em t0, valor máximo no Blackjack

    blt a1, a2, dealer_vence        # Se a soma do jogador (a1) for menor que a do dealer (a2), o dealer vence
    blt a2, a1, jogador_vence       # Se a soma do dealer (a2) for menor que a do jogador (a1), o jogador vence
    j empate                        # Se as somas forem iguais, é empate

dealer_vence:
    la a0, msg_derrota              # Carrega o endereço da mensagem de derrota
    jal imprime_texto               # Chama a função para exibir a mensagem de derrota
    j jogar_ou_sair                 # Retorna para a opção de jogar novamente

jogador_vence:
    la a0, msg_vitoria              # Carrega o endereço da mensagem de vitória
    jal imprime_texto               # Chama a função para exibir a mensagem de vitória
    j jogar_ou_sair                 # Retorna para a opção de jogar novamente

empate:
    la a0, msg_empate               # Carrega o endereço da mensagem de empate
    jal imprime_texto               # Chama a função para exibir a mensagem de empate
    j jogar_ou_sair                 # Retorna para a opção de jogar novamente

# Funções auxiliares

imprime_texto:                      # Função para imprimir texto armazenado em a0
    li a7, 4                        # Serviço de impressão de string
    ecall                           # Chama o sistema operacional para exibir a string
    ret                             # Retorna para o código que chamou a função

distribui_mao_inicial:              # Função para distribuir as cartas iniciais para jogador e dealer
    jal distribui_carta_jogador     # Distribui a primeira carta para o jogador
    jal distribui_carta_jogador     # Distribui a segunda carta para o jogador
    jal distribui_carta_dealer      # Distribui a primeira carta para o dealer
    jal distribui_carta_dealer      # Distribui a segunda carta para o dealer
    ret                             # Retorna para o código que chamou a função

distribui_carta_jogador:            # Função para distribuir uma carta para o jogador
    li t0, 1                        # A carta distribuída é representada pelo valor 1 (simulação simples)
    add a0, a0, t0                  # Adiciona o valor da carta à soma das cartas do jogador
    ret                             # Retorna para o código que chamou a função

distribui_carta_dealer:             # Função para distribuir uma carta para o dealer
    li t0, 1                        # A carta distribuída é representada pelo valor 1 (simulação simples)
    add a1, a1, t0                  # Adiciona o valor da carta à soma das cartas do dealer
    ret                             # Retorna para o código que chamou a função

calcula_soma_jogador:               # Função para calcular a soma das cartas do jogador
    # O cálculo da soma das cartas do jogador é feito aqui (simulado de forma simples)
    ret                             # Retorna para o código que chamou a função

calcula_soma_dealer:                # Função para calcular a soma das cartas do dealer
    # O cálculo da soma das cartas do dealer é feito aqui (simulado de forma simples)
    ret                             # Retorna para o código que chamou a função
