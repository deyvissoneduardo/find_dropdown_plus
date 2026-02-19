[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20Me%20A%20Coffee-yellow.svg)](https://www.buymeacoffee.com/deivao)

# FindDropdown package - [[ver em português](https://github.com/davidsdearaujo/find_dropdown/blob/master/README-PT.md)]

Simple and robust FindDropdown with item search feature, making it possible to use an offline item list or filtering URL for easy customization.

![](https://github.com/davidsdearaujo/find_dropdown/blob/master/screenshots/Screenshot_4.png?raw=true)

<img src="https://github.com/davidsdearaujo/find_dropdown/blob/master/screenshots/GIF_Simple.gif?raw=true" width="49.5%" /> <img src="https://github.com/davidsdearaujo/find_dropdown/blob/master/screenshots/GIF_Custom_Layout.gif?raw=true" width="49.5%" />
<img src="https://user-images.githubusercontent.com/16373553/94360038-f0c22000-0080-11eb-8687-d5e8af02ed7b.png" width="49.5%" />



## Versions
**Flutter 3.41.x / Dart 3.x**: 1.0.2 or more

**Null Safety (Dart 2.x)**: 1.0.0 – 1.0.1

**Non Null Safety**: 0.2.3 or less

**RxDart 0.23.x or less**: 0.1.7+1

## pubspec.yaml
```yaml
find_dropdown: ^1.0.2
```

> Requires `sdk: ">=3.0.0 <4.0.0"` and Flutter 3.41.x+.

## Import
```dart
import 'package:find_dropdown/find_dropdown.dart';
```

## Simple implementation

```dart
FindDropdown<String>(
  items: const ["Brasil", "Itália", "Estados Unidos", "Canadá"],
  label: "País",
  onChanged: (String? item) => log('$item'),
  selectedItem: "Brasil",
);
```

## Multiple selectable items
```dart
FindDropdown<String>.multiSelect(
  items: const ["Brasil", "Itália", "Estados Unidos", "Canadá"],
  label: "País",
  onChanged: (List<String> items) => log('$items'),
  selectedItems: const ["Brasil"],
);
```

## Validation
```dart
FindDropdown<String>(
  items: const ["Brasil", "Itália", "Estados Unidos", "Canadá"],
  label: "País",
  onChanged: (String? item) => log('$item'),
  selectedItem: "Brasil",
  validate: (String? item) {
    if (item == null) return "Required field";
    if (item == "Brasil") return "Invalid item";
    return null; // null means no error
  },
);
```


## Endpoint implementation (using [Dio package](https://pub.dev/packages/dio))
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

## Clear selected items
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

## Change selected items
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

### [MORE EXAMPLES](https://github.com/davidsdearaujo/find_dropdown/tree/master/example)

## Layout customization
You can customize the layout of the FindDropdown and its items. [EXAMPLE](https://github.com/davidsdearaujo/find_dropdown/tree/master/example#custom-layout-endpoint-example)

To **customize the FindDropdown**, we have the `dropdownBuilder` property, which takes a function with the parameters:
- `BuildContext context`: current context;
- `T item`: Current item, where **T** is the type passed in the FindDropdown constructor.

To **customize the items**, we have the `dropdownItemBuilder` property, which takes a function with the parameters:
- `BuildContext context`: current context;
- `T item`: Current item, where **T** is the type passed in the FindDropdown constructor.
- `bool isSelected`: Boolean that tells you if the current item is selected.

# Attention
To use a template as an item type, you need to implement **toString**, **equals** and **hashcode**, as shown below:

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
