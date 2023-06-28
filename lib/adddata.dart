import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

class AddDataScreenActivity extends StatefulWidget {
  const AddDataScreenActivity({super.key});

  @override
  State<AddDataScreenActivity> createState() => _AddDataScreenActivityState();
}

class _AddDataScreenActivityState extends State<AddDataScreenActivity> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController titlecontroller = new TextEditingController();
  TextEditingController descriptioncontroller = new TextEditingController();
  String? imageUrl;
  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    XFile image;
    //Check Permissions
    // await Permission.photos.request();

    // var permissionStatus = await Permission.photos.status;

    // if (permissionStatus.isGranted) {
    //Select Image
    image = (await _imagePicker.pickImage(source: ImageSource.gallery))!;
    var file = File(image.path);

    if (image != null) {
      //Upload to Firebase
      var snapshot =
          await _firebaseStorage.ref().child('images/imageName').putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      print(downloadUrl);

      setState(() {
        imageUrl = downloadUrl;
      });
    } else {
      print('No Image Path Received');
    }
    // } else {
    //   print('Permission not granted. Try Again with permission access');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Data"),
      ),
      body: Column(
        children: [
          Form(
              key: _formkey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: (imageUrl != null)
                            ? NetworkImage(imageUrl!)
                            : NetworkImage(
                                'https://i.imgur.com/sUFH1Aq.png',
                              ),
                      ),
                      InkWell(
                          onTap: () {
                            uploadImage();
                          },
                          child: Icon(Icons.upload_file)),
                    ],
                  ),
                  TextFormField(
                    controller: titlecontroller,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      icon: Icon(Icons.title),
                    ),
                    validator: ((value) {
                      if (value!.isEmpty || value == null) {
                        return "Please enter title";
                      }
                    }),
                  ),
                  TextFormField(
                    controller: descriptioncontroller,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      icon: Icon(Icons.description),
                    ),
                    validator: ((value) {
                      if (value!.isEmpty || value == null) {
                        return "Please enter description";
                      }
                    }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          await FirebaseFirestore.instance
                              .collection('userdata')
                              .add({
                            'title': titlecontroller.text,
                            'Description': descriptioncontroller.text,
                            'imageurl': imageUrl != null ? imageUrl : '',
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text("Submit"))
                ],
              )),
        ],
      ),
    );
  }
}
