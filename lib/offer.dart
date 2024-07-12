import 'dart:convert';
import 'package:adopet_uas/class/pet.dart';
import 'package:adopet_uas/decision.dart';
import 'package:adopet_uas/editOffer.dart';
import 'package:adopet_uas/newOffer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Offer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OfferState();
  }
}

class OfferState extends State<Offer> {
  String? users_id;
  List<Pet> list_pet = [];
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
          title: Text("Offer"),
        ),
        body: ListView(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NewOffer()
                  ),
                );
              },
              child: Text('+ Add New Offer'),
            ),
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
        Uri.parse("https://ubaya.me/flutter/160421043/adopet/offer.php"),
        body: {'user_id': users_id});
    // body: {'cari': txtcari});
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
                   AspectRatio(
                      aspectRatio: 4 / 3,
                  child: Image.network(
                    list_pet[index].pet_image,
                    fit: BoxFit.cover,
                  )),
                  ListTile(
                    leading: Icon(Icons.movie, size: 30),
                    title: GestureDetector(
                        child: Text(list_pet[index].pet_name),
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => Propose(
                          //         petId: list_pet[index].pet_id,
                          //         petImage: list_pet[index].pet_image,
                          //         petName: list_pet[index].pet_name),
                          //   ),
                          // );
                        }),
                    subtitle: Text(list_pet[index].pet_description),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Decision(petId: list_pet[index].pet_id),
                          ),
                        );
                      },
                      child: Text('Decision'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditOffer(petId: list_pet[index].pet_id),
                          ),
                        );
                      },
                      child: Text('Edit'),
                    ),
                  ),
                ],
              ));
        });
  }
}
