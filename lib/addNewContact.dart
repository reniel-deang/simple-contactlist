import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'variable.dart';
import 'package:flutter/services.dart';

class AddNewContact extends StatefulWidget {
  final VoidCallback onContactAdded;

  const AddNewContact({Key? key, required this.onContactAdded}) : super(key: key);

  @override
  State<AddNewContact> createState() => _AddNewContactState();
}

class _AddNewContactState extends State<AddNewContact> {
  TextEditingController _names = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _numbers = TextEditingController();

  Future<void> addContact() async {
    final uri = ip + 'insert.php';

    // Check if any field is empty
    if (_names.text.isEmpty || _numbers.text.isEmpty || _email.text.isEmpty) {
      // Show an alert dialog if any field is empty
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all fields.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Proceed to add contact if all fields are filled
      Map<String, dynamic> userData = {
        'names': _names.text,
        'numbers': _numbers.text,
        'email': _email.text,
      };
      final response = await http.post(
        Uri.parse(uri),
        body: userData,
      );
      print(response.body);
      _names.clear();
      _email.clear();
      _numbers.clear();
      widget.onContactAdded(); // Call the callback to update the contact list
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'New Contact Added',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: const Duration(milliseconds: 1000),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'New Contact',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: 'Name'),
              controller: _names,
            ),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+*#]')), // Allow only digits and '+'
              ],
              decoration: InputDecoration(hintText: 'Phone number'),
              controller: _numbers,
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Email'),
              controller: _email,
            ),
            SizedBox(height: 40),
            Container(
              color: Colors.black,
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  await addContact();

                },
                child: Text(
                  'Add Contact',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
