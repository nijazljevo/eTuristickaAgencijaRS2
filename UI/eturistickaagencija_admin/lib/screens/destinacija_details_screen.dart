import 'dart:convert';
import 'dart:typed_data';

import 'package:eturistickaagencija_admin/providers/grad.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../models/destinacija.dart';
import '../models/grad.dart';
import '../models/search_result.dart';
import '../providers/destinacija_provider.dart';
import '../widgets/master_screen.dart';

class DestinacijaDetailsScreen extends StatefulWidget {
  final Destinacija? destinacija;
  const DestinacijaDetailsScreen({Key? key, this.destinacija})
      : super(key: key);

  @override
  State<DestinacijaDetailsScreen> createState() =>
      _DestinacijaDetailsScreenState();
}

class _DestinacijaDetailsScreenState extends State<DestinacijaDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late GradProvider _gradProvider;
  late DestinacijaProvider _destinacijaProvider;
  SearchResult<Grad>? gradResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'naziv': widget.destinacija?.naziv,
      'gradId': widget.destinacija?.gradId?.toString(),
      'slika': widget.destinacija?.slika != null
          ? base64Decode(widget.destinacija!.slika!)
          : null,
    };

    _gradProvider = context.read<GradProvider>();
    _destinacijaProvider = context.read<DestinacijaProvider>();
    _imageBytes = _initialValue['slika'] as Uint8List?;

    initForm();
  }

  Future<void> initForm() async {
    gradResult = await _gradProvider.get();
    // ignore: avoid_print
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
                await _destinacijaProvider
                    .deleteDestinacija(widget.destinacija!.id!);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // ignore: use_build_context_synchronously
                _showSuccessDialog(context, 'Zapis uspješno obrisan.');
              } on Exception catch (e) {
                // ignore: avoid_print
                print("Delete error: $e");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destinacija?.naziv ?? 'Destinacija',
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
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
                            Map<String, dynamic>.from(
                                _formKey.currentState!.value);

                        if (_imageBytes != null && _imageBytes!.isNotEmpty) {
                          request['slika'] = base64Encode(_imageBytes!);
                        }

                        try {
                          final naziv =
                              _formKey.currentState?.value['naziv'] as String;
                          if (widget.destinacija == null ||
                              widget.destinacija!.naziv != naziv) {
                            final isDuplicate = await _destinacijaProvider
                                .checkDuplicate(naziv);
                            if (isDuplicate) {
                              // ignore: use_build_context_synchronously
                              _showErrorDialog(context, 'Zapis već postoji.');
                              return;
                            }
                          }
                          if (widget.destinacija == null) {
                            await _destinacijaProvider.insert(request);
                            // ignore: use_build_context_synchronously
                            _showSuccessDialog(
                                context, 'Zapis uspješno dodan.');
                          } else {
                            await _destinacijaProvider.update(
                                widget.destinacija!.id!, request);
                            // ignore: use_build_context_synchronously
                            _showSuccessDialog(
                                context, 'Zapis uspješno ažuriran.');
                          }
                        } on FormatException {
                          showDialog(
                            // ignore: use_build_context_synchronously
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
                            // ignore: use_build_context_synchronously
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
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      _showDeleteConfirmationDialog(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
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

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        onTap: getImage,
                      ),
                      if (_imageBytes != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Image.memory(
                            _imageBytes!,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Text(
                              'Greška pri učitavanju slike',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        )
                    ],
                  ),
                );
              },
              initialValue: _initialValue['slika'],
            ),
          ),
        )
      ]),
    );
  }

  Uint8List? _imageBytes;

  Future<void> getImage() async {
    var result = await FilePicker.platform
        .pickFiles(withData: true, type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      var fileBytes = result.files[0].bytes;
      if (fileBytes != null) {
        setState(() {
          _imageBytes = fileBytes;
        });
        _formKey.currentState?.fields['slika']?.didChange(fileBytes);
      }
    }
  }
}
