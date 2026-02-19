import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyApp renderiza AppBar com título correto', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('FindDropdown Example'), findsOneWidget);
  });

  testWidgets('MyHomePage exibe labels de País e Países', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('País'), findsOneWidget);
    expect(find.text('Países'), findsOneWidget);
  });

  testWidgets('botões Limpar Países e Limpar Nome estão presentes',
      (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Limpar Países'), findsOneWidget);
    expect(find.text('Limpar Nome'), findsOneWidget);
  });

  testWidgets('item inicial Brasil está selecionado no dropdown de País',
      (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Brasil'), findsWidgets);
  });
}
