// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HighScoretile extends StatelessWidget {
  final documentId;
  const HighScoretile({Key? key, required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // correction of highscores
    CollectionReference highscores =
        FirebaseFirestore.instance.collection("highscore");
    return FutureBuilder<DocumentSnapshot>(
      future: highscores.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Row(
            children: [
              Text(
                data['score'].toString(),
              ),
              SizedBox(
                width: 10,
              ),
              Text(data['name']),
            ],
          );
        } else {
          return Text("Loading");
        }
      },
    );
  }
}
