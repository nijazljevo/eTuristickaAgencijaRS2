import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:eturistickaagencija_mobile/model/destinacija.dart';
import 'package:eturistickaagencija_mobile/services/APIService.dart';
import 'package:eturistickaagencija_mobile/utils/util.dart';
import '../model/ocjena.dart';
import 'Rezervacija.dart';

class DestinacijaDetailsScreen extends StatefulWidget {
  final Destinacija destinacija;

  const DestinacijaDetailsScreen({
    Key? key,
    required this.destinacija,
  }) : super(key: key);

  @override
  _DestinacijaDetailsScreenState createState() => _DestinacijaDetailsScreenState();
}

class _DestinacijaDetailsScreenState extends State<DestinacijaDetailsScreen> {
  double rating = 0.0;
  String comment = '';
  bool hasRated = false;
  late Future<bool> _ratingCheckFuture;

  @override
  void initState() {
    super.initState();
    _ratingCheckFuture = checkIfAlreadyRated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalji destinacije',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _ratingCheckFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Došlo je do greške.'));
          } else {
            return SingleChildScrollView(
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
                  StatefulBuilder(
                    builder: (context, setStateLocal) {
                      return Column(
                        children: [
                          Slider(
                            value: rating,
                            min: 0.0,
                            max: 5.0,
                            divisions: 5,
                            onChanged: hasRated ? null : (value) {
                              setStateLocal(() {
                                rating = value;
                              });
                            },
                          ),
                          Text(
                            'Vaša ocjena: $rating',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Komentar',
                    ),
                    enabled: !hasRated,
                    onChanged: (value) {
                      comment = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (!hasRated) {
                            submitRating();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Već ste ocijenili ovu destinaciju."),
                              ),
                            );
                          }
                        },
                        child: const Text('Ocijeni'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          navigateToReservation();
                        },
                        child: const Text('Rezervisi'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
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
  
    print('JSON data: $jsonString');

    await APIService.post("Ocjene", json.encode(jsonData));
     setState(() {
      hasRated = true;
    });
    FocusScope.of(context).unfocus();
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
  
  Future<bool> checkIfAlreadyRated() async {
    final result = await APIService.checkIfAlreadyRated(APIService.korisnikId, widget.destinacija.id) == true;
    hasRated = result;
    return result;
  }
}
