import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/hotel.dart';
import '../models/korisnik.dart';
import '../models/rezervacija.dart';
import '../models/search_result.dart';
import '../providers/hotel_provider.dart';
import '../providers/korisnik_provider.dart';
import '../providers/rezervacija_provider.dart';
import '../widgets/master_screen.dart';

class ReservationScreen extends StatefulWidget {
  final Rezervacija? rezervacija;

  ReservationScreen({Key? key, this.rezervacija}) : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late KorisnikProvider _korisnikProvider;
  late RezervacijaProvider _rezervacijaProvider;
  late HotelProvider _hotelProvider;
  SearchResult<Korisnik>? korisnikResult;
  SearchResult<Hotel>? hotelResult;
  bool isLoading = true;
  DateTime? selectedDate;
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'cijena': widget.rezervacija?.cijena.toString(),
      'hotelId': widget.rezervacija?.hotelId?.toString(),
      'korisnikId': widget.rezervacija?.korisnikId?.toString(),
      'datumRezervacije': widget.rezervacija?.datumRezervacije ?? DateTime.now(),
      'otkazana': widget.rezervacija?.otkazana ?? false,
    };

    _korisnikProvider = context.read<KorisnikProvider>();
    _hotelProvider = context.read<HotelProvider>();
    _rezervacijaProvider = context.read<RezervacijaProvider>();
    if (widget.rezervacija != null) {
      selectedDate = widget.rezervacija!.datumRezervacije;
    } else {
      selectedDate = DateTime.now();
    }

    initForm();
  }

  Future<void> initForm() async {
    korisnikResult = await _korisnikProvider.get();
    hotelResult = await _hotelProvider.get();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Column(
        children: [
          isLoading ? Container() : _buildForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      Map<String, dynamic> request =
                          Map<String, dynamic>.from(_formKey.currentState!.value);

                      // Pretvori datum u ISO8601 format
                      request['datumRezervacije'] = (request['datumRezervacije'] as DateTime).toIso8601String();

                      try {
                        if (widget.rezervacija == null) {
                          await _rezervacijaProvider.insert(request);
                          _showSuccessDialog(context, 'Zapis uspješno dodan.');
                        } else {
                          await _rezervacijaProvider.update(widget.rezervacija!.id!, request);
                          _showSuccessDialog(context, 'Zapis uspješno ažuriran.');
                        }
                      } on Exception catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Greška"),
                            content: Text(e.toString()),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              )
                            ],
                          ),
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Validacijska Greška"),
                          content: Text("Molimo vas da popunite sva obavezna polja."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  child: Text("Sačuvaj"),
                ),
              )
            ],
          )
        ],
      ),
      title: this.widget.rezervacija?.cijena.toString() ?? "Detalji Rezervacije",
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text("Uspjeh"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _formKey.currentState?.reset(); 
          },
          child: Text("OK"),
        )
      ],
    ),
  );
}


  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: FormBuilderTextField(
                  decoration: InputDecoration(
                    labelText: "Cijena",
                    errorText: _formKey.currentState?.fields['cijena']?.errorText,
                  ),
                  name: "cijena",
                  validator: (value) {
  if (value == null || value.isEmpty) {
    return "Polje je obavezno.";
  }
  if (int.tryParse(value) == null) {
    return "Unesite samo brojeve.";
  }
  return null;
},

                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: FormBuilderDropdown<String>(
                  name: 'hotelId',
                  decoration: InputDecoration(
                    labelText: 'Hotel',
                    errorText: _formKey.currentState?.fields['hotelId']?.errorText,
                    suffix: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState!.fields['hotelId']?.reset();
                      },
                    ),
                    hintText: 'Odaberi Hotel',
                  ),
                  items: hotelResult?.result
                          .map((item) => DropdownMenuItem(
                                alignment: AlignmentDirectional.center,
                                value: item.id!.toString(),
                                child: Text(item.naziv ?? ""),
                              ))
                          .toList() ??
                      [],
                  validator: (value) {
  if (value == null || value.isEmpty) {
    return "Polje je obavezno.";
  }
  return null;
},

                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: FormBuilderDropdown<String>(
                  name: 'korisnikId',
                  decoration: InputDecoration(
                    labelText: 'Korisnik',
                    errorText: _formKey.currentState?.fields['korisnikId']?.errorText,
                    suffix: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState!.fields['korisnikId']?.reset();
                      },
                    ),
                    hintText: 'Odaberi Korisnika',
                  ),
                  items: korisnikResult?.result
                          .map((item) => DropdownMenuItem(
                                alignment: AlignmentDirectional.center,
                                value: item.id!.toString(),
                                child: Text('${item.ime ?? ""} ${item.prezime ?? ""}'),
                              ))
                          .toList() ??
                      [],
                  validator: (value) {
  if (value == null || value.isEmpty) {
    return "Polje je obavezno.";
  }
  return null;
},

                ),
              ),
              SizedBox(
                width: 10,
              ),
              
            ],
          ),
         FormBuilderDateTimePicker(
  name: 'datumRezervacije',
  decoration: InputDecoration(labelText: 'Datum Rezervacije'),
  validator: (value) {
  if (value == null) {
    return 'Polje "Datum Rezervacije" je obavezno.';
  }
  return null;
},

  inputType: InputType.date,
  initialDate: selectedDate,
  firstDate: DateTime.now(),
  lastDate: DateTime.now().add(Duration(days: 365)), // Možete prilagoditi ovo prema potrebama
),

           FormBuilderCheckbox(
            name: 'otkazana',
            initialValue: false,
            title: Text('Otkazana'),
          ),
        ],
      ),
    );
  }
}
