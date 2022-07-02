// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:phone_call_app/pages.dart';

class PhoneCallApp extends StatefulWidget {
  const PhoneCallApp({Key? key}) : super(key: key);

  @override
  State<PhoneCallApp> createState() => _PhoneCallAppState();
}

class _PhoneCallAppState extends State<PhoneCallApp> {
  var popItems = ["Call history", "Settings"];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                PopupMenuButton(itemBuilder: (BuildContext context) {
                  return popItems
                      .map((e) => PopupMenuItem(
                            child: Text(e.toString()),
                            value: e,
                          ))
                      .toList();
                })
              ],
              backgroundColor: Colors.blueAccent,
              title: Text(
                "Phone",
                style: TextStyle(fontSize: 30),
              ),
              // ignore: prefer_const_literals_to_create_immutables
              bottom: TabBar(
                  indicatorColor: Colors.white,
                  labelStyle: TextStyle(fontSize: 20),
                  // ignore: prefer_const_literals_to_create_immutables
                  tabs: [
                    Tab(
                      text: "Recents",
                    ),
                    Tab(
                      text: "Favourites",
                    ),
                    Tab(
                      text: "Contacts",
                    )
                  ]),
            ),
            body: TabBarView(children: [Recents(), Favorites(), contacts()]),
          ),
        ));
  }
}
