import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../models/grad.dart';
import '../models/hotel.dart';
import '../models/search_result.dart';
import '../providers/grad.dart';
import '../providers/hotel_provider.dart';
import '../widgets/master_screen.dart';

class HotelDetailsScreen extends StatefulWidget {
  final Hotel? hotel;

  const HotelDetailsScreen({Key? key, this.hotel}) : super(key: key);

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late GradProvider _gradProvider;
  late HotelProvider _hotelProvider;
  Set<String> _existingNames = {};
  SearchResult<Grad>? gradResult;
  bool isLoading = true;
  Uint8List? _imageBytes;
  String? _imageName;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'naziv': widget.hotel?.naziv,
      'brojZvjezdica': widget.hotel?.brojZvjezdica?.toString(),
      'gradId': widget.hotel?.gradId?.toString(),
      'slika': widget.hotel?.slika ?? ''
    };

    _gradProvider = context.read<GradProvider>();
    _hotelProvider = context.read<HotelProvider>();

    initForm();
  }

  Future<void> initForm() async {
    gradResult = await _gradProvider.get();
    print(gradResult);

    setState(() {
      isLoading = false;
    });
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

  void _showDeleteConfirmationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Potvrdite brisanje"),
        content:
            const Text("Jeste li sigurni da želite obrisati ovaj kontinent?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await _hotelProvider.deleteHotel(widget.hotel!.id!);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // ignore: use_build_context_synchronously
                _showSuccessDialog(context, 'Zapis uspješno obrisan.');
              } on Exception catch (e) {
                // ignore: avoid_print
                print("Delete error: $e"); // Dodajte ispis u konzolu
                // ignore: use_build_context_synchronously
                _showErrorDialog(context, 'Greška prilikom brisanja: $e');
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Greška"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.hotel?.naziv ?? 'Hotel',
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        Map<String, dynamic> request =
                            Map<String, dynamic>.from(
                                _formKey.currentState!.value);

                        try {
                          final naziv = request['naziv'] as String;
                          if (widget.hotel == null ||
                              widget.hotel!.naziv != naziv) {
                            final isDuplicate =
                                await _hotelProvider.checkDuplicate(naziv);
                            if (isDuplicate) {
                              _showErrorDialog(context, 'Zapis već postoji.');
                              return;
                            }
                          }

                          // Prepare fields for multipart
                          Map<String, String> fields = {
                            'Naziv': request['naziv'] ?? '',
                            'BrojZvjezdica': request['brojZvjezdica'] ?? '',
                            'GradId': request['gradId'] ?? '',
                          };

                          Map<String, Uint8List>? fileBytes;
                          Map<String, String>? fileNames;
                          if (_imageBytes != null) {
                            fileBytes = {'Slika': _imageBytes!};
                            // If you want to keep the original file name, you can store it when picking the file
                            // For now, we'll use a default name
                            fileNames = {'Slika': _imageName!};
                          }

                          if (widget.hotel == null) {
                            await _hotelProvider.insertMultipart(
                              fields: fields,
                              fileBytes: fileBytes,
                              fileNames: fileNames,
                            );
                            _showSuccessDialog(
                                context, 'Zapis uspješno dodan.');
                          } else {
                            fields.addEntries({
                              "Id": "${widget.hotel!.id!}",
                            }.entries);
                            await _hotelProvider.updateMultipart(
                              fields: fields,
                              fileBytes: fileBytes,
                              fileNames: fileNames,
                            );
                            _showSuccessDialog(
                                context, 'Zapis uspješno ažuriran.');
                          }
                        } on FormatException catch (_) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Greška"),
                              content: const Text(
                                  "Neispravan format podataka slike."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                )
                              ],
                            ),
                          );
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
                            title: const Text("Greška pri validaciji"),
                            content: const Text(
                                "Molimo vas da popunite sva obavezna polja."),
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
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      child: Text(
                        "Sačuvaj",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
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
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 550,
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Naziv",
                  labelStyle: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                  errorText: _formKey.currentState?.fields['naziv']?.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: "Unesite naziv",
                ),
                name: "naziv",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Polje je obavezno.";
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 550,
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Broj zvjezdica",
                  labelStyle: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                  errorText:
                      _formKey.currentState?.fields['brojZvjezdica']?.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: "Unesite broj zvjezdica",
                ),
                name: "brojZvjezdica",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Polje je obavezno.";
                  }
                  int? intValue = int.tryParse(value);
                  if (intValue == null || !isValidStarRating(intValue)) {
                    return "Unesite validan broj zvjezdica (1, 2, 3, 4 ili 5).";
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 550,
              child: FormBuilderDropdown<String>(
                name: 'gradId',
                decoration: InputDecoration(
                  labelText: 'Grad',
                  labelStyle: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
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
                  hintText: 'Izaberite Grad',
                ),
                items: gradResult?.result
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
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 550,
              child: FormBuilderField(
                name: 'slika',
                builder: (field) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      label: const Text('Odaberite sliku'),
                      labelStyle: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                      errorText: field.errorText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.photo),
                          title: _imageBytes != null
                              ? const Text("Slika je odabrana")
                              : const Text("Nijedna slika nije odabrana"),
                          trailing: const Icon(Icons.file_upload),
                          onTap: () async {
                            var result = await FilePicker.platform.pickFiles(
                                withData: true, type: FileType.image);
                            if (result != null && result.files.isNotEmpty) {
                              var fileBytes = result.files.single.bytes;
                              if (fileBytes != null) {
                                setState(() {
                                  _imageBytes = fileBytes;
                                  _imageName = result.files.single.name;
                                  _base64Image = base64Encode(fileBytes);
                                });
                                field.didChange(
                                    fileBytes); // update form field value
                              }
                            }
                          },
                        ),
                        if (_imageBytes != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Image.memory(
                              _imageBytes!,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        if ((_imageBytes == null &&
                            _initialValue['slika'].isNotEmpty))
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Image.memory(
                              base64Decode(_initialValue['slika']),
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                  );
                },
                initialValue: _initialValue['slika'],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isValidStarRating(int value) {
    return [1, 2, 3, 4, 5].contains(value);
  }
}
