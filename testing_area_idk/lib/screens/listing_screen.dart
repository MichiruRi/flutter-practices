import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:testing_area_idk/models/location.dart';
import 'package:testing_area_idk/models/result.dart';

class ListingScreen extends StatelessWidget {
  ListingScreen({super.key});

  final regionCtrl = TextEditingController();
  final provinceCtrl = TextEditingController();
  final cityCtrl = TextEditingController();

  Future<List> fetchRegions() async {
    Uri url = Uri.parse('https://psgc.gitlab.io/api/regions/');
    Response response = await get(url);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body);
      return result;
      // Provider.of<Result>(context, listen: false).add('Regions', result);
    }
    return [];
  }

  Future<void> fetchProvinces(String? id, BuildContext context) async {
    provinceCtrl.clear();
    cityCtrl.clear();

    if (id != null) {
      Uri url = Uri.parse('https://psgc.gitlab.io/api/regions/$id/provinces/');
      Response response = await get(url);
      if (response.statusCode == 200) {
        List result = jsonDecode(response.body);
        Provider.of<Result>(context, listen: false).add('Provinces', result);
      }
    }
  }

  Future<void> fetchCities(String? id, BuildContext context) async {
    cityCtrl.clear();
    if (id != null) {
      Uri url = Uri.parse(
        'https://psgc.gitlab.io/api/provinces/$id/cities-municipalities/',
      );
      Response response = await get(url);
      if (response.statusCode == 200) {
        List result = jsonDecode(response.body);
        Provider.of<Result>(context, listen: false).add('Cities', result);
      }
    }
  }

  void loadLocation(BuildContext context) async {
    LocalConfiguration config = Configuration.local([
      Location.schema,
    ], schemaVersion: 1);
    Realm realm = Realm(config);

    if (realm.all<Location>().isNotEmpty) {
      Provider.of<Result>(
        context,
        listen: false,
      ).updateLocation(realm.all<Location>().first);
    }
  }

  void saveLocation(BuildContext context) {
    LocalConfiguration config = Configuration.local([
      Location.schema,
    ], schemaVersion: 1);
    Realm realm = Realm(config);

    if (regionCtrl.text.isNotEmpty &&
        provinceCtrl.text.isNotEmpty &&
        cityCtrl.text.isNotEmpty) {
      realm.write(() {
        realm.deleteAll<Location>();
        realm.add(Location(regionCtrl.text, provinceCtrl.text, cityCtrl.text));
      });
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Must select all before saving')));
    }
    loadLocation(context);
  }

  void deleteLocation(BuildContext context) {
    LocalConfiguration config = Configuration.local([
      Location.schema,
    ], schemaVersion: 1);
    Realm realm = Realm(config);

    realm.write(() => realm.deleteAll<Location>());
    Provider.of<Result>(
      context,
      listen: false,
    ).updateLocation(Location('', '', ''));
  }

  @override
  Widget build(BuildContext context) {
    loadLocation(context);

    return Scaffold(
      appBar: AppBar(title: Text('testing area idk')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: fetchRegions(),
              builder: (context, snapshot) {
                List regions = snapshot.data ?? [];
                return DropdownMenu(
                  controller: regionCtrl,
                  hintText: 'Select Region',
                  width: MediaQuery.of(context).size.width,
                  menuHeight: MediaQuery.of(context).size.height / 1.4,
                  onSelected: (value) => fetchProvinces(value, context),
                  dropdownMenuEntries:
                      regions
                          .map(
                            (item) => DropdownMenuEntry(
                              value: item['code'],
                              label: item['name'],
                            ),
                          )
                          .toList(),
                );
              },
            ),
            SizedBox(height: 8),
            Consumer<Result>(
              builder: (context, result, child) {
                List provinces = result.provinces;
                List cities = result.cities;
                return Column(
                  children: [
                    DropdownMenu(
                      controller: provinceCtrl,
                      hintText: 'Select Province',
                      width: MediaQuery.of(context).size.width,
                      menuHeight: MediaQuery.of(context).size.height / 1.6,
                      onSelected: (value) => fetchCities(value, context),
                      dropdownMenuEntries:
                          provinces
                              .map(
                                (item) => DropdownMenuEntry(
                                  value: item['code'],
                                  label: item['name'],
                                ),
                              )
                              .toList(),
                    ),
                    SizedBox(height: 8),
                    DropdownMenu(
                      controller: cityCtrl,
                      hintText: 'Select City',
                      width: MediaQuery.of(context).size.width,
                      menuHeight: MediaQuery.of(context).size.height / 1.8,
                      dropdownMenuEntries:
                          cities
                              .map(
                                (item) => DropdownMenuEntry(
                                  value: item['code'],
                                  label: item['name'],
                                ),
                              )
                              .toList(),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => saveLocation(context),
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
            Divider(),
            Consumer<Result>(
              builder: (context, result, child) {
                Location location = result.location;
                if (location.province != '') {
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      Card(
                        child: ListTile(
                          title: Text(location.region),
                          subtitle: Text('Region'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(location.province),
                          subtitle: Text('Province'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(location.city),
                          subtitle: Text('City'),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () => deleteLocation(context),
                              child: Text('Delete'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {}
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
