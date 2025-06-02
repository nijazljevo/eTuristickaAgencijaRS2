import 'package:eturistickaagencija_mobile/pages/Destinacija.dart';
import 'package:eturistickaagencija_mobile/pages/Home.dart';
import 'package:eturistickaagencija_mobile/pages/Hotel.dart';
import 'package:eturistickaagencija_mobile/pages/Login.dart';
import 'package:eturistickaagencija_mobile/pages/MojeRezervacije.dart';
import 'package:eturistickaagencija_mobile/pages/Profil.dart';
import 'package:eturistickaagencija_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51LSdMQF0OoH4ZYTiBPFy6kiEa3ffYP6wrz9Z3Ekr55QqkHr7KfM7JhMec0qKQdpwYXi7VdWnojylBDK0FVGmunum00H681qABQ";

  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Login(),
      routes: {
        'Home': (context) => const Home(),
        'Profil': (context) => Profil(),
        'HotelListPage': (context) => const HotelListPage(),
        'DestinacijaListPage': (context) => const DestinacijaListPage(),
        'MojeRezervacijeScreen': (context) => const MojeRezervacijeScreen()
      },
      theme: ThemeData(
        brightness: lightColorScheme.brightness,
        primaryColor: lightColorScheme.primary,
        colorScheme: lightColorScheme,
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        fontFamily: 'MonaSans',
      ),
    );
  }
}
