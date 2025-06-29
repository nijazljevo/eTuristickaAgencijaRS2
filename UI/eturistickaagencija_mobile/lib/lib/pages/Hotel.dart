import 'dart:convert';
import 'package:eturistickaagencija_mobile/model/grad.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:eturistickaagencija_mobile/model/hotel.dart';
import 'package:eturistickaagencija_mobile/services/APIService.dart';
import 'package:eturistickaagencija_mobile/utils/util.dart';

class HotelListPage extends StatefulWidget {
  const HotelListPage({super.key});

  @override
  _HotelListPageState createState() => _HotelListPageState();
}

class _HotelListPageState extends State<HotelListPage> {
  List<Hotel> hotels = [];
  List<Grad> gradovi = [];
  final nazivController = TextEditingController();
  final brojZvjezdicaController = TextEditingController();
  final gradController = TextEditingController();
  int selectedGradId = 0;
  int selectedBrojZvjezdica = 0;
  late bool _isLoading;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    fetchScreenData();
  }

  Future<void> fetchScreenData() async {
    await fetchGradoviData();
    await fetchHotelData();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> fetchGradoviData() async {
    try {
      final List<dynamic>? fetchedData = await APIService.get('Gradovi', null);
      if (fetchedData != null) {
        final List<Grad> fetchedGradovi =
            fetchedData.map((json) => Grad.fromJson(json)).toList();
        setState(() {
          gradovi = fetchedGradovi;
        });
      }
    } catch (e) {
      print('Greška prilikom dohvata podataka gradova: $e');
    }
  }

  Future<void> fetchHotelData({Map<String, dynamic>? searchObj}) async {
    try {
      final List<dynamic>? fetchedData =
          await APIService.get('Hoteli', searchObj);
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
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            centerTitle: true,
            title: const Text(
              'Hoteli',
            )),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (hotels.isEmpty) {
      return Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              centerTitle: true,
              title: const Text(
                'Hoteli',
              )),
          body: const Center(
            child: Text('Nema podataka o hotelima.'),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
        title: const Text(
          'Hoteli',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  useSafeArea: true,
                  isScrollControlled: true, // This allows the modal to resize
                  builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                          // This padding pushes the content up when keyboard appears
                          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                        ),
                        child: Form(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize
                                  .min, // Important to keep it minimal
                              children: [
                                TextField(
                                  controller: nazivController,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: 'Naziv',
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        nazivController.clear();
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: DropdownMenu<int>(
                                      controller: gradController,
                                      initialSelection: selectedGradId,
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      dropdownMenuEntries: List.generate(
                                          gradovi.length,
                                          (index) => DropdownMenuEntry<int>(
                                              value: gradovi[index].id ?? 0,
                                              label: gradovi[index].naziv ??
                                                  'Bez naziva')),
                                      label: const Text('Grad'),
                                      trailingIcon: IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            selectedGradId = 0;
                                            gradController.clear();
                                          });
                                        },
                                      ),
                                      onSelected: (value) {
                                        setState(() {
                                          selectedGradId = value ?? 0;
                                        });
                                      }),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: DropdownMenu<int>(
                                      controller: brojZvjezdicaController,
                                      initialSelection: selectedBrojZvjezdica,
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      dropdownMenuEntries: const [
                                        DropdownMenuEntry<int>(
                                            value: 0, label: 'Odaberi'),
                                        DropdownMenuEntry<int>(
                                            value: 1, label: '1'),
                                        DropdownMenuEntry<int>(
                                            value: 2, label: '2'),
                                        DropdownMenuEntry<int>(
                                            value: 3, label: '3'),
                                        DropdownMenuEntry<int>(
                                            value: 4, label: '4'),
                                        DropdownMenuEntry<int>(
                                            value: 5, label: '5'),
                                      ],
                                      label: const Text('Broj zvjezdica'),
                                      trailingIcon: IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            selectedBrojZvjezdica = 0;
                                            brojZvjezdicaController.clear();
                                          });
                                        },
                                      ),
                                      onSelected: (value) {
                                        setState(() {
                                          selectedBrojZvjezdica = value ?? 0;
                                        });
                                      }),
                                ),
                                const SizedBox(height: 30),
                                ElevatedButton(
                                    onPressed: () {
                                      final naziv = nazivController.text;
                                      if (naziv.isEmpty &&
                                          selectedBrojZvjezdica == 0 &&
                                          selectedGradId == 0) {
                                        fetchHotelData();
                                      }
                                      final searchObject = {
                                        if (naziv.isNotEmpty) 'naziv': naziv,
                                        if (selectedBrojZvjezdica != 0)
                                          'brojZvjezdica':
                                              selectedBrojZvjezdica.toString(),
                                        if (selectedGradId != 0)
                                          'gradId': selectedGradId.toString(),
                                      };

                                      fetchHotelData(searchObj: searchObject);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Pretraži'))
                              ]),
                        ),
                      ));
            },
          )
        ],
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      "Grad: ${gradovi.where((e) => e.id == hotel.gradId).first.naziv}"),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: (hotel.slika != null && hotel.slika!.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: imageFromBase64String(hotel.slika!),
                          )
                        : Image.asset(
                            "assets/images/hotel-placeholder.jpg",
                            height: 120,
                            fit: BoxFit.cover,
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
