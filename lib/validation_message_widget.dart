import 'package:flutter/material.dart';

import 'find_dropdown_bloc.dart';
import 'find_dropdown_theme.dart';

class ValidationMessageWidget extends StatelessWidget {
  const ValidationMessageWidget({
    super.key,
    required this.bloc,
    this.theme,
  });

  final FindDropdownBloc<dynamic> bloc;
  final FindDropdownThemeData? theme;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: bloc.validateMessageOut,
      builder: (context, snapshot) {
        final hasError = snapshot.hasData && snapshot.data != null;
        final errorColor = theme?.validationErrorColor ?? Colors.red;
        final baseStyle = theme?.validationMessageStyle ??
            Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: theme?.fontFamily,
                );
        final textStyle = baseStyle?.copyWith(
              color: hasError ? errorColor : Colors.transparent,
            ) ??
            TextStyle(
              color: hasError ? errorColor : Colors.transparent,
              fontFamily: theme?.fontFamily,
            );

        return ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 15),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              snapshot.data ?? "",
              style: textStyle,
            ),
          ),
        );
      },
    );
  }
}
