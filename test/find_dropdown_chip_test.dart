import 'package:find_dropdown_plus/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FindDropdownChip (single)', () {
    testWidgets('renderiza label corretamente', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdownChip<String>(
              label: 'País',
              items: const ['Brasil', 'EUA'],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('País'), findsOneWidget);
    });

    testWidgets('exibe Chip com item selecionado inicial', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdownChip<String>(
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
      expect(find.byType(Chip), findsOneWidget);
    });

    testWidgets('não exibe label quando labelVisible é false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdownChip<String>(
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

    testWidgets('setSelectedItem atualiza Chip via GlobalKey', (tester) async {
      final key = GlobalKey<FindDropdownChipState<String>>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdownChip<String>(
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
      expect(find.byType(Chip), findsOneWidget);
    });

    testWidgets('clear() limpa o valor e remove o Chip', (tester) async {
      final key = GlobalKey<FindDropdownChipState<String>>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdownChip<String>(
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

      expect(find.byType(Chip), findsOneWidget);

      key.currentState?.clear();
      await tester.pump();
      await tester.pump();

      expect(find.byType(Chip), findsNothing);
    });
  });

  group('FindDropdownChip (multiSelect)', () {
    testWidgets('renderiza label corretamente', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdownChip<String>.multiSelect(
              label: 'Países',
              items: const ['Brasil', 'EUA', 'Canadá'],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Países'), findsOneWidget);
    });

    testWidgets('exibe múltiplos Chips para itens selecionados', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdownChip<String>.multiSelect(
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

      expect(find.text('Brasil'), findsOneWidget);
      expect(find.text('Canadá'), findsOneWidget);
      expect(find.byType(Chip), findsNWidgets(2));
    });

    testWidgets('clear() remove todos os Chips', (tester) async {
      final key = GlobalKey<FindDropdownChipState<String>>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindDropdownChip<String>.multiSelect(
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

      expect(find.byType(Chip), findsOneWidget);

      key.currentState?.clear();
      await tester.pump();
      await tester.pump();

      expect(find.byType(Chip), findsNothing);
    });
  });
}
