import 'package:find_dropdown_plus/rxdart/behavior_subject.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BehaviorSubject', () {
    test('emite último valor para novo listener', () async {
      final subject = BehaviorSubject<int>();
      addTearDown(subject.close);

      subject.add(1);
      subject.add(2);
      subject.add(3);

      expect(await subject.first, 3);
    });

    test('emite seedValue imediatamente quando criado com seeded()', () async {
      final subject = BehaviorSubject<int>.seeded(42);
      addTearDown(subject.close);

      expect(await subject.first, 42);
    });

    test('valueWrapper retorna último valor', () {
      final subject = BehaviorSubject<String>();
      addTearDown(subject.close);

      subject.add('hello');
      expect(subject.valueWrapper?.value, 'hello');
    });

    test('valueWrapper é null quando nenhum valor foi adicionado', () {
      final subject = BehaviorSubject<String>();
      addTearDown(subject.close);

      expect(subject.valueWrapper, isNull);
    });

    test('isClosed retorna true após close()', () async {
      final subject = BehaviorSubject<int>();
      await subject.close();
      expect(subject.isClosed, isTrue);
    });

    test('multiple listeners recebem o mesmo último valor', () async {
      final subject = BehaviorSubject<int>.seeded(10);
      addTearDown(subject.close);

      final first = await subject.first;
      final second = await subject.first;

      expect(first, 10);
      expect(second, 10);
    });

    test('distinct() filtra valores repetidos', () async {
      final subject = BehaviorSubject<int>();
      addTearDown(subject.close);

      final values = <int>[];
      final sub = subject.distinct().listen(values.add);
      addTearDown(sub.cancel);

      subject.add(1);
      subject.add(1);
      subject.add(2);
      subject.add(2);
      subject.add(3);

      await Future<void>.delayed(Duration.zero);
      expect(values, [1, 2, 3]);
    });

    test('map() transforma valores emitidos', () async {
      final subject = BehaviorSubject<int>.seeded(5);
      addTearDown(subject.close);

      final mapped = subject.map((v) => v * 2);
      expect(await mapped.first, 10);
    });
  });
}
