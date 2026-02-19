import 'package:find_dropdown_plus/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FindDropdown (single)', () {
    testWidgets('renderiza label corretamente', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdown<String>(
              label: 'País',
              items: const ['Brasil', 'EUA'],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('País'), findsOneWidget);
    });

    testWidgets('exibe item selecionado inicial', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdown<String>(
              label: 'País',
              items: const ['Brasil', 'EUA'],
              selectedItem: 'Brasil',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      expect(find.text('Brasil'), findsOneWidget);
    });

    testWidgets('não exibe label quando labelVisible é false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdown<String>(
              label: 'País',
              labelVisible: false,
              items: const ['Brasil', 'EUA'],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('País'), findsNothing);
    });

    testWidgets('exibe mensagem de validação quando valor é nulo', (tester) async {
      final key = GlobalKey<FindDropdownState<String>>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdown<String>(
              key: key,
              label: 'País',
              items: const ['Brasil', 'EUA'],
              onChanged: (_) {},
              validate: (v) => v == null ? 'Obrigatório' : null,
            ),
          ),
        ),
      );

      // Dispara a validação emitindo null manualmente
      key.currentState?.setSelectedItem(null);
      await tester.pump();
      await tester.pump();

      expect(find.text('Obrigatório'), findsOneWidget);
    });

    testWidgets('setSelectedItem atualiza valor via GlobalKey', (tester) async {
      final key = GlobalKey<FindDropdownState<String>>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdown<String>(
              key: key,
              label: 'País',
              items: const ['Brasil', 'EUA'],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      key.currentState?.setSelectedItem('EUA');
      await tester.pump();
      await tester.pump();

      expect(find.text('EUA'), findsOneWidget);
    });

    testWidgets('clear() limpa o valor selecionado', (tester) async {
      final key = GlobalKey<FindDropdownState<String>>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdown<String>(
              key: key,
              label: 'País',
              items: const ['Brasil', 'EUA'],
              selectedItem: 'Brasil',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      key.currentState?.clear();
      await tester.pump();
      await tester.pump();

      // Após limpar, o campo exibe texto vazio
      final texts = tester.widgetList<Text>(
        find.descendant(
          of: find.byType(FindDropdown<String>),
          matching: find.byType(Text),
        ),
      );
      expect(
        texts.where((t) => t.data == 'Brasil' && t.overflow == TextOverflow.ellipsis).isEmpty,
        isTrue,
      );
    });
  });

  group('FindDropdown (multiSelect)', () {
    testWidgets('renderiza label corretamente', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdown<String>.multiSelect(
              label: 'Países',
              items: const ['Brasil', 'EUA', 'Canadá'],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Países'), findsOneWidget);
    });

    testWidgets('exibe itens selecionados iniciais separados por vírgula', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdown<String>.multiSelect(
              label: 'Países',
              items: const ['Brasil', 'EUA', 'Canadá'],
              selectedItems: const ['Brasil', 'Canadá'],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();
      expect(find.text('Brasil, Canadá'), findsOneWidget);
    });

    testWidgets('clear() exibe campo vazio', (tester) async {
      final key = GlobalKey<FindDropdownState<String>>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdown<String>.multiSelect(
              key: key,
              label: 'Países',
              items: const ['Brasil', 'EUA'],
              selectedItems: const ['Brasil'],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      key.currentState?.clear();
      await tester.pump();
      await tester.pump();

      // Após limpar, o campo não exibe "Brasil" como item selecionado
      expect(find.text('Brasil, '), findsNothing);
      expect(find.text('Brasil'), findsNothing);
    });
  });
}
