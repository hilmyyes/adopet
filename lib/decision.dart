import 'dart:convert';

import 'package:adopet_uas/class/decision.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Decision extends StatefulWidget {
  int petId;
  
  Decision({
    super.key,
    required this.petId,
  });

  @override
  _DecisionState createState() => _DecisionState();
}

class _DecisionState extends State<Decision> {
  List<Decisions> list_decision = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Decision"),
        ),
        body: ListView(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height * 1,
                child: FutureBuilder(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text("Error! ${snapshot.error}");
                        } else if (snapshot.hasData) {
                          return AdoptPetList(snapshot.data.toString());
                        } else {
                          return const Text("No data");
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }))
          ],
        ));
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421043/adopet/decision.php"),
        body: {'pet_id': widget.petId.toString()});
    if (response.statusCode == 200) {
      // print(response.body);
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  Widget AdoptPetList(data) {
    Map json = jsonDecode(data);
    for (var pets in json['data']) {
      Decisions pet = Decisions.fromJSON(pets);
      list_decision.add(pet);
    }

    return ListView.builder(
        itemCount: list_decision.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person, size: 30),
                title: GestureDetector(
                    child: Text(list_decision[index].username),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (ctxt) => DetailPop(movieID: PMs[index].id),
                      //   ),
                      // );
                    }),
                subtitle: Text(list_decision[index].description),
              ),
              ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        submit(list_decision[index].user_id, "approved");
                      },
                      child: Text("Approved"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        submit(list_decision[index].user_id, "rejected");
                      },
                      child: Text('Rejected'),
                    ),
                  ],
                ),

            ],
          ));
        });
  }

  Future<void> submit(uid, decs) async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160421043/adopet/make_decision.php"),
      body: {
        'user_id': uid.toString(),
        'pet_id': widget.petId.toString(),
        'status': decs,
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
}
