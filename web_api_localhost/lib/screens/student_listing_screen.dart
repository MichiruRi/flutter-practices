// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class StudentListingScreen extends StatefulWidget {
  const StudentListingScreen({super.key});

  @override
  State<StudentListingScreen> createState() => _StudentListingScreenState();
}

class _StudentListingScreenState extends State<StudentListingScreen> {
  String api_url = 'http://192.168.123.456:3500';

  final first_name = TextEditingController();
  final last_name = TextEditingController();
  final age = TextEditingController();

  Future<dynamic> loadStudents() async {
    Uri url = Uri.parse('$api_url/api/students');
    Response response = await get(url);
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body);
      return result;
    }
    return null;
  }

  @override
  void initState() {
    loadStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web API (Localhost)'),
        actions: [
          IconButton(
            onPressed: () => showForm('Insert'),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // print(snapshot);
          List students = snapshot.data ?? [];
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              Map student = students[index];
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) => deleteStudent(student['id']),
                child: Card(
                  child: ListTile(
                    onTap: () => showForm('Update', student: student),
                    title: Text(
                      '${student['first_name']} ${student['last_name']}',
                    ),
                    subtitle: Text(student['age'].toString()),
                    trailing: Text(student['id'].toString()),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void showScaffoldMessenger(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    setState(() {});
  }

  void deleteStudent(int id) async {
    Uri url = Uri.parse('$api_url/api/students/$id');
    Response response = await delete(url);
    if (response.statusCode != 200) {
      showScaffoldMessenger('Error deleting record');
      return;
    }
    showScaffoldMessenger('Record deleted');
  }

  void insertStudent() async {
    Map student = getStudentInput();
    Uri url = Uri.parse('$api_url/api/students');
    Response response = await post(url, body: student);
    if (response.statusCode != 201) {
      showScaffoldMessenger('Error inserting record');
      return;
    }
    showScaffoldMessenger('Record inserted');
    Navigator.of(context).pop();
  }

  void updateStudent(id) async {
    Map student = getStudentInput();
    Uri url = Uri.parse('$api_url/api/students/$id');
    Response response = await put(url, body: student);
    if (response.statusCode != 200) {
      showScaffoldMessenger('Error updating record');
      return;
    }
    showScaffoldMessenger('Record updated');
    Navigator.of(context).pop();
  }

  void showForm(String action, {student}) {
    clearCtrls();
    if (action == 'Update') {
      first_name.text = student['first_name'];
      last_name.text = student['last_name'];
      age.text = student['age'].toString();
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$action Record'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: first_name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: last_name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: age,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Age',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed:
                  () =>
                      action == 'Insert'
                          ? insertStudent()
                          : updateStudent(student['id']),
              child: Text('$action record'),
            ),
          ],
        );
      },
    );
  }

  Map<String, String> getStudentInput() {
    return {
      'first_name': first_name.text,
      'last_name': last_name.text,
      'age': age.text,
    };
  }

  void clearCtrls() {
    first_name.clear();
    last_name.clear();
    age.clear();
  }
}
