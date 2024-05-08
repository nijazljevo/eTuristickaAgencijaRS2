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
      final List<dynamic>? fetchedData =
          await APIService.get('Hoteli', null);
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
        title: Text(
          'Hoteli',
          style: TextStyle(
            color: Colors.black, // Crna boja teksta
            fontWeight: FontWeight.bold, // Boldiranje teksta
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16.0),
        children: [
          _buildDataListView(),
        ],
      ),
    );
  }


 Widget _buildDataListView() {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.only(left: 16, right: 16), // Pomak udesno
      child: DataTable(
        columnSpacing: 10, // Postavljanje razmaka između stupaca
        dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
        columns: const [
          DataColumn(
            label: Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0), // Padding sa lijeve i desne strane
                child: Text(
                  'Naziv',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black, // Crna boja teksta
                    fontWeight: FontWeight.bold, // Boldiranje teksta
                  ),
                ),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0), // Padding sa lijeve i desne strane
                child: Text(
                  'Broj zvjezdica',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black, // Crna boja teksta
                    fontWeight: FontWeight.bold, // Boldiranje teksta
                  ),
                ),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0), // Padding sa lijeve i desne strane
                child: Text(
                  'Slika',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black, // Crna boja teksta
                    fontWeight: FontWeight.bold, // Boldiranje teksta
                  ),
                ),
              ),
            ),
          ),
        ],
        rows: hotels.map((Hotel e) {
          return DataRow(cells: [
            
            DataCell(Text(e.naziv ?? "")),
            DataCell(Text(e.brojZvjezdica?.toString() ?? "")),
            DataCell(e.slika != ""
                ? Container(
                    width: 100,
                    height: 100,
                    color: Colors.white,
                    child: imageFromBase64String(e.slika!),
                  )
                : const Text("")),
          ]);
        }).toList(),
      ),
    ),
  );
}


}