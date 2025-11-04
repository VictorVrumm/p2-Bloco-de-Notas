import 'package:flutter_test/flutter_test.dart'; // Importa o pacote de testes do Flutter
import 'package:wow/data/models/counter.dart'; // Importa a classe a ser testada

void main() {
  // Use 'group' para agrupar testes relacionados. Isso melhora a organização e a leitura dos resultados.
  group('Counter', () {
    // Declarar a variável fora do 'test' para que possa ser inicializada no setUp
    late Counter counter;

    // A função setUp é executada antes de CADA teste dentro deste grupo.
    // Isso garante que cada teste comece com um estado limpo.
    setUp(() {
      counter = Counter(); // Cria uma nova instância do contador para cada teste
      print('Configurando o contador para um novo teste...');
    });

    // A função tearDown é executada depois de CADA teste dentro deste grupo.
    // Usado para limpar recursos, se necessário.
    tearDown(() {
      // Não é necessário para este exemplo simples, mas útil para recursos complexos
      print('Limpando após o teste...');
    });


    test('o valor inicial do contador deve ser 0', () {
      // 1. Arrange (Preparar): Já feito pelo setUp
      // final counter = Counter(); // Não necessário se usar setUp

      // 2. Act (Agir): Nenhuma ação necessária para o valor inicial

      // 3. Assert (Verificar): Verifica se o valor atual do contador é 0.
      expect(counter.count, 0);
    });

    test('o contador deve ser incrementado', () {
      // Arrange: Já feito pelo setUp

      // Act: Incrementa o contador
      counter.increment();

      // Assert: Verifica se o valor do contador é 1 após o incremento
      expect(counter.count, 1);
    });

    test('o contador deve ser decrementado', () {
      // Arrange: Já feito pelo setUp

      // Act: Decrementa o contador
      counter.decrement();

      // Assert: Verifica se o valor do contador é -1 após o decremento
      expect(counter.count, -1);
    });

    test('o contador deve ser incrementado e depois decrementado', () {
      // Arrange: Já feito pelo setUp

      // Act: Sequência de ações
      counter.increment(); // count = 1
      counter.increment(); // count = 2
      counter.decrement(); // count = 1

      // Assert: Verifica o estado final
      expect(counter.count, 1);
    });

    test('o contador deve ser resetado para 0', () {
      // Arrange: Já feito pelo setUp, mas vamos simular um estado diferente
      counter.increment(); // count = 1
      counter.increment(); // count = 2

      // Act: Reseta o contador
      counter.reset();

      expect(counter.count, 0);
    });
  });
}
