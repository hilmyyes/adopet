import 'dart:convert';

import 'package:adopet_uas/class/pet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



  List<String> status = [
  'waiting',
  'rejected',
  'approved'
];

class Adopt extends StatefulWidget {


  Adopt({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AdoptState();
  }
}

class AdoptState extends State<Adopt> {
  List<Pet> list_pet = [];
  String? users_id;
  String statusVal = "";
  Pet? _pets;

  Future<String> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String _user_id = prefs.getString("user_id") ?? '';
    return _user_id;
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
        title: Text("Adopt"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: DropdownButton<String>(
                  dropdownColor: Colors.grey[100],
                  hint: Text("Laporan Adopt"),
                  isDense: false,
                  onChanged: (value) {
                    setState(() {
                      statusVal = value!;
                    });
                  },
                  items: status.map<DropdownMenuItem<String>>(
                    (String val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  statusVal,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
              statusVal == "waiting"
                  ? Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: MediaQuery.of(context).size.height - 200,
                        child: FutureBuilder(
                          future: fetchData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Text("Error! ${snapshot.error}");
                              } else if (snapshot.hasData) {
                                return AdoptPetList(snapshot.data.toString());
                              } else {
                                return const Text("No data");
                              }
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    )
                  : statusVal == "rejected"
                      ? Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            height: MediaQuery.of(context).size.height - 200,
                            child: FutureBuilder(
                              future: fetchData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return Text("Error! ${snapshot.error}");
                                  } else if (snapshot.hasData) {
                                    return AdoptPetList(snapshot.data.toString());
                                  } else {
                                    return const Text("No data");
                                  }
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                        )
                      : statusVal == "approved"
                          ? Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height - 200,
                                child: FutureBuilder(
                                  future: fetchData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        return Text("Error! ${snapshot.error}");
                                      } else if (snapshot.hasData) {
                                        return AdoptPetList(
                                            snapshot.data.toString());
                                      } else {
                                        return const Text("No data");
                                      }
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              ),
                            )
                          : Text(""),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Ini untuk back-end / API terhadap status.


  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421043/adopet/adopt.php"),
                body: {'user_id': users_id.toString(),
                        'status': statusVal.toString()});
    if (response.statusCode == 200) {

      print(response.body);
      print("status : ${statusVal.toString()} || user_id : ${users_id.toString()}");
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  Widget AdoptPetList(data) {
    list_pet = [];
    Map json = jsonDecode(data);
    for (var pets in json['data']) {
      Pet pet = Pet.fromJSON(pets);
      list_pet.add(pet);
    }

    return ListView.builder(
        itemCount: list_pet.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.network(
                    list_pet[index].pet_image,
                    fit: BoxFit.cover,
                  ),
                  ListTile(
                    leading: Icon(Icons.pets, size: 30),
                    title: GestureDetector(
                        child: Text(list_pet[index].pet_name),
                        onTap: () {
                        }),
                    subtitle: Text(list_pet[index].pet_description),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                ],
              ));
        });
  }
}
