import 'package:find_dropdown_plus/find_dropdown_bloc.dart';
import 'package:find_dropdown_plus/validation_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ValidationMessageWidget', () {
    testWidgets('exibe mensagem de erro quando validação falha', (tester) async {
      final bloc = FindDropdownBloc<String>(
        validate: (v) => v == null ? 'Campo obrigatório' : null,
      );
      addTearDown(bloc.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValidationMessageWidget(bloc: bloc),
          ),
        ),
      );

      bloc.selected$.add(null);
      await tester.pump();
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsOneWidget);
    });

    testWidgets('não exibe mensagem em cor vermelha quando validação passa', (tester) async {
      final bloc = FindDropdownBloc<String>(
        seedValue: 'válido',
        validate: (v) => v == null ? 'Campo obrigatório' : null,
      );
      addTearDown(bloc.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValidationMessageWidget(bloc: bloc),
          ),
        ),
      );

      bloc.selected$.add('válido');
      await tester.pump();
      await tester.pump();

      final texts = tester.widgetList<Text>(find.byType(Text));
      final validationText = texts.firstWhere(
        (t) => t.style?.color == Colors.red,
        orElse: () => const Text(''),
      );
      expect(validationText.data, '');
    });

    testWidgets('tem altura mínima de 15 pixels', (tester) async {
      final bloc = FindDropdownBloc<String>(
        validate: (_) => null,
      );
      addTearDown(bloc.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValidationMessageWidget(bloc: bloc),
          ),
        ),
      );

      bloc.selected$.add(null);
      await tester.pump();
      await tester.pump();

      final constrainedBox = tester.widget<ConstrainedBox>(
        find.descendant(
          of: find.byType(ValidationMessageWidget),
          matching: find.byType(ConstrainedBox),
        ),
      );
      expect(constrainedBox.constraints.minHeight, 15);
    });
  });
}
