import 'package:flutter/material.dart';

/// Dados de tema para customização visual do [FindDropdown].
///
/// Permite personalizar cores e estilos de texto. Quando uma propriedade
/// não é informada, o valor padrão do widget é utilizado.
///
/// Exemplo:
/// ```dart
/// FindDropdown<String>(
///   items: const ['Opção 1', 'Opção 2'],
///   label: 'Selecione',
///   onChanged: (_) {},
///   theme: FindDropdownThemeData(
///     dropdownBackgroundColor: Colors.grey[100],
///     iconColor: Colors.blue,
///     fontFamily: 'Roboto',
///   ),
/// );
/// ```
class FindDropdownThemeData {
  /// Cria um tema para o FindDropdown.
  const FindDropdownThemeData({
    this.dropdownBackgroundColor,
    this.dropdownBorderColor,
    this.iconColor,
    this.selectedItemStyle,
    this.validationErrorColor,
    this.validationMessageStyle,
    this.fontFamily,
  });

  /// Cor de fundo do container do dropdown.
  /// Padrão: [Colors.white]
  final Color? dropdownBackgroundColor;

  /// Cor da borda do container.
  /// Padrão: [ThemeData.dividerColor]
  final Color? dropdownBorderColor;

  /// Cor dos ícones (clear e arrow_drop_down).
  /// Padrão: [Colors.black54]
  final Color? iconColor;

  /// Estilo do texto do item selecionado exibido no container.
  final TextStyle? selectedItemStyle;

  /// Cor da mensagem de erro de validação.
  /// Padrão: [Colors.red]
  final Color? validationErrorColor;

  /// Estilo completo da mensagem de validação.
  /// Sobrescreve [validationErrorColor] quando informado.
  final TextStyle? validationMessageStyle;

  /// Família de fonte aplicada a label, item selecionado e mensagem de validação
  /// quando não há estilo explícito para cada um.
  final String? fontFamily;

  /// Cria uma cópia com as propriedades alteradas.
  FindDropdownThemeData copyWith({
    Color? dropdownBackgroundColor,
    Color? dropdownBorderColor,
    Color? iconColor,
    TextStyle? selectedItemStyle,
    Color? validationErrorColor,
    TextStyle? validationMessageStyle,
    String? fontFamily,
  }) {
    return FindDropdownThemeData(
      dropdownBackgroundColor:
          dropdownBackgroundColor ?? this.dropdownBackgroundColor,
      dropdownBorderColor: dropdownBorderColor ?? this.dropdownBorderColor,
      iconColor: iconColor ?? this.iconColor,
      selectedItemStyle: selectedItemStyle ?? this.selectedItemStyle,
      validationErrorColor: validationErrorColor ?? this.validationErrorColor,
      validationMessageStyle:
          validationMessageStyle ?? this.validationMessageStyle,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}
