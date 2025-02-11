import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import 'models/item.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Realm realm;
  late RealmResults<Item> items;
  final itemCtrl = TextEditingController();

  void initRealm() {
    var config = Configuration.local([Item.schema]);
    realm = Realm(config);
  }

  void loadItems() {
    items = realm.all<Item>();
    setState(() {});
  }

  void addItem() {
    if (itemCtrl.text.isNotEmpty) {
      realm.write(
        () => realm.add(Item(itemCtrl.text, 'white')),
      );
      loadItems();
      itemCtrl.clear();
    }
  }

  void deleteAllItems() {
    realm.write(
      () => realm.deleteAll<Item>(),
    );
    loadItems();
  }

  void updateItemColor(DismissDirection direction, int index) {
    String color = '';
    direction == DismissDirection.startToEnd ? color = 'red' : color = 'blue';
    realm.write(
      () => items[index].color = color,
    );
    loadItems();
  }

  @override
  void initState() {
    super.initState();
    initRealm();
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () => deleteAllItems(),
                icon: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.delete),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: itemCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Item',
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => addItem(),
                        child: Text('Add'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) =>
                            updateItemColor(direction, index),
                        child: Card(
                          color: item.color == 'white'
                              ? Colors.white
                              : item.color == 'red'
                                  ? Colors.red
                                  : Colors.blue,
                          child: ListTile(
                            textColor: item.color == 'white'
                                ? Colors.black
                                : Colors.white,
                            title: Text(item.name),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
