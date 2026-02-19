import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';

import 'user_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final countriesKey = GlobalKey<FindDropdownState<String>>();
  final nameKey = GlobalKey<FindDropdownState<UserModel>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FindDropdown Example')),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            FindDropdown<String>(
              items: const ['Brasil', 'Itália', 'Estados Unidos', 'Canadá'],
              label: 'País',
              onChanged: (item) {
                log('País selecionado: $item');
                countriesKey.currentState?.setSelectedItem(<String>[]);
              },
              selectedItem: 'Brasil',
              showSearchBox: false,
              labelStyle: const TextStyle(color: Colors.blue),
              backgroundColor: Colors.redAccent,
              titleStyle: const TextStyle(color: Colors.greenAccent),
              validate: (String? item) {
                if (item == null) return 'Required field';
                if (item == 'Brasil') return 'Invalid item';
                return null;
              },
            ),
            FindDropdown<String>.multiSelect(
              key: countriesKey,
              items: const ['Brasil', 'Itália', 'Estados Unidos', 'Canadá'],
              label: 'Países',
              selectedItems: const ['Brasil'],
              onChanged: (selectedItems) => log('countries: $selectedItems'),
              showSearchBox: false,
              labelStyle: const TextStyle(color: Colors.blue),
              titleStyle: const TextStyle(color: Colors.green),
              dropdownItemBuilder: (context, item, isSelected) {
                return ListTile(
                  title: Text(item.toString()),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  selected: isSelected,
                );
              },
              okButtonBuilder: (context, onPressed) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton.small(
                    onPressed: onPressed,
                    child: const Icon(Icons.check),
                  ),
                );
              },
              validate: (List<String>? items) {
                String? response;
                if (items == null || items.isEmpty) {
                  response = 'Required field';
                } else if (items.contains('Brasil')) {
                  response = "'Brasil' não pode ser selecionado.";
                }
                return response;
              },
            ),
            FindDropdown<UserModel>(
              key: nameKey,
              label: 'Nome',
              onFind: getData,
              searchBoxDecoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (UserModel? data) => log('Nome: $data'),
            ),
            const SizedBox(height: 25),
            FindDropdown<UserModel>(
              label: 'Personagem',
              onFind: getData,
              onChanged: (UserModel? data) => log('Personagem: $data'),
              dropdownBuilder: (BuildContext context, UserModel? item) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: (item?.avatar == null)
                      ? const ListTile(
                          leading: CircleAvatar(),
                          title: Text('No item selected'),
                        )
                      : ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(item!.avatar),
                          ),
                          title: Text(item.name),
                          subtitle: Text(item.createdAt.toString()),
                        ),
                );
              },
              dropdownItemBuilder:
                  (BuildContext context, UserModel item, bool isSelected) {
                return Container(
                  decoration: !isSelected
                      ? null
                      : BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                  child: ListTile(
                    selected: isSelected,
                    title: Text(item.name),
                    subtitle: Text(item.createdAt.toString()),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(item.avatar),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Theme.of(context).primaryIconTheme.color,
                  ),
                  onPressed: () => countriesKey.currentState?.clear(),
                  child: const Text('Limpar Países'),
                ),
                const SizedBox(width: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Theme.of(context).primaryIconTheme.color,
                  ),
                  onPressed: () => nameKey.currentState?.clear(),
                  child: const Text('Limpar Nome'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<List<UserModel>> getData(String filter) async {
    final response = await Dio().get<List<dynamic>>(
      'http://5d85ccfb1e61af001471bf60.mockapi.io/user',
      queryParameters: {'filter': filter},
    );
    return UserModel.fromJsonList(response.data ?? []);
  }
}
