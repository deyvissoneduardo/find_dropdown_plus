import 'rxdart/behavior_subject.dart';
import 'package:flutter/material.dart';

class FindDropdownBloc<T> {
  final textController = TextEditingController();
  final selected$ = BehaviorSubject<T?>();

  late Stream<String?> validateMessageOut;

  FindDropdownBloc({T? seedValue, String? Function(T? selected)? validate}) {
    if (seedValue != null) selected$.add(seedValue);
    if (validate != null) {
      validateMessageOut = selected$.distinct().map(validate).distinct();
    }
  }

  Future<void> dispose() async {
    textController.dispose();
    await selected$.close();
  }
}
