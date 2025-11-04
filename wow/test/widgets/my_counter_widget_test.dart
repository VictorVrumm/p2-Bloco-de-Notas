import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart'; // Pacote de testes do Flutter
import 'package:wow/ui/widgets/my_counter_widget.dart'; // Widget a ser testado

void main() {
  // Use 'testWidgets' para testar widgets.
  // Ele fornece um 'WidgetTester' para interagir com a UI.
  testWidgets('MyCounterWidget exibe o valor inicial e incrementa', (WidgetTester tester) async {
    // 1. Arrange (Preparar):
    // pumpWidget renderiza o widget no ambiente de teste.
    // É como construir a UI em um dispositivo real.
    await tester.pumpWidget(const MyCounterWidget(title: 'Contador de Teste', initialCount: 5));

    // 2. Act (Agir):

    // Verifica se o texto inicial do contador é 5.
    // 'find.byKey' é útil quando você dá uma Key a um widget para encontrá-lo facilmente.
    expect(find.byKey(const Key('counterText')), findsOneWidget);
    expect(find.text('5'), findsOneWidget); // Verifica se há um Text widget com o texto '5'
    expect(find.text('Você apertou o botão tantas vezes:'), findsOneWidget);

    // Encontra o botão de incremento pelo seu Key
    final incrementButton = find.byKey(const Key('incrementButton'));

    // Clica no botão
    await tester.tap(incrementButton);

    // O pump() é necessário para "reconstruir" o widget após uma ação que causa uma mudança de estado (setState).
    // Sem ele, o Flutter não teria tempo de renderizar as mudanças.
    await tester.pump();

    // 3. Assert (Verificar):
    // Após o clique e o pump(), o contador deve ter incrementado para 6.
    expect(find.text('6'), findsOneWidget); // Verifica se o texto '6' está presente
    expect(find.text('5'), findsNothing); // Verifica se o texto '5' não está mais presente

    // Clica no botão novamente
    await tester.tap(incrementButton);
    await tester.pump(); // Renderiza novamente

    // Verifica se o contador agora é 7
    expect(find.text('7'), findsOneWidget);
  });

  testWidgets('MyCounterWidget exibe o título da AppBar corretamente', (WidgetTester tester) async {
    const String testTitle = 'Meu Título Personalizado';
    await tester.pumpWidget(const MyCounterWidget(title: testTitle));

    // Verifica se a AppBar exibe o título correto
    expect(find.text(testTitle), findsOneWidget);
  });

  testWidgets('MyCounterWidget inicia com o contador padrão se initialCount não for fornecido', (WidgetTester tester) async {
    await tester.pumpWidget(const MyCounterWidget(title: 'Contador Padrão'));

    // O valor inicial padrão é 0
    expect(find.text('0'), findsOneWidget);
  });
}
