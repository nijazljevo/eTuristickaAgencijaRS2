import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/hotel.dart';
import '../services/APIService.dart';
import '../utils/util.dart';

class HotelListPage extends StatefulWidget {
  const HotelListPage({super.key});

  @override
  _HotelListPageState createState() => _HotelListPageState();
}

class _HotelListPageState extends State<HotelListPage> {
  List<Hotel> hotels = [];

  @override
  void initState() {
    super.initState();
    fetchHotelData();
  }

  Future<void> fetchHotelData() async {
    try {
      final List<dynamic>? fetchedData = await APIService.get('Hoteli', null);
      if (fetchedData != null) {
        final List<Hotel> fetchedHotel =
            fetchedData.map((json) => Hotel.fromJson(json)).toList();
        setState(() {
          hotels = fetchedHotel;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Greška'),
              content: const Text(
                  'Došlo je do greške prilikom dohvata podataka hotela.'),
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
      print('Greška prilikom dohvata podataka hotela: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Greška'),
            content: const Text(
                'Došlo je do greške prilikom dohvata podataka hotela.'),
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
          'Hoteli',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          final hotel = hotels[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: ExpansionTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      hotel.naziv ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      hotel.brojZvjezdica ?? 0,
                      (index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              children: [
                if (hotel.slika != null && hotel.slika!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: imageFromBase64String(hotel.slika!),
                      ),
                    ),
                  ),
                if (hotel.naziv != null && hotel.naziv!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      hotel.naziv!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
