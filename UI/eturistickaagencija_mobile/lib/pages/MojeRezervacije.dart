import 'package:flutter/material.dart';
import 'package:eturistickaagencija_mobile/model/rezervacija.dart';
import 'package:eturistickaagencija_mobile/services/APIService.dart';
import 'package:eturistickaagencija_mobile/utils/util.dart';

class MojeRezervacijeScreen extends StatefulWidget {
  const MojeRezervacijeScreen({Key? key}) : super(key: key);

  @override
  _MojeRezervacijeScreenState createState() => _MojeRezervacijeScreenState();
}

class _MojeRezervacijeScreenState extends State<MojeRezervacijeScreen> {
  List<Rezervacije> mojeRezervacije = [];

  @override
  void initState() {
    super.initState();
    fetchMojeRezervacije();
  }

  Future<void> fetchMojeRezervacije() async {
    try {
      final List<dynamic>? fetchedData =
          await APIService.get('Rezervacija', null);
      if (fetchedData != null) {
        final List<Rezervacije> fetchedRezervacije = fetchedData
            .map((json) => Rezervacije.fromJson(json))
            .where((rezervacija) =>
                rezervacija.korisnikId == APIService.korisnikId)
            .toList();
        setState(() {
          mojeRezervacije = fetchedRezervacije;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Greška'),
              content: const Text(
                  'Došlo je do greške prilikom dohvata podataka rezervacija.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Greška prilikom dohvata podataka rezervacija: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Greška'),
            content: const Text(
                'Došlo je do greške prilikom dohvata podataka rezervacija.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Moje rezervacije',
          style: TextStyle(
            color: Colors.black, // Crna boja teksta
            fontWeight: FontWeight.bold, // Boldiranje teksta
          ),
        ),
        backgroundColor: Colors.white, // Boja pozadine trake aplikacije
        iconTheme: const IconThemeData(color: Colors.black), // Boja ikona u traci aplikacije
        elevation: 0, // Uklanja sjenu ispod trake aplikacije
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: mojeRezervacije.isEmpty
              ? const Center(
                  child: Text('Nemate rezervacija.'),
                )
              : Column(
                  children: mojeRezervacije.map((rezervacija) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Datum rezervacije: ${rezervacija.datumRezervacije}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold, // Boldiranje teksta
                                  ),
                                ),
                                const Spacer(),
                                Checkbox(
                                  value: !rezervacija.otkazana,
                                  onChanged: (newValue) {
                                    setState(() {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Potvrda otkazivanja rezervacije'),
                                            content: Text('Da li ste sigurni da želite otkazati rezervaciju?'),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    rezervacija.otkazana = !newValue!;
                                                    // Ovdje možete dodati logiku za slanje zahtjeva za otkazivanje rezervacije
                                                  });
                                                },
                                                child: Text('Da'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Ne'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Cijena: ${rezervacija.cijena}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, // Boldiranje teksta
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Status: ${rezervacija.otkazana ? 'Otkazana' : 'Aktivna'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, // Boldiranje teksta
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }
}
