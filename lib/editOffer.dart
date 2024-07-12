import 'dart:convert';

import 'package:adopet_uas/class/pet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class EditOffer extends StatefulWidget {
  int petId;
  
  EditOffer({
    super.key,
    required this.petId,
  });

  @override
  _EditOfferState createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOffer> {
  final _formKey = GlobalKey<FormState>();
  String pet_name = "";
  String pet_type = "";
  String pet_image = "";
  String pet_description = "";
  String? users_id;
  Pet? _pet;

  TextEditingController _petnameController = TextEditingController();
  TextEditingController _pettypeController = TextEditingController();
  TextEditingController _petimageController = TextEditingController();
  TextEditingController _petdescriptionController = TextEditingController();

  Future<String> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String _user_id = prefs.getString("user_id") ?? '';
    return _user_id;
  }


  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421043/adopet/detail_pet.php"),
        body: {'id': widget.petId.toString()});
    if (response.statusCode == 200) {
      print(response.body);
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      for (var mov in json['data']) {
        _pet = Pet.fromJSON(mov);
      }
      setState(() {
        _petnameController.text = _pet!.pet_name;
        _pettypeController.text = _pet!.pet_type;
        _petimageController.text = _pet!.pet_image;
        _petdescriptionController.text = _pet!.pet_description;
        print(_petnameController.text);
      });
    });
  }

  Future<void> submit() async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160421043/adopet/edit_offer.php"),
      body: {
        'pet_id': widget.petId.toString(),
        'pet_name': _petnameController.text,
        'pet_type': _pettypeController.text,
        'pet_image' : _petimageController.text,
        'pet_description' : _petdescriptionController.text
      },
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Pet data updated successfully')));
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
    bacaData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Offer"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: _petnameController,
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
                controller: _pettypeController,
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
                  controller: _petdescriptionController,
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
                  controller: _petimageController,
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