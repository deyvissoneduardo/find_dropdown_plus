import 'package:flutter/material.dart';
import 'package:select_dialog/select_dialog.dart';

import 'find_dropdown.dart';

/// Construtor customizado do Chip para cada item selecionado.
typedef FindDropdownChipBuilderType<T> = Widget Function(
  BuildContext context,
  T item,
  VoidCallback? onDeleted,
);

/// Dropdown que exibe o(s) item(ns) selecionado(s) como [Chip] do Material.
///
/// Em modo single, exibe um único Chip. Em multiSelect, exibe múltiplos Chips
/// em um [Wrap], cada um com botão de remoção via [Chip.onDeleted].
///
/// Reutiliza [FindDropdown] internamente. Documentação do Chip:
/// https://api.flutter.dev/flutter/material/Chip-class.html
class FindDropdownChip<T> extends StatefulWidget {
  final String? label;
  final bool labelVisible;
  final bool showClearButton;
  final TextStyle? labelStyle;
  final List<T>? items;
  final T? selectedItem;
  final List<T>? multipleSelectedItems;
  final FindDropdownFindType<T>? onFind;
  final FindDropdownChangedType<T>? onChanged;
  final FindDropdownMultipleItemsChangedType<T>? onMultipleItemsChanged;
  final FindDropdownItemBuilderType<T>? dropdownItemBuilder;
  final FindDropdownValidationType<T>? validate;
  final FindDropdownValidationType<List<T>>? validateMultipleItems;
  final Color? backgroundColor;
  final WidgetBuilder? emptyBuilder;
  final WidgetBuilder? loadingBuilder;
  final ErrorBuilderType<dynamic>? errorBuilder;
  final bool? autofocus;
  final int? searchBoxMaxLines;
  final int? searchBoxMinLines;
  final ButtonBuilderType? okButtonBuilder;
  final bool showSearchBox;
  final InputDecoration? searchBoxDecoration;
  final TextStyle? titleStyle;
  final BoxConstraints? constraints;
  final FindDropdownThemeData? theme;
  final FindDropdownChipBuilderType<T>? chipBuilder;

  const FindDropdownChip({
    super.key,
    required FindDropdownChangedType<T?> onChanged,
    this.label,
    this.labelStyle,
    this.items,
    this.selectedItem,
    this.onFind,
    this.dropdownItemBuilder,
    this.showSearchBox = true,
    this.showClearButton = false,
    this.validate,
    this.searchBoxDecoration,
    this.backgroundColor,
    this.titleStyle,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.constraints,
    this.autofocus,
    this.searchBoxMaxLines,
    this.searchBoxMinLines,
    this.okButtonBuilder,
    this.labelVisible = true,
    this.theme,
    this.chipBuilder,
    // ignore: prefer_initializing_formals
  })  : onChanged = onChanged,
        validateMultipleItems = null,
        multipleSelectedItems = null,
        onMultipleItemsChanged = null;

  const FindDropdownChip.multiSelect({
    super.key,
    required FindDropdownMultipleItemsChangedType<T> onChanged,
    this.label,
    this.labelStyle,
    this.items,
    List<T>? selectedItems,
    this.onFind,
    this.dropdownItemBuilder,
    this.showSearchBox = true,
    this.showClearButton = false,
    FindDropdownValidationType<List<T>>? validate,
    this.searchBoxDecoration,
    this.backgroundColor,
    this.titleStyle,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.constraints,
    this.autofocus,
    this.searchBoxMaxLines,
    this.searchBoxMinLines,
    this.okButtonBuilder,
    this.labelVisible = true,
    this.theme,
    this.chipBuilder,
  })  : onChanged = null,
        validateMultipleItems = validate,
        multipleSelectedItems = selectedItems,
        onMultipleItemsChanged = onChanged,
        selectedItem = null,
        validate = null;

  @override
  FindDropdownChipState<T> createState() => FindDropdownChipState<T>();
}

/// Estado do [FindDropdownChip], expõe [clear] e [setSelectedItem].
class FindDropdownChipState<T> extends State<FindDropdownChip<T>> {
  final GlobalKey<FindDropdownState<T>> _dropdownKey =
      GlobalKey<FindDropdownState<T>>();

  /// Limpa a seleção (single: null, multiSelect: lista vazia).
  void clear() => _dropdownKey.currentState?.clear();

  /// Atualiza o item selecionado programaticamente.
  void setSelectedItem(dynamic item) =>
      _dropdownKey.currentState?.setSelectedItem(item);

