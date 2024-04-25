import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'variable.dart';
import 'addNewContact.dart';
import 'dart:async';
import 'view.dart';
import 'editContact.dart';

void main() {
  runApp(MaterialApp(
    home: Homepage(),
    debugShowCheckedModeBanner: false,
  ));
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  TextEditingController _search = TextEditingController();

  List<dynamic> contactList = [];

  Future<void> deleteContact(String numberid) async {
    final uri = ip + 'deleteContact.php';
    Map<String, dynamic> data = {
      'numberid': numberid,
    };
    final response = await http.post(Uri.parse(uri), body: data);
    print(response.body);
    retrieveContact();
  }

  Future<void> retrieveContact() async {
    final uri = ip + 'retrieveContact.php';
    final response = await http.get(Uri.parse(uri));
    setState(() {
      try {
        contactList = jsonDecode(response.body);
      } catch (e) {
        contactList = [];
      }
    });
  }

  Future<void>searchData() async {
    final uri = ip+'searchData.php';

    Map<String, dynamic> data = {
      "search" : _search.text,

    };
    final response = await http.post(
      Uri.parse(uri),
      body: data,
    );
    setState(() {
      contactList = jsonDecode(response.body);
    });

    print(contactList);
  }

  @override
  void initState() {
    retrieveContact();
    super.initState();
  }

  void addNewContact() {
    // Update the contact list after adding a new contact
    retrieveContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Column(
          children: [
            Text(
              'Contacts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              onChanged: (text){searchData();},
              controller: _search,
            ),

          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: ListView.builder(
          itemCount: contactList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                // Navigate to view contact page and pass contact details
              },
              child: Card(
                child: ListTile(
                  title: Text(
                    contactList[index]['names'],
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewContact(
                          name: contactList[index]['names'],
                          phoneNumber: contactList[index]['numbers'],
                          email: contactList[index]['email'],
                        ),
                      ),
                    );
                  },
                  trailing: PopupMenuButton(
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          child: Text("Edit"),
                          value: "edit",
                        ),
                        PopupMenuItem(
                          child: Text("Delete"),
                          value: "delete",
                        ),
                      ];
                    },
                    onSelected: (String value) {
                      if (value == "edit") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditContact(
                              name: contactList[index]['names'],
                              phoneNumber: contactList[index]['numbers'],
                              email: contactList[index]['email'],
                              numberid: contactList[index]['numberid'], // Pass numberid
                              onContactUpdated: () {
                                retrieveContact(); // Refresh contact list
                              },
                            ),
                          ),
                        );
                      }
                      else if (value == "delete") {
                        deleteContact(contactList[index]['numberid']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Contact Deleted',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold,),),
                            duration: const Duration(milliseconds: 1000),
                            backgroundColor: Colors.red,

                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddNewContact(onContactAdded: addNewContact),
            ),
          );
        },
        shape: CircleBorder(),
        backgroundColor: Colors.black,
      ),
    );
  }
}
