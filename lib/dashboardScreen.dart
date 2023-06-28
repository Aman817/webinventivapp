// ignore_for_file:

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:webinventivapp/adddata.dart';

class DashBoardScreenActivity extends StatefulWidget {
  const DashBoardScreenActivity({super.key});

  @override
  State<DashBoardScreenActivity> createState() =>
      _DashBoardScreenActivityState();
}

class _DashBoardScreenActivityState extends State<DashBoardScreenActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web Inventi App"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => AddDataScreenActivity())));
        },
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('userdata').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(blurRadius: 10)],
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                (snapshot.data!.docs[index]['imageurl'] != null)
                                    ? NetworkImage(
                                        snapshot.data!.docs[index]['imageurl']!)
                                    : NetworkImage(
                                        'https://i.imgur.com/sUFH1Aq.png',
                                      ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.docs[index]['title'] ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                snapshot.data!.docs[index]['Description'] ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }));
        },
      ),
    );
  }
}
