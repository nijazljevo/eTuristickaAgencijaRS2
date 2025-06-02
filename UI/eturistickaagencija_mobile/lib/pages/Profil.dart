import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/korisnik.dart';
import '../model/uloga.dart';
import '../services/APIService.dart';

// ignore: use_key_in_widget_constructors
class Profil extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final _validationKey = GlobalKey<FormState>();

  TextEditingController imeController = TextEditingController();
  TextEditingController prezimeController = TextEditingController();
  TextEditingController korisnickoImeController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
        title: const Text(
          'Moj profil',
        ),
      ),
      body: bodyWidget(),
    );
  }

  Widget bodyWidget() {
    final txtIme = TextFormField(
      validator: (value) {
        return value == null || value.isEmpty ? "Obavezno polje" : null;
      },
      controller: imeController,
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Ime",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final txtPrezime = TextFormField(
      validator: (value) {
        return value == null || value.isEmpty ? "Obavezno polje" : null;
      },
      controller: prezimeController,
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Prezime",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final txtUsername = TextFormField(
      validator: (value) {
        return value == null || value.isEmpty ? "Obavezno polje" : null;
      },
      controller: korisnickoImeController,
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Korisnicko ime",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final txtEmail = TextFormField(
      validator: (value) {
        return value == null || value.isEmpty ? "Obavezno polje" : null;
      },
      controller: emailController,
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    // ignore: non_constant_identifier_names
    Widget ProfilWidget(korisnik) {
      imeController.text = korisnik.ime;
      prezimeController.text = korisnik.prezime;
      korisnickoImeController.text = korisnik.korisnikoIme;
      emailController.text = korisnik.email;

      return SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.portrait, size: 80),
                const SizedBox(height: 20),
                Form(
                  key: _validationKey,
                  child: Column(
                    children: [
                      txtIme,
                      const SizedBox(height: 16),
                      txtPrezime,
                      const SizedBox(height: 16),
                      txtUsername,
                      const SizedBox(height: 16),
                      txtEmail,
                      const SizedBox(height: 16),
                      Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            if (_validationKey.currentState!.validate()) {
                              var request = Korisnik(
                                id: APIService.korisnikId!,
                                ime: imeController.text,
                                prezime: prezimeController.text,
                                korisnikoIme: korisnickoImeController.text,
                                email: emailController.text,
                              );

                              final response = await http.put(
                                Uri.parse(
                                    'http://10.0.2.2:7073/Korisnici/${korisnik.id}'),
                                headers: {'Content-Type': 'application/json'},
                                body: jsonEncode(request.toJson()),
                              );

                              print(
                                  'Response status code: ${response.statusCode}');
                              print('Response body: ${response.body}');

                              if (response.statusCode == 200) {
                                setState(() {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: SizedBox(
                                        height: 20,
                                        child: Center(
                                          child: Text("Uspješno"),
                                        ),
                                      ),
                                      backgroundColor: Color.fromARGB(
                                        255,
                                        9,
                                        100,
                                        13,
                                      ),
                                    ),
                                  );
                                });
                              }
                            }
                          },
                          child: const Text(
                            'Spremi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return FutureBuilder(
      future: getKorisnik(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error:${snapshot.error}'));
          } else {
            return ProfilWidget(snapshot.data);
          }
        }
      },
    );
  }
}

Future<dynamic> getKorisnik() async {
  var korisnik = await APIService.GetById("Korisnici", APIService.korisnikId!);
  return Korisnik.fromJson(korisnik);
}
