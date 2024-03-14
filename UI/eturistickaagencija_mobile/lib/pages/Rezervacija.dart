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
  DateTime? selectedDate;
  bool isCancelled = false;
  double price = 0.0;

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
        _hotel = hotels.where((hotel) => hotel.gradId == widget.destinacija.gradId).toList();

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
  if (APIService.korisnikId != null && selectedDate != null) {
    // Check if the user already has a reservation for the selected date
    List<Rezervacije>? reservations = await APIService.getReservationsForUserAndDate(
      APIService.korisnikId!,
      selectedDate!,
    );

    if (reservations != null) {
      bool alreadyReserved = false;
      for (Rezervacije reservation in reservations) {
        if (reservation.datumRezervacije.isAtSameMomentAs(selectedDate!)) {
          alreadyReserved = true;
          break;
        }
      }

      if (alreadyReserved) {
        // If reservation exists, show a message and return
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: SizedBox(
              height: 20,
              child: Center(child: Text("Već ste rezervirali za odabrani datum.")),
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
      datumRezervacije: selectedDate!,
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
              const Text('Datum rezervacije:'),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Text(
                  selectedDate != null
                      ? DateFormat('dd.MM.yyyy').format(selectedDate!)
                      : 'Odaberi datum',
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Otkazana rezervacija'),
                value: isCancelled,
                onChanged: (bool? newValue) {
                  setState(() {
                    isCancelled = newValue ?? false;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text('Cijena: $price'),
              const SizedBox(height: 16),
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
