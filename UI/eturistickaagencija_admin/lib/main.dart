import 'package:eturistickaagencija_admin/providers/agencija_provider.dart';
import 'package:eturistickaagencija_admin/providers/destinacija_provider.dart';
import 'package:eturistickaagencija_admin/providers/drzava_provider.dart';
import 'package:eturistickaagencija_admin/providers/grad.dart';
import 'package:eturistickaagencija_admin/providers/hotel_provider.dart';
import 'package:eturistickaagencija_admin/providers/karta_provider.dart';
import 'package:eturistickaagencija_admin/providers/kontinent_provider.dart';
import 'package:eturistickaagencija_admin/providers/korisnik_provider.dart';
import 'package:eturistickaagencija_admin/providers/rezervacija_provider.dart';
import 'package:eturistickaagencija_admin/providers/uloga_provider.dart';
import 'package:eturistickaagencija_admin/screens/hotel_list_screen.dart';
import 'package:eturistickaagencija_admin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
    ChangeNotifierProvider(create: (_) => HotelProvider()),
    ChangeNotifierProvider(create: (_) => GradProvider()),
    ChangeNotifierProvider(create: (_) => KontinentProvider()),
    ChangeNotifierProvider(create: (_) => DrzavaProvider()),
    ChangeNotifierProvider(create: (_) => AgencijaProvider()),
    ChangeNotifierProvider(create: (_) => DestinacijaProvider()),
    ChangeNotifierProvider(create: (_) => KorisnikProvider()),
    ChangeNotifierProvider(create: (_) => RezervacijaProvider()),
    ChangeNotifierProvider(create: (_) => KartaProvider()),
    ChangeNotifierProvider(create: (_) => UlogaProvider()),
    ],
    child: const MyMaterialApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const LayoutExamples(), //Counter(),
    );
  }
}

// ignore: must_be_immutable
class MyAppBar extends StatelessWidget {
  String? title;
  MyAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title!);
  }
}

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;

  void _incrementCounter() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('You have pushed button $_count times'),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: const Text("Increment++"),
        ),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: const Text("Increment"),
        )
      ],
    );
  }
}

class LayoutExamples extends StatelessWidget {
  const LayoutExamples({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          color: Colors.red,
          child: Center(
            child: Container(
              height: 100,
              color: Colors.blue,
              // ignore: sort_child_properties_last
              child: const Text("Example text"),
              alignment: Alignment.bottomLeft,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text("Item 1"),
            Text("Item 2"),
            Text("Item 3"),
          ],
        ),
        Container(
          height: 150,
          color: Colors.red,
          // ignore: sort_child_properties_last
          child: const Text("Contain"),
          alignment: Alignment.center,
        )
      ],
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RS II Material app',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  // ignore: prefer_final_fields, unnecessary_new
  TextEditingController _usernameController = new TextEditingController();
  // ignore: prefer_final_fields, unnecessary_new
  TextEditingController _passwordController = new TextEditingController();
  late HotelProvider _hotelProvider;

  @override
  Widget build(BuildContext context) {
    _hotelProvider = context.read<HotelProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                //  Image.network("https://www.fit.ba/content/public/images/og-image.jpg", height: 100, width: 100,),
                Image.asset(
                  "assets/images/download.png",
                  height: 100,
                  width: 100,
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: "Username", prefixIcon: Icon(Icons.email)),
                  controller: _usernameController,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: "Password", prefixIcon: Icon(Icons.password)),
                  controller: _passwordController,
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                    onPressed: () async {
                      var username = _usernameController.text;
                      var password = _passwordController.text;
                     // _passwordController.text = username;

                      // ignore: avoid_print
                      print("login proceed $username $password");

                      Authorization.username = username;
                      Authorization.password = password;

                      try {
                        await _hotelProvider.get();

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>  const HotelListScreen(),
                          ),
                        );
                      } on Exception catch (e) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text("Error"),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK"))
                                  ],
                                ));
                      }
                    },
                    child: const Text("Login"))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
