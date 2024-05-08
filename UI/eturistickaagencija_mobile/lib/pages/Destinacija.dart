import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/destinacija.dart';
import '../services/APIService.dart';
import '../utils/util.dart';
import 'DestinacijaDetails.dart';

class DestinacijaListPage extends StatefulWidget {
  const DestinacijaListPage({Key? key}) : super(key: key);

  @override
  _DestinacijaListPageState createState() => _DestinacijaListPageState();
}

class _DestinacijaListPageState extends State<DestinacijaListPage> {
  List<Destinacija> destinacije = [];

  @override
  void initState() {
    super.initState();
    fetchDestinacijaData();
  }

  Future<void> fetchDestinacijaData() async {
    try {
      final List<dynamic>? fetchedData = await APIService.get('Destinacije', null);
      if (fetchedData != null) {
        final List<Destinacija> fetchedDestinacije = fetchedData.map((json) => Destinacija.fromJson(json)).toList();
        setState(() {
          destinacije = fetchedDestinacije;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Greška'),
              content: const Text('Došlo je do greške prilikom dohvata podataka destinacija.'),
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
      print('Greška prilikom dohvata podataka destinacija: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Greška'),
            content: const Text('Došlo je do greške prilikom dohvata podataka destinacija.'),
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
        title: Text(
          'Destinacije',
          style: TextStyle(
            color: Colors.black, // Crna boja teksta
            fontWeight: FontWeight.bold, // Boldiranje teksta
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Naziv')),
            DataColumn(label: Text('Slika')),
          ],
          rows: destinacije
              .map(
                (destinacija) => DataRow(
                  cells: [
                    DataCell(
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DestinacijaDetailsScreen(destinacija: destinacija),
                            ),
                          );
                        },
                        child: Text(
                          destinacija.naziv ?? '',
                          style: TextStyle(
                            color: Colors.black, // Crna boja teksta
                            fontWeight: FontWeight.bold, // Boldiranje teksta
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      destinacija.slika != null && destinacija.slika != ''
                          ? SizedBox(
                              width: 100,
                              height: 100,
                              child: imageFromBase64String(destinacija.slika!),
                            )
                          : const Icon(Icons.image_not_supported),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
