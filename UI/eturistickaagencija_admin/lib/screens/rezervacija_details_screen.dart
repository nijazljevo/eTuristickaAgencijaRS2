import 'dart:convert';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/hotel.dart';
import '../models/korisnik.dart';
import '../models/rezervacija.dart';
import '../models/search_result.dart';
import '../providers/hotel_provider.dart';
import '../providers/korisnik_provider.dart';

class ReservationScreen extends StatefulWidget {
  final Rezervacija? rezervacija;
  ReservationScreen({Key? key, this.rezervacija}) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  double price = 0;
  DateTime? selectedDate;
  bool? isCancelled;
  late HotelProvider _hotelProvider;
  late KorisnikProvider _korisnikProvider;
  final _formKey = GlobalKey<FormBuilderState>();
  SearchResult<Hotel>? hotelResult;
  SearchResult<Korisnik>? korisnikResult;
  bool isLoading = true;
  late Rezervacija _reservation;
  bool _isEditingMode = false;
  String? selectedHotelId;
  String? selectedKorisnikId;

  @override
  void initState() {
    super.initState();

    if (widget.rezervacija != null) {
      _reservation = widget.rezervacija!;
      selectedDate = _reservation.datumRezervacije;
      price = _reservation.cijena!;
      isCancelled = _reservation.otkazana;
      _isEditingMode = true;
      selectedHotelId = _reservation.hotelId.toString();
      selectedKorisnikId = _reservation.korisnikId.toString();
    } else {
      selectedDate = DateTime.now();
      price = 0;
      isCancelled = false;
    }

    _hotelProvider = context.read<HotelProvider>();
    _korisnikProvider = context.read<KorisnikProvider>();

    initForm();
  }

  Future<void> initForm() async {
    hotelResult = await _hotelProvider.get();
    korisnikResult = await _korisnikProvider.get();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectHotel(BuildContext context) async {
    final selectedHotel = await showDialog<Hotel?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Odaberite Hotel'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                for (final hotel in hotelResult?.result ?? [])
                  ListTile(
                    title: Text(hotel.naziv ?? ''),
                    onTap: () => Navigator.of(context).pop(hotel),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedHotel != null) {
      setState(() {
        this.selectedHotelId = selectedHotel.id.toString();
      });
    }
  }

  Future<void> _selectKorisnik(BuildContext context) async {
    final selectedKorisnik = await showDialog<Korisnik?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Odaberite Korisnika'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                for (final korisnik in korisnikResult?.result ?? [])
                  ListTile(
                    title: Text(korisnik.ime ?? '' + ' ' + korisnik.prezime ?? ''),
                    onTap: () => Navigator.of(context).pop(korisnik),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedKorisnik != null) {
      setState(() {
        this.selectedKorisnikId = selectedKorisnik.id.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditingMode ? 'Uredi Rezervaciju' : 'Dodaj Rezervaciju'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FormBuilderTextField(
                name: 'cijena',
                decoration: InputDecoration(labelText: 'Cijena'),
                validator: FormBuilderValidators.required(context, errorText: 'Polje "Cijena" je obavezno.'),
                keyboardType: TextInputType.number,
                initialValue: price?.toString(),
                onChanged: (value) {
                  setState(() {
                    double? parsedPrice = double.tryParse(value ?? '0');
                    if (parsedPrice != null) {
                      setState(() {
                        price = parsedPrice;
                      });
                    }
                  });
                },
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: FormBuilderTextField(
                    name: 'datumRezervacije',
                    decoration: InputDecoration(labelText: 'Datum Rezervacije'),
                    controller: TextEditingController(
                      text: selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                          : '',
                    ),
                    validator: FormBuilderValidators.required(context, errorText: 'Polje "Datum Rezervacije" je obavezno.'),
                  ),
                ),
              ),
              DropdownButtonFormField<String>(
              //  name: 'hotel',
                decoration: InputDecoration(labelText: 'Hotel'),
                items: hotelResult?.result
                        .map((item) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: item.id!.toString(),
                              child: Text(item.naziv ?? ''),
                            ))
                        .toList() ??
                    [],
                value: selectedHotelId,
                onChanged: (newValue) {
                  setState(() {
                    selectedHotelId = newValue;
                  });
                },
                validator: FormBuilderValidators.required(context, errorText: 'Polje "Hotel" je obavezno.'),
              ),
              DropdownButtonFormField<String>(
              //  name: 'korisnik',
                decoration: InputDecoration(labelText: 'Korisnik'),
                items: korisnikResult?.result
                        .map((item) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: item.id!.toString(),
                              child: Text(item.ime! + ' ' + item.prezime!),
                            ))
                        .toList() ??
                    [],
                value: selectedKorisnikId,
                onChanged: (newValue) {
                  setState(() {
                    selectedKorisnikId = newValue;
                  });
                },
                validator: FormBuilderValidators.required(context, errorText: 'Polje "Korisnik" je obavezno.'),
              ),
              Row(
                children: [
                  Text('Otkazana: '),
                  Checkbox(
                    value: isCancelled ?? false,
                    onChanged: (value) {
                      setState(() {
                        isCancelled = value;
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    if (widget.rezervacija != null) {
                      // Ažuriraj postojeću rezervaciju
                      await updateReservation(_reservation);
                    } else {
                      // Dodaj novu rezervaciju
                      await addReservation(
                        price.toInt(),
                        selectedDate!,
                        isCancelled!,
                        int.parse(selectedHotelId ?? '0'),
                        int.parse(selectedKorisnikId ?? '0'),
                      );
                    }
                  }
                },
                child: Text('Sačuvaj'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addReservation(int price, DateTime reservationDate, bool isCancelled, int hotelId, int korisnikId) async {
    final url = Uri.parse('http://localhost:7073/Rezervacija');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'cijena': price,
          'hotelId': hotelId,
          'otkazana': isCancelled,
          'datumRezervacije': reservationDate.toIso8601String(),
          'korisnikId': korisnikId,
        }),
      );

      if (response.statusCode == 200) {
        // Rezervacija uspješno dodana
        print('Rezervacija je uspješno dodana u bazi.');
      } else {
        // Greška prilikom dodavanja rezervacije
        print('Došlo je do greške prilikom dodavanja rezervacije u bazu.');
      }
    } catch (e) {
      // Greška u komunikaciji s API-jem
      print('Došlo je do greške u komunikaciji s API-jem: $e');
    }
  }

  Future<void> updateReservation(Rezervacija reservation) async {
    final url = Uri.parse('http://localhost:7073/Rezervacija/${reservation.id}');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': reservation.id,
          'cijena': price,
          'hotelId': int.tryParse(selectedHotelId ?? '0') ?? 0,
          'otkazana': isCancelled ?? false,
          'datumRezervacije': selectedDate?.toIso8601String(),
          'korisnikId': int.tryParse(selectedKorisnikId ?? '0') ?? 0,
        }),
      );

      print('HTTP PUT Request: ${url.toString()}');
      print('Request Body: ${jsonEncode({
        'id': reservation.id,
        'cijena': price,
        'hotelId': int.tryParse(selectedHotelId ?? '0') ?? 0,
        'otkazana': isCancelled ?? false,
        'datumRezervacije': selectedDate?.toIso8601String(),
        'korisnikId': int.tryParse(selectedKorisnikId ?? '0') ?? 0,
      })}');

      print('HTTP Response Status Code: ${response.statusCode}');
      print('HTTP Response Body: ${response.body}');
      
      // ...
    } catch (e) {
      // Greška u komunikaciji s API-jem
      print('Došlo je do greške u komunikaciji s API-jem: $e');
    }
  }
}
