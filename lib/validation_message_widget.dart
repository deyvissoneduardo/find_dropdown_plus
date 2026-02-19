import 'package:flutter/material.dart';

import 'find_dropdown_bloc.dart';

class ValidationMessageWidget extends StatelessWidget {
  final FindDropdownBloc<dynamic> bloc;
  const ValidationMessageWidget({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: bloc.validateMessageOut,
      builder: (context, snapshot) {
        return ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 15),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              snapshot.data ?? "",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: snapshot.hasData ? Colors.red : Colors.transparent),
            ),
          ),
        );
      },
    );
  }
}