  Widget _buildChip(
    BuildContext context,
    T item,
    VoidCallback? onDeleted,
    FindDropdownThemeData? themeData,
  ) {
    if (widget.chipBuilder != null) {
      return widget.chipBuilder!(context, item, onDeleted);
    }
    final labelStyle = themeData?.selectedItemStyle ??
        (themeData?.fontFamily != null
            ? TextStyle(fontFamily: themeData!.fontFamily)
            : null);
    return Chip(
      label: Text(
        item.toString(),
        overflow: TextOverflow.ellipsis,
        style: labelStyle,
      ),
      onDeleted: onDeleted,
      deleteIconColor: themeData?.iconColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onMultipleItemsChanged != null) {
      return FindDropdown<T>.multiSelect(
        key: _dropdownKey,
        label: widget.label,
        labelStyle: widget.labelStyle,
        items: widget.items,
        selectedItems: widget.multipleSelectedItems,
        onChanged: widget.onMultipleItemsChanged!,
        dropdownItemBuilder: widget.dropdownItemBuilder,
        showSearchBox: widget.showSearchBox,
        showClearButton: widget.showClearButton,
        validate: widget.validateMultipleItems,
        searchBoxDecoration: widget.searchBoxDecoration,
        backgroundColor: widget.backgroundColor,
        titleStyle: widget.titleStyle,
        emptyBuilder: widget.emptyBuilder,
        loadingBuilder: widget.loadingBuilder,
        errorBuilder: widget.errorBuilder,
        constraints: widget.constraints,
        autofocus: widget.autofocus,
        searchBoxMaxLines: widget.searchBoxMaxLines,
        searchBoxMinLines: widget.searchBoxMinLines,
        okButtonBuilder: widget.okButtonBuilder,
        labelVisible: widget.labelVisible,
        theme: widget.theme,
        dropdownBuilder: (context, selectedItems) => _MultiChipContainer<T>(
          theme: widget.theme,
          items: selectedItems,
          dropdownKey: _dropdownKey,
          showClearButton: widget.showClearButton,
          onMultipleItemsChanged: widget.onMultipleItemsChanged!,
          buildChip: _buildChip,
        ),
      );
    }
    return FindDropdown<T>(
      key: _dropdownKey,
      label: widget.label,
      labelStyle: widget.labelStyle,
      items: widget.items,
      selectedItem: widget.selectedItem,
      onChanged: widget.onChanged!,
      dropdownItemBuilder: widget.dropdownItemBuilder,
      showSearchBox: widget.showSearchBox,
      showClearButton: widget.showClearButton,
      validate: widget.validate,
      searchBoxDecoration: widget.searchBoxDecoration,
      backgroundColor: widget.backgroundColor,
      titleStyle: widget.titleStyle,
      emptyBuilder: widget.emptyBuilder,
      loadingBuilder: widget.loadingBuilder,
      errorBuilder: widget.errorBuilder,
      constraints: widget.constraints,
      autofocus: widget.autofocus,
      searchBoxMaxLines: widget.searchBoxMaxLines,
      searchBoxMinLines: widget.searchBoxMinLines,
      okButtonBuilder: widget.okButtonBuilder,
      labelVisible: widget.labelVisible,
      theme: widget.theme,
      dropdownBuilder: (context, selectedItem) => _SingleChipContainer<T>(
        theme: widget.theme,
        item: selectedItem,
        showClearButton: widget.showClearButton,
        onClear: () => _dropdownKey.currentState?.clear(),
        buildChip: _buildChip,
      ),
    );
  }
}

class _SingleChipContainer<T> extends StatelessWidget {
  const _SingleChipContainer({
    this.theme,
    this.item,
    this.showClearButton = false,
    this.onClear,
    required this.buildChip,
  });

  final FindDropdownThemeData? theme;
  final T? item;
  final bool showClearButton;
  final VoidCallback? onClear;
  final Widget Function(
    BuildContext context,
    T item,
    VoidCallback? onDeleted,
    FindDropdownThemeData? themeData,
  ) buildChip;

  @override
  Widget build(BuildContext context) {
    final bgColor = theme?.dropdownBackgroundColor ?? Colors.white;
    final borderColor =
        theme?.dropdownBorderColor ?? Theme.of(context).dividerColor;
    final iconColor = theme?.iconColor ?? Colors.black54;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 5, 6),
      constraints: const BoxConstraints(minHeight: 40),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(width: 1, color: borderColor),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: item != null
                ? buildChip(context, item as T, null, theme)
                : const SizedBox.shrink(),
          ),
          if (showClearButton && item != null)
            GestureDetector(
              onTap: onClear,
              child: Icon(Icons.clear, size: 25, color: iconColor),
            ),
          Icon(Icons.arrow_drop_down, size: 25, color: iconColor),
        ],
      ),
    );
  }
}

class _MultiChipContainer<T> extends StatelessWidget {
  const _MultiChipContainer({
    this.theme,
    required this.items,
    required this.dropdownKey,
    this.showClearButton = false,
    required this.onMultipleItemsChanged,
    required this.buildChip,
  });

  final FindDropdownThemeData? theme;
  final List<T> items;
  final GlobalKey<FindDropdownState<T>> dropdownKey;
  final bool showClearButton;
  final FindDropdownMultipleItemsChangedType<T> onMultipleItemsChanged;
  final Widget Function(
    BuildContext context,
    T item,
    VoidCallback? onDeleted,
    FindDropdownThemeData? themeData,
  ) buildChip;

  @override
  Widget build(BuildContext context) {
    final bgColor = theme?.dropdownBackgroundColor ?? Colors.white;
    final borderColor =
        theme?.dropdownBorderColor ?? Theme.of(context).dividerColor;
    final iconColor = theme?.iconColor ?? Colors.black54;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 5, 6),
      constraints: const BoxConstraints(minHeight: 40),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(width: 1, color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: items.isEmpty
                ? const SizedBox.shrink()
                : Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: items.map((item) {
                      return buildChip(
                        context,
                        item,
                        () {
                          final newList =
                              items.where((x) => x != item).toList();
                          dropdownKey.currentState?.setSelectedItem(newList);
                          onMultipleItemsChanged(newList);
                        },
                        theme,
                      );
                    }).toList(),
                  ),
          ),
          if (showClearButton && items.isNotEmpty)
            GestureDetector(
              onTap: () {
                dropdownKey.currentState?.setSelectedItem(<T>[]);
                onMultipleItemsChanged(<T>[]);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(Icons.clear, size: 25, color: iconColor),
              ),
            ),
          Icon(Icons.arrow_drop_down, size: 25, color: iconColor),
        ],
      ),
    );
  }
}
