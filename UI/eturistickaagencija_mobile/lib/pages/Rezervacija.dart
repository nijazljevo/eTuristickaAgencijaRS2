import 'package:eturistickaagencija_mobile/components/custom_date_picker.dart';
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
  List<Hotel> _hoteli = [];
  Hotel? selectedHotel;
  late int _selectedHotelId;
  int brojOsoba = 1;
  bool isCancelled = false;
  double price = 0.0;
  TextEditingController tipSobeController = TextEditingController();
  TextEditingController checkInController = TextEditingController();
  TextEditingController checkOutController = TextEditingController();
  String selectedTipSobe = "";
  late bool _isLoading;

  @override
  void initState() {
    _isLoading = true;
    checkInController.text = DateFormat("dd. MM. yyyy.")
        .format(DateTime.now().add(const Duration(days: 1)));
    checkOutController.text = DateFormat("dd. MM. yyyy.")
        .format(DateTime.now().add(const Duration(days: 1)));
    _selectedHotelId = -1;
    super.initState();
    fetchHoteliForDestinacija();
    calculatePrice();
  }

  Future<void> fetchHoteliForDestinacija() async {
    final List<Hotel>? hotels = await APIService.getHoteli();
    if (hotels != null) {
      setState(() {
        _hoteli = hotels
            .where((hotel) => hotel.gradId == widget.destinacija.gradId)
            .toList();

        if (!_hoteli.any((hotel) => hotel.id == _selectedHotelId)) {
          _selectedHotelId = (_hoteli.isNotEmpty ? _hoteli.first.id : -1)!;
        }
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void calculatePrice() {
    setState(() {
      price = (290 * widget.destinacija.id!).toDouble() / 2;
    });
  }

  Future<void> submitReservation() async {
    if (APIService.korisnikId != null &&
        _selectedHotelId != -1 &&
        checkInController.text.isNotEmpty &&
        checkOutController.text.isNotEmpty &&
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

      DateTime checkIn =
          DateFormat("dd. MM. yyyy.").parse(checkInController.text);

      DateTime checkOut =
          DateFormat("dd. MM. yyyy.").parse(checkOutController.text);

      if (checkIn.isAfter(checkOut)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: SizedBox(
              height: 20,
              child: Center(child: Text("Datumi nisu ispravni!")),
            )));
        return;
      }

      Rezervacije reservation = Rezervacije(
        hotelId: _selectedHotelId,
        korisnikId: APIService.korisnikId!,
        datumRezervacije: DateTime.now(),
        checkIn: checkIn,
        checkOut: checkOut,
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: SizedBox(
            height: 20,
            child: Center(child: Text("Molimo vas, popunite sva polja.")),
          )));
      return;
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Odaberi Hotel:'),
                    DropdownMenu<int>(
                        initialSelection: _selectedHotelId,
                        width: MediaQuery.of(context).size.width - 32,
                        dropdownMenuEntries: _hoteli.map((Hotel hotel) {
                          return DropdownMenuEntry<int>(
                            value: hotel.id!,
                            label: hotel.naziv ?? "",
                          );
                        }).toList(),
                        label: const Text('Hotel'),
                        onSelected: (value) {
                          setState(() {
                            _selectedHotelId = value ?? -1;
                          });
                        }),
                    const SizedBox(height: 16),
                    Text(
                      'Korisnik: ${APIService.username}',
                    ),
                    const SizedBox(height: 16),
                    CustomDatePicker(
                      dateController: checkInController,
                      hint: "Check-in datum: ",
                    ),
                    const SizedBox(height: 16),
                    CustomDatePicker(
                      dateController: checkOutController,
                      hint: "Check-out datum: ",
                      validator: (value) {
                        var date = DateFormat("dd. MM. yyyy.")
                            .parseStrict(checkInController.text);
                        var date1 =
                            DateFormat("dd. MM. yyyy.").parseStrict(value);
                        if (date.isAfter(date1)) {
                          return "Check-out datum ne može biti prije check-in datuma";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text('Cijena: $price'),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                          labelText: 'Broj osoba',
                          border: OutlineInputBorder()),
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
                          width: MediaQuery.of(context).size.width - 32,
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
