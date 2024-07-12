import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NewOffer extends StatefulWidget {
  const NewOffer({Key? key}) : super(key: key);

  @override
  _NewOfferState createState() => _NewOfferState();
}

class _NewOfferState extends State<NewOffer> {
  final _formKey = GlobalKey<FormState>();
  String pet_name = "";
  String pet_type = "";
  String pet_image = "";
  String pet_description = "";
  String? users_id;
  Future<String> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String _user_id = prefs.getString("user_id") ?? '';
    return _user_id;
  }

  Future<void> submit() async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160421043/adopet/new_offer.php"),
      body: {
        'user_id': users_id,
        'pet_name': pet_name,
        'pet_type': pet_type,
        'pet_image' : pet_image,
        'pet_description' : pet_description
      },
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Data berhasil ditambahkan')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal menambahkan data')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal mengirim permintaan')));
      throw Exception('Failed to read API');
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser().then((value) => setState(() {
          users_id = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Offer"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Pet Name'),
                onChanged: (value) => {pet_name = value},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Text must not be empty';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Pet Type'),
                onChanged: (value) => {pet_type = value},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Text must not be empty';
                  }
                  return null;
                },
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Pet Description',
                  ),
                  onChanged: (value) {
                    pet_description = value;
                  },
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 6,
                )),
            Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Pet Image',
                  ),
                  onChanged: (value) {
                    pet_image = value;
                  },
                  validator: (value) {
                    if (value == null || !Uri.parse(value).isAbsolute) {
                      return 'alamat homepage salah';
                    }
                    return null;
                  },
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null &&
                      !_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Harap Isian diperbaiki')));
                  } else {
                    submit();
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
