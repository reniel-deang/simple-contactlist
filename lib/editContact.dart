import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'variable.dart';

class EditContact extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String email;
  final String numberid;

  const EditContact({
    Key? key,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.numberid,
    required this.onContactUpdated, // Added callback function
  }) : super(key: key);

  final Function()? onContactUpdated; // Callback function

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  late TextEditingController _names;
  late TextEditingController _email;
  late TextEditingController _numbers;
  late String msg;

  @override
  void initState() {
    _names = TextEditingController(text: widget.name);
    _email = TextEditingController(text: widget.email);
    _numbers = TextEditingController(text: widget.phoneNumber);
    msg = '';
    super.initState();
  }

  Future<void> updateContact() async {
    final uri = ip + 'updateData.php';

    Map<String, dynamic> data = {
      'numberid': widget.numberid,
      'names': _names.text,
      'numbers': _numbers.text,
      'email': _email.text,
    };
    final response = await http.post(
      Uri.parse(uri),
      body: data,
    );
    print(response.body);
    setState(() {
      msg = response.body;
    });
    if (widget.onContactUpdated != null) {
      widget.onContactUpdated!(); // Trigger callback function
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Contact',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter new name',
                    ),
                    controller: _names,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Phone',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+*#]')), // Allow only digits and '+'
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter new phone number',
                    ),
                    controller: _numbers,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter new email',
                    ),
                    controller: _email,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    await updateContact();
                    Navigator.pop(context);


                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Contact Editted',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold,),),
                        duration: const Duration(milliseconds: 1000),
                        backgroundColor: Colors.blue,
                      ),
                    );


                  },
                  child: Text('Save'),
                ),
              ],
            ),
            Text('$msg'),
          ],
        ),
      ),
    );
  }
}
