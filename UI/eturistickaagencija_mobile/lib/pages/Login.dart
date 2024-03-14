// ignore: file_names
import 'package:flutter/material.dart';
import '../model/korisnik.dart';
import '../services/APIService.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  Korisnik? korisnik;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                  "assets/images/download.png",
                  height: 100,
                  width: 100,
                ),
              const SizedBox(height: 65),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Korisničko ime',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Lozinka',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: () async {
                    APIService.username = usernameController.text;
                    APIService.password = passwordController.text;
                    korisnik = await APIService.prijava();
                    if (korisnik != null) {
                      APIService.korisnikId = korisnik!.id;
                     // ignore: use_build_context_synchronously
                     Navigator.of(context).pushReplacementNamed('Home');
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: SizedBox(
                            height: 20,
                            child: Center(
                              child: Text(
                                'Pogrešno korisničko ime ili lozinka.',
                              ),
                            ),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Prijava',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
