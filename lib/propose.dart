import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adopet_uas/class/pet.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Propose extends StatefulWidget {
  int petId;
  String petImage;
  String petName;

  Propose(
      {super.key,
      required this.petId,
      required this.petImage,
      required this.petName});

  @override
  _ProposeState createState() => _ProposeState();
}

class _ProposeState extends State<Propose> {
  final TextEditingController _descriptionController = TextEditingController();
  String user_id = "";
  Future<void> submit() async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160421043/adopet/submit_propose.php"),
      body: {
        'user_id': user_id,
        'pet_id': widget.petId.toString(),
        'description': _descriptionController.text,
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

  Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String _user_id = prefs.getString("user_id") ?? '';
  return _user_id;
}

  @override
  void initState() {
    super.initState();
    checkUser().then((value) => setState(() {
          user_id = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(widget.petImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.petName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Ini gk tau di isi apa',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('pet id : ${widget.petId} || user id : ${user_id} || description : ${_descriptionController.text}');
                submit();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
