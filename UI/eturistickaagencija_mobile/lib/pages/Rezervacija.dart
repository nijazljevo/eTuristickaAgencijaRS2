import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/destinacija.dart';
import '../model/hotel.dart';
import '../model/rezervacija.dart';
import '../services/APIService.dart';
import 'OnlinePaymentScreen.dart';

class ReservationPage extends StatefulWidget {
  final Destinacija destinacija;

  const ReservationPage({
    Key? key,
    required this.destinacija,
  }) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  List<Hotel> _hotel = [];
  Hotel? selectedHotel;
  late int _selectedHotelId;
  DateTime? checkIn;
  DateTime? checkOut;
  int brojOsoba = 1;
  bool isCancelled = false;
  double price = 0.0;
  TextEditingController tipSobeController = TextEditingController();
  String selectedTipSobe = "";

  @override
  void initState() {
    super.initState();
    _selectedHotelId = -1;
    fetchHoteliForDestinacija();
    calculatePrice();
  }

  Future<void> fetchHoteliForDestinacija() async {
    final List<Hotel>? hotels = await APIService.getHoteli();
    if (hotels != null) {
      setState(() {
        _hotel = hotels
            .where((hotel) => hotel.gradId == widget.destinacija.gradId)
            .toList();

        if (!_hotel.any((hotel) => hotel.id == _selectedHotelId)) {
          _selectedHotelId = (_hotel.isNotEmpty ? _hotel.first.id : -1)!;
        }
      });
    }
  }

  void calculatePrice() {
    setState(() {
      price = (290 * widget.destinacija.id!).toDouble() / 2;
    });
  }

  Future<void> submitReservation() async {
    if (APIService.korisnikId != null &&
        checkIn != null &&
        checkOut != null &&
        selectedTipSobe.isNotEmpty) {
      List<Rezervacije>? reservations =
          await APIService.getReservationsForUserAndDate(
        APIService.korisnikId!,
        DateTime.now(),
      );

      if (reservations != null) {
        bool alreadyReserved = false;
        for (Rezervacije reservation in reservations) {
          if (reservation.datumRezervacije.isAtSameMomentAs(DateTime.now())) {
            alreadyReserved = true;
            break;
          }
        }

        if (alreadyReserved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: SizedBox(
                height: 20,
                child: Center(
                    child: Text("Već ste rezervirali za odabrani datum.")),
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
      Rezervacije reservation = Rezervacije(
        hotelId: _selectedHotelId,
        korisnikId: APIService.korisnikId!,
        datumRezervacije: DateTime.now(),
        checkIn: checkIn!,
        checkOut: checkOut!,
        brojOsoba: brojOsoba,
        tipSobe: selectedTipSobe,
        otkazana: isCancelled,
        cijena: price,
      );

      final jsonData = reservation.toJson();
      final jsonString = jsonEncode(jsonData);
      print('JSON data: $jsonString');
      await APIService.post("Rezervacija", json.encode(jsonData));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: SizedBox(
            height: 20,
            child: Center(child: Text("Uspješno")),
          ),
          backgroundColor: Color.fromARGB(255, 9, 100, 13),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OnlinePaymentScreen(reservation: reservation),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(widget.destinacija.naziv!),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Odaberi Hotel:'),
              DropdownButton<Hotel>(
                value: selectedHotel,
                onChanged: (Hotel? newValue) {
                  setState(() {
                    selectedHotel = newValue;
                  });
                },
                items: _hotel.map((Hotel hotel) {
                  return DropdownMenuItem<Hotel>(
                    value: hotel,
                    child: Text(hotel.naziv ?? ""),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                'Korisnik: ${APIService.username}',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedCheckIn = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedCheckIn != null) {
                    setState(() {
                      checkIn = pickedCheckIn;
                    });

                    if (checkOut != null && checkOut!.isBefore(pickedCheckIn)) {
                      setState(() {
                        checkOut = null;
                      });
                    }
                  }
                },
                child: Text(checkIn != null
                    ? DateFormat('dd.MM.yyyy').format(checkIn!)
                    : 'Odaberi check-in datum'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedCheckOut = await showDatePicker(
                    context: context,
                    initialDate:
                        checkIn?.add(const Duration(days: 1)) ?? DateTime.now(),
                    firstDate:
                        checkIn?.add(const Duration(days: 1)) ?? DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedCheckOut != null) {
                    setState(() {
                      checkOut = pickedCheckOut;
                    });
                  }
                },
                child: Text(checkOut != null
                    ? DateFormat('dd.MM.yyyy').format(checkOut!)
                    : 'Odaberi check-out datum'),
              ),
              const SizedBox(height: 16),
              Text('Cijena: $price'),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                    labelText: 'Broj osoba', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    brojOsoba = int.tryParse(value) ?? 1;
                  });
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: DropdownMenu<String>(
                    controller: tipSobeController,
                    initialSelection: selectedTipSobe,
                    width: MediaQuery.of(context).size.width - 40,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry<String>(
                          value: "", label: "Odaberi tip sobe"),
                      DropdownMenuEntry<String>(
                          value: "Jednokrevetna", label: "Jednokrevetna"),
                      DropdownMenuEntry<String>(
                          value: "Dvokrevetna", label: "Dvokrevetna"),
                      DropdownMenuEntry<String>(
                          value: "Trokrevetna", label: "Trokrevetna"),
                    ],
                    label: const Text('Tip Sobe'),
                    trailingIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          selectedTipSobe = "";
                          tipSobeController.clear();
                        });
                      },
                    ),
                    onSelected: (value) {
                      setState(() {
                        selectedTipSobe = value ?? "";
                      });
                    }),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  submitReservation();
                },
                child: const Text('Potvrdi rezervaciju'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
