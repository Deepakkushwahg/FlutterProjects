// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, no_logic_in_create_state, sort_child_properties_last, prefer_const_constructors_in_immutables, prefer_const_constructors, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactDetails extends StatefulWidget {
  final x;
  ContactDetails({Key? key, this.x}) : super(key: key);

  @override
  State<ContactDetails> createState() => _ContactDetailsState(x);
}

class _ContactDetailsState extends State<ContactDetails> {
  var x;
  _ContactDetailsState(this.x);
  var firebase = FirebaseFirestore.instance;
  var someItems = [
    "Delete",
    "Share",
    "Add to Home screen",
    "Set ringtone",
    "Help & feedback"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                editData(context, x);
              },
              // ignore: prefer_const_constructors
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              )),
          PopupMenuButton(
              icon: Icon(
                Icons.more_vert_sharp,
                color: Colors.white,
              ),
              onSelected: (String value) {
                setState(() {
                  if (value == "Delete") {
                    deleteData(x['Number']);
                    Navigator.of(context).pop();
                  }
                });
              },
              itemBuilder: (BuildContext context) {
                return someItems.map((String? selecteditem) {
                  return PopupMenuItem(
                    child: Text(selecteditem.toString()),
                    value: selecteditem,
                  );
                }).toList();
              }),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          // ignore: prefer_const_constructors
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: ListView(),
    );
  }

  void deleteData(id) async {
    await firebase.collection("ContactsList").doc(id).delete();
  }

  void editData(BuildContext context, x) {
    TextEditingController firstController = TextEditingController();
    TextEditingController lastController = TextEditingController();
    TextEditingController numberController = TextEditingController();
    setState(() {
      firstController.text = x['firstName'];
      lastController.text = x['lastName'];
      numberController.text = x['Number'];
    });
    var alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      backgroundColor: Colors.black12,
      title: SizedBox(
        height: 100,
        child: Center(
          child: Text(
            "Edit contact",
            style: TextStyle(
                color: Colors.green, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: ListView(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            TextField(
              controller: firstController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: "Enter your first Name",
                  suffixIcon: IconButton(
                      onPressed: () {
                        firstController.clear();
                      },
                      icon: Icon(Icons.clear))),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: lastController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: "Enter your Last Name",
                  suffixIcon: IconButton(
                      onPressed: () {
                        lastController.clear();
                      },
                      icon: Icon(Icons.clear))),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              maxLength: 13,
              controller: numberController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: "Enter your Number",
                  suffixIcon: IconButton(
                      onPressed: () {
                        numberController.clear();
                      },
                      icon: Icon(Icons.clear))),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 250,
              height: 60,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.transparent),
                  onPressed: () {
                    updateData(
                        firstController, lastController, numberController, x);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 30, color: Colors.blue),
                  )),
            )
          ],
        ),
      ),
    );

    showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  void updateData(
      TextEditingController firstController,
      TextEditingController lastController,
      TextEditingController numberController,
      x) async {
    await firebase.collection("ContactsList").doc(x['Number']).update({
      "firstName": firstController.text,
      "lastName": (lastController.text.isEmpty) ? " " : lastController.text,
      "Number": numberController.text
    });
  }
}
