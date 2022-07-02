// ignore_for_file: prefer_const_constructors, camel_case_types, unused_import, avoid_init_to_null, prefer_typing_uninitialized_variables, avoid_print, sort_child_properties_last, unused_local_variable, duplicate_ignore

import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:phone_call_app/contact_details.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () {},
          child: Icon(Icons.dialpad),
        ),
        body: Center(
            child: Text(
          "Favorites",
          style: TextStyle(fontSize: 30, color: Colors.black),
        )),
        backgroundColor: Colors.transparent);
  }
}

class Recents extends StatelessWidget {
  const Recents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {},
        child: Icon(Icons.dialpad),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.account_circle_rounded,
              color: Colors.lightGreen,
            ),
            title: SelectableText(
              "Deepak",
              style: TextStyle(color: Colors.black),
            ),
            subtitle: SelectableText(
              "+91 9917852543",
              style: TextStyle(color: Colors.black),
            ),
            trailing: IconButton(
              color: Colors.black,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return callingScreen();
                }));
              },
              icon: Icon(Icons.call),
            ),
            onTap: () {},
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
    );
  }
}

class contacts extends StatefulWidget {
  const contacts({Key? key}) : super(key: key);

  @override
  State<contacts> createState() => _contactsState();
}

class _contactsState extends State<contacts> {
  final firebase = FirebaseFirestore.instance;
  final _searchController = TextEditingController();
  var moreItems = ["delete", "edit"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () {},
          child: Icon(Icons.dialpad),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                    },
                    icon: Icon(Icons.clear),
                  ),
                  labelText: "search contact",
                  icon: Icon(Icons.search),
                  labelStyle: TextStyle(color: Colors.black, fontSize: 25),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100)),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  child: IconButton(
                    onPressed: () {
                      setState(() async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddContactNumber()));
                      });
                    },
                    icon: Icon(Icons.person_add_alt_sharp),
                  ),
                )
              ],
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: firebase.collection("ContactsList").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, i) {
                        QueryDocumentSnapshot x = snapshot.data!.docs[i];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(x['firstName'][0].toUpperCase() +
                                x['lastName'][0].toUpperCase()),
                          ),
                          title: SelectableText(
                            x['firstName'] + " " + x['lastName'],
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: SelectableText(
                            x['Number'],
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: PopupMenuButton(
                              icon: Icon(
                                Icons.more_vert_sharp,
                                color: Colors.black,
                              ),
                              onSelected: (value) {
                                setState(() {
                                  if (value == "delete") {
                                    deleteData(x['Number']);
                                  } else if (value == "edit") {
                                    editData(context, x);
                                  }
                                });
                              },
                              itemBuilder: (BuildContext context) {
                                return moreItems.map((String? selecteditem) {
                                  return PopupMenuItem(
                                    child: Text(selecteditem.toString()),
                                    value: selecteditem,
                                  );
                                }).toList();
                              }),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ContactDetails(x: x);
                            }));
                          },
                        );
                      });
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )),
          ],
        ),
        backgroundColor: Colors.transparent);
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

class callingScreen extends StatefulWidget {
  const callingScreen({Key? key}) : super(key: key);

  @override
  State<callingScreen> createState() => _callingScreenState();
}

class _callingScreenState extends State<callingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                // ignore: sort_child_properties_last
                child: Text(
                  "D",
                  style: TextStyle(color: Colors.black, fontSize: 60),
                ),
                backgroundColor: Colors.green,
              ),
              Text(
                "calling.....",
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Deepak", style: TextStyle(fontSize: 30)),
              SizedBox(
                height: 10,
              ),
              Text("Phone +919917852543", style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      IconButton(
                        iconSize: 50,
                        onPressed: () {},
                        icon: Icon(Icons.mic_off_rounded),
                      ),
                      Text(
                        "mute",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Column(
                    children: [
                      IconButton(
                        iconSize: 50,
                        onPressed: () {},
                        icon: Icon(Icons.dialpad),
                      ),
                      Text(
                        "Keypad",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Column(
                    children: [
                      IconButton(
                        iconSize: 50,
                        onPressed: () {},
                        icon: Icon(Icons.volume_up),
                      ),
                      Text(
                        "speaker",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      IconButton(
                        iconSize: 50,
                        onPressed: () {},
                        icon: Icon(Icons.add_call),
                      ),
                      Text(
                        "Add call",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Column(
                    children: [
                      IconButton(
                        iconSize: 50,
                        onPressed: () {},
                        icon: Icon(Icons.pause_circle_outline_rounded),
                      ),
                      Text(
                        "Hold",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Column(
                    children: [
                      IconButton(
                        iconSize: 50,
                        onPressed: () {},
                        icon: Icon(Icons.radio_button_checked_rounded),
                      ),
                      Text(
                        "Record",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.red,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.call_end_sharp),
                    iconSize: 50,
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}

class AddContactNumber extends StatefulWidget {
  const AddContactNumber({Key? key}) : super(key: key);

  @override
  State<AddContactNumber> createState() => _AddContactNumberState();
}

class _AddContactNumberState extends State<AddContactNumber> {
  final _firstTextController = TextEditingController();
  final _lastTextController = TextEditingController();
  final _numberController = TextEditingController();
  String? checkTextError = null, checkNumberError = null;
  final firebase = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close)),
        backgroundColor: Colors.blueAccent,
        title: Text("Create new contact"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              TextField(
                maxLength: 20,
                controller: _firstTextController,
                decoration: InputDecoration(
                    errorText: checkTextError,
                    labelText: "First Name",
                    labelStyle: TextStyle(fontSize: 30, color: Colors.black),
                    fillColor: Colors.black12,
                    filled: true,
                    icon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    hintText: "Enter your first Name",
                    suffixIcon: IconButton(
                        onPressed: () {
                          _firstTextController.clear();
                        },
                        icon: Icon(Icons.clear))),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                maxLength: 20,
                controller: _lastTextController,
                decoration: InputDecoration(
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: "Last Name",
                    labelStyle: TextStyle(fontSize: 30, color: Colors.black),
                    hintText: "Enter your Last Name",
                    suffixIcon: IconButton(
                        onPressed: () {
                          _lastTextController.clear();
                        },
                        icon: Icon(Icons.clear))),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                maxLength: 13,
                keyboardType: TextInputType.numberWithOptions(),
                controller: _numberController,
                decoration: InputDecoration(
                    prefixText: "+91  ",
                    prefixStyle: TextStyle(color: Colors.black),
                    errorText: checkNumberError,
                    fillColor: Colors.black12,
                    filled: true,
                    labelText: "Mobile",
                    labelStyle: TextStyle(fontSize: 30, color: Colors.black),
                    border: OutlineInputBorder(),
                    hintText: "Enter your mobile Number",
                    suffixIcon: IconButton(
                        onPressed: () {
                          _numberController.clear();
                        },
                        icon: Icon(Icons.clear))),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                  ),
                  onPressed: () {
                    setState(() {
                      if (_firstTextController.text.isEmpty) {
                        checkTextError = "please enter any name";
                      } else if (_numberController.text.length < 10) {
                        checkNumberError = "please enter any number";
                      } else {
                        checkTextError = null;
                        checkNumberError = null;
                        createData();
                        Navigator.pop(context);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Save",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white70,
    );
  }

  void createData() async {
    try {
      await firebase
          .collection("ContactsList")
          .doc(_numberController.text)
          .set({
        "firstName": _firstTextController.text,
        "lastName":
            (_lastTextController.text.isEmpty) ? " " : _lastTextController.text,
        "Number": _numberController.text
      });
    } catch (e) {
      print(e);
    }
  }
}
