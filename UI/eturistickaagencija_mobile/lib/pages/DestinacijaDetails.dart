// ignore: file_names
import 'dart:convert';
import 'package:eturistickaagencija_mobile/pages/Rezervacija.dart';
import 'package:flutter/material.dart';
import 'package:eturistickaagencija_mobile/model/destinacija.dart';
import 'package:eturistickaagencija_mobile/services/APIService.dart';
import 'package:eturistickaagencija_mobile/utils/util.dart';

import '../model/ocjena.dart';

class DestinacijaDetailsScreen extends StatefulWidget {
  final Destinacija destinacija;

  const DestinacijaDetailsScreen({
    Key? key,
    required this.destinacija,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DestinacijaDetailsScreenState createState() => _DestinacijaDetailsScreenState();
}

class _DestinacijaDetailsScreenState extends State<DestinacijaDetailsScreen> {
  double rating = 0.0;
  String comment = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalji destinacije'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.destinacija.naziv ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              widget.destinacija.slika != null && widget.destinacija.slika!.isNotEmpty
                  ? SizedBox(
                      width: 200,
                      height: 200,
                      child: imageFromBase64String(widget.destinacija.slika!),
                    )
                  : const Text('Nema dostupne slike'),
              const SizedBox(height: 16),
              const Text(
                'Ocijenite destinaciju:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Slider(
                value: rating,
                min: 0.0,
                max: 5.0,
                divisions: 5,
                onChanged: (value) {
                  setState(() {
                    rating = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Vaša ocjena: $rating',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Komentar',
                ),
                onChanged: (value) {
                  setState(() {
                    comment = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Perform the rating submission here
                  submitRating();
                },
                child: const Text('Ocijeni'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigate to reservation page
                  navigateToReservation();
                },
                child: const Text('Rezervisi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitRating() async {
    final ocjena = Ocjena(
      ocjenaUsluge: rating.toInt(),
      komentar: comment,
      destinacijaId: widget.destinacija.id!,
      korisnikId: APIService.korisnikId!,
    );

    final jsonData = ocjena.toJson();
    final jsonString = jsonEncode(jsonData);
  
    // ignore: avoid_print
    print('JSON data: $jsonString');

    await APIService.post("Ocjene", json.encode(jsonData));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: SizedBox(
          height: 20,
          child: Center(child: Text("Uspješno")),
        ),
        backgroundColor: Color.fromARGB(255, 9, 100, 13),
      ),
    );
  }

  void navigateToReservation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReservationPage(destinacija: widget.destinacija)),
    );
  }
}

