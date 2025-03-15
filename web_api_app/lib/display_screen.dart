import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({super.key});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  List<Map<String, String>> regions = [];
  List<Map<String, String>> provinces = [];
  List<Map<String, String>> citiesAndMunicipalities = [];
  List<Map<String, String>> barangays = [];

  bool isRegionsLoading = false;
  bool isRegionsLoaded = false;
  bool isProvincesLoading = false;
  bool isProvincesLoaded = false;
  bool isCitiesLoading = false;
  bool isCitiesLoaded = false;
  bool isBarangaysLoading = false;
  bool isBarangaysLoaded = false;

  final regionCtrl = TextEditingController();
  final provinceCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final barangayCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web API'),
        actions: [
          IconButton(
            onPressed: () => resetAll(),
            icon: Icon(Icons.restart_alt_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              if (!isRegionsLoaded)
                ElevatedButton(
                  onPressed: () => fetchRegions(),
                  child: Text('Fetch Regions'),
                ),

              isRegionsLoading ? CircularProgressIndicator() : displayRegions(),
              SizedBox(height: 8),
              isProvincesLoading
                  ? CircularProgressIndicator()
                  : displayProvinces(),
              SizedBox(height: 8),
              isCitiesLoading ? CircularProgressIndicator() : displayCities(),
              SizedBox(height: 8),
              isBarangaysLoading
                  ? CircularProgressIndicator()
                  : displayBarangays(),
              SizedBox(height: 20),
              if (regionCtrl.text.isNotEmpty)
                Column(
                  children: [
                    Text(
                      'Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                    Divider(),
                    listTileComponent('Region', regionCtrl.text),
                  ],
                ),
              if (provinceCtrl.text.isNotEmpty)
                listTileComponent('Province', provinceCtrl.text),
              if (cityCtrl.text.isNotEmpty)
                listTileComponent('City', cityCtrl.text),
              if (barangayCtrl.text.isNotEmpty)
                listTileComponent('Barangay', barangayCtrl.text),
            ],
          ),
        ),
      ),
    );
  }

  void fetchRegions() async {
    regionCtrl.clear();
    isRegionsLoading = true;
    setState(() {});
    Uri url = Uri.parse("https://psgc.gitlab.io/api/regions/");
    Response response = await get(url);
    if (response.statusCode == 200) {
      List jsonResult = jsonDecode(response.body);
      for (var item in jsonResult) {
        regions.add({'code': item['code'], 'name': item['name']});
      }
      isRegionsLoading = false;
      isRegionsLoaded = true;
      setState(() {});
    }
  }

  Widget displayRegions() {
    Widget display = SizedBox.shrink();

    if (isRegionsLoaded) {
      display = DropdownMenu(
        controller: regionCtrl,
        width: MediaQuery.of(context).size.width,
        onSelected: (value) => fetchProvinces(value!),
        hintText: 'Select region',
        dropdownMenuEntries:
            regions
                .map(
                  (item) => DropdownMenuEntry(
                    value: item['code'],
                    label: item['name'].toString(),
                  ),
                )
                .toList(),
      );
    }
    return display;
  }

  void fetchProvinces(String? regionCode) async {
    provinceCtrl.clear();
    isProvincesLoading = true;
    setState(() {});
    if (regionCode != null) {
      Uri url = Uri.parse(
        'https://psgc.gitlab.io/api/regions/$regionCode/provinces/',
      );
      Response response = await get(url);
      if (response.statusCode == 200) {
        List jsonResult = jsonDecode(response.body);
        for (var item in jsonResult) {
          provinces.add({'code': item['code'], 'name': item['name']});
        }
        isProvincesLoading = false;
        isProvincesLoaded = true;
        setState(() {});
      }
    }
  }

  Widget displayProvinces() {
    Widget display = SizedBox.shrink();

    if (isProvincesLoaded) {
      display = DropdownMenu(
        controller: provinceCtrl,
        onSelected: (value) => fetchCities(value),
        width: MediaQuery.of(context).size.width,
        hintText: 'Select province',
        dropdownMenuEntries:
            provinces
                .map(
                  (item) => DropdownMenuEntry(
                    value: item['code'],
                    label: item['name'].toString(),
                  ),
                )
                .toList(),
      );
    }

    return display;
  }

  void fetchCities(String? provinceCode) async {
    cityCtrl.clear();
    isCitiesLoading = true;
    setState(() {});
    if (provinceCode != null) {
      Uri url = Uri.parse(
        'https://psgc.gitlab.io/api/provinces/$provinceCode/cities-municipalities/',
      );
      Response response = await get(url);
      if (response.statusCode == 200) {
        List jsonResult = jsonDecode(response.body);
        for (var item in jsonResult) {
          citiesAndMunicipalities.add({
            'code': item['code'],
            'name': item['name'],
          });
        }
        isCitiesLoading = false;
        isCitiesLoaded = true;
        setState(() {});
      }
    }
  }

  Widget displayCities() {
    Widget display = SizedBox.shrink();
    if (isCitiesLoaded) {
      display = DropdownMenu(
        controller: cityCtrl,
        onSelected: (value) => fetchBarangays(value),
        width: MediaQuery.of(context).size.width,
        hintText: 'Select City/Municipality',
        dropdownMenuEntries:
            citiesAndMunicipalities
                .map(
                  (item) => DropdownMenuEntry(
                    value: item['code'],
                    label: item['name'].toString(),
                  ),
                )
                .toList(),
      );
    }
    return display;
  }

  void fetchBarangays(String? cityCode) async {
    barangayCtrl.clear();
    isBarangaysLoading = true;
    setState(() {});
    if (cityCode != null) {
      print(cityCode);
      Uri url = Uri.parse(
        'https://psgc.gitlab.io/api/cities-municipalities/$cityCode/barangays/',
      );
      Response response = await get(url);
      if (response.statusCode == 200) {
        List jsonResult = jsonDecode(response.body);
        for (var item in jsonResult) {
          barangays.add({'code': item['code'], 'name': item['name']});
        }
        isBarangaysLoading = false;
        isBarangaysLoaded = true;
        setState(() {});
      }
    }
  }

  Widget displayBarangays() {
    Widget display = SizedBox.shrink();
    if (isBarangaysLoaded) {
      display = DropdownMenu(
        onSelected: (value) => setState(() {}),
        controller: barangayCtrl,
        width: MediaQuery.of(context).size.width,
        hintText: 'Select barangay',
        dropdownMenuEntries:
            barangays
                .map(
                  (item) => DropdownMenuEntry(
                    value: item['code'],
                    label: item['name'].toString(),
                  ),
                )
                .toList(),
      );
    }
    return display;
  }

  Widget listTileComponent(String type, String controller) {
    String name = '';
    String code = '';
    switch (type) {
      case 'Region':
        name = regionCtrl.text;
        code =
            regions
                .where((item) => item['name'] == regionCtrl.text)
                .toList()
                .first['code']
                .toString();
        break;
      case 'Province':
        name = provinceCtrl.text;
        code =
            provinces
                .where((item) => item['name'] == provinceCtrl.text)
                .toList()
                .first['code']
                .toString();
        break;
      case 'City':
        name = cityCtrl.text;
        code =
            citiesAndMunicipalities
                .where((item) => item['name'] == cityCtrl.text)
                .toList()
                .first['code']
                .toString();
        break;
      case 'Barangay':
        name = barangayCtrl.text;
        code =
            barangays
                .where((item) => item['name'] == barangayCtrl.text)
                .toList()
                .first['code']
                .toString();
        break;
      default:
        break;
    }

    return Card(
      child: ListTile(
        title: Text(type),
        subtitle: Text(name),
        trailing: Text(code),
      ),
    );
  }

  void resetAll() {
    regions.clear();
    provinces.clear();
    citiesAndMunicipalities.clear();
    barangays.clear();

    isRegionsLoading = false;
    isRegionsLoaded = false;
    isProvincesLoading = false;
    isProvincesLoaded = false;
    isCitiesLoading = false;
    isCitiesLoaded = false;
    isBarangaysLoading = false;
    isBarangaysLoaded = false;

    regionCtrl.clear();
    provinceCtrl.clear();
    cityCtrl.clear();
    barangayCtrl.clear();
    setState(() {});
  }
}
