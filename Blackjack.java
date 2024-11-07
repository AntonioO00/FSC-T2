import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.Scanner;

public class Blackjack {
    private static final String MSG_BOAS_VINDAS = "Bem-vindo ao Blackjack!\n";
    private static final String MSG_JOGADOR_RECEBE = "O jogador recebe: ";
    private static final String MSG_DEALER_REVELA = "O dealer revela: ";
    private static final String MSG_MAO_JOGADOR = "Sua mão: ";
    private static final String MSG_CONTINUAR = "O que você deseja fazer? (1 - Hit, 2 - Stand): ";
    private static final String MSG_MAO_DEALER = "O dealer tem: ";
    private static final String MSG_DEALER_ESTOUROU = "O dealer estourou! Você venceu!";
    private static final String MSG_VITORIA = "Você venceu!\n";
    private static final String MSG_DERROTA = "O dealer venceu!\n";
    private static final String MSG_EMPATE = "Empate!\n";
    private static final String MSG_JOGAR_NOVAMENTE = "Deseja jogar novamente? (1 - Sim, 2 - Não): ";

    private static final Random random = new Random();
    private static final Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) {
        System.out.println(MSG_BOAS_VINDAS);
        boolean jogarNovamente = true;

        while (jogarNovamente) {
            List<Integer> maoJogador = new ArrayList<>();
            List<Integer> maoDealer = new ArrayList<>();

            // Distribui as cartas iniciais
            maoJogador.add(distribuiCarta());
            maoJogador.add(distribuiCarta());
            maoDealer.add(distribuiCarta());
            maoDealer.add(distribuiCarta());

            // Turno do jogador
            while (true) {
                imprimeMao(MSG_MAO_JOGADOR, maoJogador);
                System.out.print(MSG_CONTINUAR);
                int escolha = scanner.nextInt();

                if (escolha == 1) { // Hit
                    maoJogador.add(distribuiCarta());
                    if (calculaSoma(maoJogador) > 21) {
                        System.out.println(MSG_DEALER_ESTOUROU);
                        break;
                    }
                } else if (escolha == 2) { // Stand
                    break;
                }
            }

            // Turno do dealer
            while (calculaSoma(maoDealer) < 17) {
                maoDealer.add(distribuiCarta());
            }

            // Resultado final
            int somaJogador = calculaSoma(maoJogador);
            int somaDealer = calculaSoma(maoDealer);

            imprimeMao(MSG_MAO_DEALER, maoDealer);
            if (somaJogador > 21 || (somaDealer <= 21 && somaDealer > somaJogador)) {
                System.out.println(MSG_DERROTA);
            } else if (somaDealer > 21 || somaJogador > somaDealer) {
                System.out.println(MSG_VITORIA);
            } else {
                System.out.println(MSG_EMPATE);
            }

            // Jogar novamente?
            System.out.print(MSG_JOGAR_NOVAMENTE);
            int resposta = scanner.nextInt();
            jogarNovamente = resposta == 1;
        }
    }

    private static int distribuiCarta() {
        return random.nextInt(10) + 1; // Cartas de 1 a 10
    }

    private static int calculaSoma(List<Integer> mao) {
        return mao.stream().mapToInt(Integer::intValue).sum();
    }

    private static void imprimeMao(String mensagem, List<Integer> mao) {
        System.out.print(mensagem);
        for (int carta : mao) {
            System.out.print(carta + " ");
        }
        System.out.println("(Total: " + calculaSoma(mao) + ")");
    }
}
