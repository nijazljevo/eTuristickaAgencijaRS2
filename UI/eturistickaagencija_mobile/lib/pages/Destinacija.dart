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
      final List<dynamic>? fetchedData =
          await APIService.get('Destinacije', null);
      if (fetchedData != null) {
        final List<Destinacija> fetchedDestinacije =
            fetchedData.map((json) => Destinacija.fromJson(json)).toList();
        setState(() {
          destinacije = fetchedDestinacije;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Greška'),
              content: const Text(
                  'Došlo je do greške prilikom dohvata podataka destinacija.'),
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
            content: const Text(
                'Došlo je do greške prilikom dohvata podataka destinacija.'),
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
        title: const Text(
          'Destinacije',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: destinacije.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: destinacije.length,
                itemBuilder: (context, index) {
                  final destinacija = destinacije[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DestinacijaDetailsScreen(
                              destinacija: destinacija),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Theme.of(context).colorScheme.surface,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: destinacija.slika != null &&
                                    destinacija.slika != ''
                                ? Image(
                                    image: imageFromBase64String(
                                            destinacija.slika!)
                                        .image,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 120,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image_not_supported,
                                        size: 48, color: Colors.grey),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  destinacija.naziv ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
