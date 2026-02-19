import 'package:find_dropdown_plus/find_dropdown_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FindDropdownBloc', () {
    test('emite seedValue ao ser criado com valor inicial', () async {
      final bloc = FindDropdownBloc<String>(seedValue: 'Dart');
      addTearDown(bloc.dispose);

      expect(await bloc.selected$.first, 'Dart');
    });

    test('emite novo valor ao adicionar ao stream', () async {
      final bloc = FindDropdownBloc<String>();
      addTearDown(bloc.dispose);

      bloc.selected$.add('Flutter');
      expect(await bloc.selected$.first, 'Flutter');
    });

    test('textController começa vazio', () {
      final bloc = FindDropdownBloc<String>();
      addTearDown(bloc.dispose);

      expect(bloc.textController.text, '');
    });

    test('textController é instância de TextEditingController', () {
      final bloc = FindDropdownBloc<String>();
      addTearDown(bloc.dispose);

      expect(bloc.textController, isA<TextEditingController>());
    });

    test('validateMessageOut emite mensagem de erro quando valor é null', () async {
      final bloc = FindDropdownBloc<String>(
        validate: (v) => v == null ? 'Obrigatório' : null,
      );
      addTearDown(bloc.dispose);

      bloc.selected$.add(null);
      final message = await bloc.validateMessageOut.first;
      expect(message, 'Obrigatório');
    });

    test('validateMessageOut emite null quando valor é válido', () async {
      final bloc = FindDropdownBloc<String>(
        validate: (v) => v == null ? 'Obrigatório' : null,
      );
      addTearDown(bloc.dispose);

      bloc.selected$.add('valor válido');
      final message = await bloc.validateMessageOut.first;
      expect(message, isNull);
    });

    test('dispose fecha o stream sem erros', () async {
      final bloc = FindDropdownBloc<String>();
      await expectLater(bloc.dispose(), completes);
    });
  });
}
