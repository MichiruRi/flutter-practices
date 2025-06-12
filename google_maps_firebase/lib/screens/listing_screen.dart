import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_firebase/screens/google_maps_screen.dart';

class ListingScreen extends StatefulWidget {
  const ListingScreen({super.key, required this.name});

  final String name;

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  void delete(docId) async {
    await FirebaseFirestore.instance
        .collection('3B')
        .doc(widget.name)
        .collection('markers')
        .doc(docId)
        .delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed:
              () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => GoogleMapsScreen(name: widget.name),
                ),
              ),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('3B')
                .doc(widget.name)
                .collection('markers')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var doc = docs[index];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) => delete(doc.id),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        '${doc['position']['lat']}, ${doc['position']['lng']}',
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
