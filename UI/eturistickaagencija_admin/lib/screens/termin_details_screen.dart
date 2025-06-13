// ignore_for_file: unnecessary_string_interpolations, use_build_context_synchronously, avoid_print

import 'package:eturistickaagencija_admin/models/destinacija.dart';
import 'package:eturistickaagencija_admin/models/grad.dart';
import 'package:eturistickaagencija_admin/models/termin.dart';
import 'package:eturistickaagencija_admin/providers/destinacija_provider.dart';
import 'package:eturistickaagencija_admin/providers/grad.dart';
import 'package:eturistickaagencija_admin/providers/termin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/hotel.dart';
import '../models/search_result.dart';
import '../providers/hotel_provider.dart';
import '../widgets/master_screen.dart';

class TerminDetailsScreen extends StatefulWidget {
  final Termin? termin;

  TerminDetailsScreen({Key? key, this.termin}) : super(key: key);

  @override
  State<TerminDetailsScreen> createState() => _TerminDetailsScreenState();
}

class _TerminDetailsScreenState extends State<TerminDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late DestinacijaProvider _destinacijaProvider;
  late TerminProvider _terminProvider;
  late HotelProvider _hotelProvider;
  late GradProvider _gradProvider;
  SearchResult<Destinacija>? destinacijaResult;
  SearchResult<Hotel>? hotelResult;
  SearchResult<Grad>? gradResult;
  bool isLoading = true;
  DateTime? selectedDate;
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'cijena': widget.termin?.cijena.toString(),
      'hotelId': widget.termin?.hotelId?.toString(),
      'destinacijaId': widget.termin?.destinacijaId?.toString(),
      'gradId': widget.termin?.gradId?.toString(),
      'datumPolaska': widget.termin?.datumPolaska ?? DateTime.now(),
      'datumDolaska': widget.termin?.datumDolaska ?? DateTime.now(),
      'aktivanTermin': widget.termin?.aktivanTermin ?? false,
      'popust': widget.termin?.popust.toString(),
      'cijenaPopust': widget.termin?.cijenaPopust.toString(),
    };

    _destinacijaProvider = context.read<DestinacijaProvider>();
    _hotelProvider = context.read<HotelProvider>();
    _gradProvider = context.read<GradProvider>();
    _terminProvider = context.read<TerminProvider>();
    if (widget.termin != null) {
      selectedDate = widget.termin!.datumPolaska;
    } else {
      selectedDate = DateTime.now();
    }
    if (widget.termin != null) {
      selectedDate = widget.termin!.datumPolaska;
    } else {
      selectedDate = DateTime.now();
    }

    initForm();
  }

  Future<void> initForm() async {
    destinacijaResult = await _destinacijaProvider.get();
    hotelResult = await _hotelProvider.get();
    gradResult = await _gradProvider.get();
    setState(() {
      isLoading = false;
    });
  }
   void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text("Greška"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: const Text("OK"),
        )
      ],
    ),
  );
}
void _showDeleteConfirmationDialog(BuildContext context) async {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Potvrdite brisanje"),
      content: const Text("Jeste li sigurni da želite obrisati ovaj kontinent?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            try {
              await _terminProvider.deleteTermin(widget.termin!.id!);
              Navigator.of(context).pop();
              _showSuccessDialog(context, 'Zapis uspješno obrisan.');
            } on Exception catch (e) {
              print("Delete error: $e"); // Dodajte ispis u konzolu
              _showErrorDialog(context, 'Greška prilikom brisanja: $e');
            }
          },
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.termin?.cijena.toString() ?? 'Termin',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: MasterScreenWidget(
        child: Column(
          children: [
            isLoading ? Container() : _buildForm(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        Map<String, dynamic> request =
                            Map<String, dynamic>.from(_formKey.currentState!.value);

                        request['datumPolaska'] =
                            (request['datumPolaska'] as DateTime).toIso8601String();

                        request['datumDolaska'] =
                            (request['datumDolaska'] as DateTime).toIso8601String();

                        try {
                          if (widget.termin == null) {
                            await _terminProvider.insert(request);
                            _showSuccessDialog(context, 'Zapis uspješno dodan.');
                          } else {
                            await _terminProvider.update(widget.termin!.id!, request);
                            _showSuccessDialog(context, 'Zapis uspješno ažuriran.');
                          }
                        } on Exception catch (e) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Greška"),
                              content: Text(e.toString()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                )
                              ],
                            ),
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text("Validacijska Greška"),
                            content: const Text("Molimo vas da popunite sva obavezna polja."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK"),
                              )
                            ],
                          ),
                        );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        "Sačuvaj",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              Padding(
                  padding: const EdgeInsets.all(10),
                child: ElevatedButton(
  onPressed: () {
    _showDeleteConfirmationDialog(context);
  },
  child: const Padding(
    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.delete, color: Colors.red),
        SizedBox(width: 5),
        Text(
          "Obriši",
          style: TextStyle(fontSize: 16.0, color: Colors.red),
        ),
      ],
    ),
  ),
),

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Uspjeh"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _formKey.currentState?.reset();
            },
            child: const Text("OK"),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 400,right:400),
            child: SizedBox(
              width: 550,
              height: 40,
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Cijena",
                  labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  errorText: _formKey.currentState?.fields['cijena']?.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: "Unesite cijenu",
                ),
                name: "cijena",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Polje je obavezno.";
                  }
                    if (double.tryParse(value) == null) {
          return "Unesite samo brojeve ili decimalne vrijednosti.";
        }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 400,right:400),
            child: SizedBox(
              width: 550,
              height: 40,
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Popust",
                  labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  errorText: _formKey.currentState?.fields['popust']?.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: "Unesite popust",
                ),
                name: "popust",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Polje je obavezno.";
                  }
                   if (double.tryParse(value) == null) {
          return "Unesite samo brojeve ili decimalne vrijednosti.";
        }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 400,right:400),
            child: SizedBox(
              width: 550,
              height: 40,
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Cijena sa popustom",
                  labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  errorText: _formKey.currentState?.fields['cijenaPopust']?.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: "Unesite cijenu sa popustom",
                ),
                name: "cijenaPopust",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Polje je obavezno.";
                  }
                    if (double.tryParse(value) == null) {
          return "Unesite samo brojeve ili decimalne vrijednosti.";
        }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 400,right:400),
            child: SizedBox(
              width: 550,
              height: 52,
              child: FormBuilderDropdown<String>(
                name: 'hotelId',
                decoration: InputDecoration(
                  labelText: 'Hotel',
                  labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  errorText: _formKey.currentState?.fields['hotelId']?.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
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
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 400,right:400),
            child: SizedBox(
              width: 550,
              height: 52,
              child: FormBuilderDropdown<String>(
                name: 'destinacijaId',
                decoration: InputDecoration(
                  labelText: 'Destinacija',
                  labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  errorText: _formKey.currentState?.fields['destinacijaId']?.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffix: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _formKey.currentState!.fields['destinacijaId']?.reset();
                    },
                  ),
                  hintText: 'Odaberi destinaciju',
                ),
                items: destinacijaResult?.result
                        .map((item) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: item.id!.toString(),
                              child: Text('${item.naziv ?? ""}'),
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
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 400,right:400),
            child: SizedBox(
              width: 550,
              height: 52,
              child: FormBuilderDropdown<String>(
                name: 'gradId',
                decoration: InputDecoration(
                  labelText: 'Grad',
                  labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  errorText: _formKey.currentState?.fields['gradId']?.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffix: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _formKey.currentState!.fields['gradId']?.reset();
                    },
                  ),
                  hintText: 'Odaberi grad',
                ),
                items: gradResult?.result
                        .map((item) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: item.id!.toString(),
                              child: Text('${item.naziv ?? ""}'),
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
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 400,right:400),
            child: SizedBox(
              width: 550,
              height: 40,
              child: FormBuilderDateTimePicker(
                name: 'datumPolaska',
                decoration: InputDecoration(
                  labelText: 'Datum polaska',
                  labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Polje "Datum polaska" je obavezno.';
                  }
                  return null;
                },
                inputType: InputType.date,
                initialDate: selectedDate != null && selectedDate!.isAfter(DateTime.now()) ? selectedDate! : DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 400,right:400),
            child: SizedBox(
              width: 550,
              height: 40,
              child: FormBuilderDateTimePicker(
                name: 'datumDolaska',
                decoration: InputDecoration(
                  labelText: 'Datum dolaska',
                  labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Polje "Datum dolaska" je obavezno.';
                  }
                  return null;
                },
                inputType: InputType.date,
                initialDate: selectedDate != null && selectedDate!.isAfter(DateTime.now()) ? selectedDate! : DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.only(left: 400,right:400),
         child: FormBuilderCheckbox(
            name: 'aktivanTermin',
            initialValue: false,
            title: const Text('Aktivan'),
          ),
          ),
        ],
      ),
    );
  }
}
