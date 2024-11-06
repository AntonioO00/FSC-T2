# Desenvolvimento do Jogo de Cartas Blackjack

## Objetivo

O objetivo deste trabalho é implementar uma versão simplificada do jogo de cartas Blackjack (também conhecido como 21) em Assembly para a arquitetura RISC-V (RV32). O foco é a compreensão e aplicação de conceitos de manipulação de dados, controle de fluxo e interação com o usuário através do terminal.

## Descrição do Jogo

O Blackjack é um jogo de cartas jogado contra um "dealer" (o computador). O objetivo é ter uma mão de cartas que some o valor mais próximo possível de 21, sem ultrapassar esse valor. Cada carta tem um valor numérico:

- Cartas numeradas (2 a 10) têm o valor correspondente ao número na carta.
- Cartas de figuras (Rei, Dama, Valete) têm valor 10.
- O Ás pode valer 1 ou 11, favorecendo sempre o jogador, sem ultrapassar 21.

## Requisitos do Jogo

### 1. Distribuição das Cartas

- O jogador e o dealer recebem inicialmente 2 cartas.
- As cartas são representadas por números de 1 a 13, onde:
  - 1 = Ás
  - 2 a 10 = Cartas numeradas
  - 11 = Valete
  - 12 = Dama
  - 13 = Rei

### 2. Regras do Jogo

- O dealer dá duas cartas ao jogador e recebe duas cartas.
- As cartas recebidas pelo jogador são visíveis, enquanto apenas uma carta do dealer é visível.
- O jogador decide se deseja “pedir mais” (Hit) uma carta ou “parar” (Stand).
- O dealer segue uma regra automática: se a soma das cartas for menor que 17, ele deve pedir mais (Hit); caso contrário, deve parar (Stand).
- O jogo termina se a mão de qualquer jogador ultrapassar 21, resultando na vitória do oponente.
- Caso contrário, vence a mão com a maior pontuação.
- Um empate é decretado se ambas as mãos somarem o mesmo valor.

### 3. Exibição no Terminal

- O jogo exibe o estado atual das mãos do jogador e do dealer no terminal.
- Após cada jogada, o jogador é questionado se deseja continuar jogando.

## Instruções de Funcionamento

1. **Início do Jogo**: O terminal exibe uma mensagem de boas-vindas e instrui o jogador a iniciar o jogo.
2. **Jogada do Jogador**: O jogador decide se deseja "pedir mais" ou "parar".
3. **Jogada do Dealer**: O dealer joga automaticamente conforme as regras estabelecidas.
4. **Resultados**: O resultado é exibido após a jogada do dealer, indicando o vencedor ou empate.

## Requisitos Técnicos

### 1. Estrutura de Dados

- Utiliza registradores para armazenar valores temporários, como as cartas do jogador e do dealer, total da mão e número de cartas.
- A memória é utilizada para armazenar as cartas restantes do baralho e manter o estado do jogo.

### 2. Controle de Fluxo

- O jogo é baseado em loops que controlam as rodadas do jogador e do dealer.
- Saltos condicionais são utilizados para verificar as condições de vitória e derrota.

### 3. Interação com o Usuário

- O programa interage com o usuário via entrada e saída padrão no terminal, utilizando chamadas de sistema.

### 4. Geração das Cartas

- Um gerador de números aleatórios é utilizado para sortear as cartas.



