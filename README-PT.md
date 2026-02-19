[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20Me%20A%20Coffee-yellow.svg)](https://www.buymeacoffee.com/deivao)

# FindDropdown package - [[view english](https://github.com/davidsdearaujo/find_dropdown/blob/master/README.md)]

Simples e robusto FindDropdown com recurso de busca entre os itens, possibilitando utilizar uma lista de itens offline ou uma URL para filtragem, com fácil customização.

![](https://github.com/davidsdearaujo/find_dropdown/blob/master/screenshots/Screenshot_4.png?raw=true)

<img src="https://github.com/davidsdearaujo/find_dropdown/blob/master/screenshots/GIF_Simple.gif?raw=true" width="49.5%" /> <img src="https://github.com/davidsdearaujo/find_dropdown/blob/master/screenshots/GIF_Custom_Layout.gif?raw=true" width="49.5%" />

## Versões
**Flutter 3.41.x / Dart 3.x**: 1.0.2 ou superior

**Null Safety (Dart 2.x)**: 1.0.0 – 1.0.1

**Sem Null Safety**: 0.2.3 ou inferior

**RxDart 0.23.x ou inferior**: 0.1.7+1

## pubspec.yaml
```yaml
find_dropdown: ^1.0.2
```

> Requer `sdk: ">=3.0.0 <4.0.0"` e Flutter 3.41.x+.

## Import
```dart
import 'package:find_dropdown/find_dropdown.dart';
```

## Implementação simples
```dart
FindDropdown<String>(
  items: const ["Brasil", "Itália", "Estados Unidos", "Canadá"],
  label: "País",
  onChanged: (String? item) => log('$item'),
  selectedItem: "Brasil",
);
```

## Múltiplos itens selecionáveis
```dart
FindDropdown<String>.multiSelect(
  items: const ["Brasil", "Itália", "Estados Unidos", "Canadá"],
  label: "País",
  onChanged: (List<String> items) => log('$items'),
  selectedItems: const ["Brasil"],
);
```

## Validação
```dart
FindDropdown<String>(
  items: const ["Brasil", "Itália", "Estados Unidos", "Canadá"],
  label: "País",
  onChanged: (String? item) => log('$item'),
  selectedItem: "Brasil",
  validate: (String? item) {
    if (item == null) return "Campo obrigatório";
    if (item == "Brasil") return "Item inválido";
    return null; // null significa sem erro
  },
);
```

## Implementação com endpoint (utilizando o [package Dio](https://pub.dev/packages/dio))
```dart
FindDropdown<UserModel>(
  label: "Nome",
  onFind: (String filter) async {
    final response = await Dio().get<List<dynamic>>(
      "http://5d85ccfb1e61af001471bf60.mockapi.io/user",
      queryParameters: {"filter": filter},
    );
    return UserModel.fromJsonList(response.data ?? []);
  },
  onChanged: (UserModel? data) => log('$data'),
);
```

## Limpar os itens selecionados
```dart
final countriesKey = GlobalKey<FindDropdownState<String>>();

Column(
  children: [
    FindDropdown<String>(
      key: countriesKey,
      items: const ["Brasil", "Itália", "Estados Unidos", "Canadá"],
      label: "País",
      selectedItem: "Brasil",
      showSearchBox: false,
      onChanged: (selectedItem) => log("country: $selectedItem"),
    ),
    ElevatedButton(
      onPressed: () => countriesKey.currentState?.clear(),
      child: const Text('Limpar Países'),
    ),
  ],
)
``` 

## Alterar os itens selecionados
```dart
final countriesKey = GlobalKey<FindDropdownState<String>>();

Column(
  children: [
    FindDropdown<UserModel>(
      label: "Nome",
      onFind: (String filter) => getData(filter),
      searchBoxDecoration: const InputDecoration(
        hintText: "Search",
        border: OutlineInputBorder(),
      ),
      onChanged: (UserModel? data) {
        log('$data');
        countriesKey.currentState?.setSelectedItem("Brasil");
      },
    ),
    FindDropdown<String>(
      key: countriesKey,
      items: const ["Brasil", "Itália", "Estados Unidos", "Canadá"],
      label: "País",
      selectedItem: "Brasil",
      showSearchBox: false,
      onChanged: (selectedItem) => log("country: $selectedItem"),
    ),
  ],
)
``` 


### [MAIS EXEMPLOS](https://github.com/davidsdearaujo/find_dropdown/tree/master/example)

## Customização de layout
É possível customizar o layout do FindDropdown e de seus itens. [EXEMPLO](https://github.com/davidsdearaujo/find_dropdown/tree/master/example#custom-layout-endpoint-example)

Para **customizar o FindDropdown**, temos a propriedade `dropdownBuilder`, que recebe uma função com os parâmetros:
- `BuildContext context`: Contexto do item atual;
- `T item`: Item atual, onde **T** é o tipo passado no construtor do FindDropdown.

Para **customizar os itens**, temos a propriedade `dropdownItemBuilder`, que recebe uma função com os parâmetros:
- `BuildContext context`: Contexto do item atual;
- `T item`: Item atual, onde **T** é o tipo passado no construtor do FindDropdown.
- `bool isSelected`: Boolean que informa se o item atual está selecionado.

# Atenção
Para usar um modelo como item no dropdown, é necessário implementar os métodos **toString**, **equals** e **hashcode**, conforme mostrado abaixo:

```dart
class UserModel {
  final String id;
  final DateTime? createdAt;
  final String name;
  final String avatar;

  UserModel({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) => other is UserModel && other.id == id;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ createdAt.hashCode;
}
```
