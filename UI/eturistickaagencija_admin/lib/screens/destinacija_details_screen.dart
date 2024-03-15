import 'dart:convert';
import 'dart:io';

import 'package:eturistickaagencija_admin/providers/grad.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/destinacija.dart';
import '../models/grad.dart';
import '../models/hotel.dart';
import '../models/search_result.dart';
import '../providers/destinacija_provider.dart';
import '../providers/hotel_provider.dart';
import '../widgets/master_screen.dart';

class DestinacijaDetailsScreen extends StatefulWidget {
  Destinacija? destinacija;
  DestinacijaDetailsScreen({Key? key, this.destinacija}) : super(key: key);

  @override
  State<DestinacijaDetailsScreen> createState() =>
      _DestinacijaDetailsScreenState();
}

class _DestinacijaDetailsScreenState extends State<DestinacijaDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late GradProvider _gradProvider;
  late DestinacijaProvider _destinacijaProvider;
  Set<String> _existingNames = {};
  SearchResult<Grad>? gradResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'naziv': widget.destinacija?.naziv,
      'gradId': widget.destinacija?.gradId?.toString(),
    };

    _gradProvider = context.read<GradProvider>();
    _destinacijaProvider = context.read<DestinacijaProvider>();

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
 void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Greška"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
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
                          Map<String, dynamic>.from(
                              _formKey.currentState!.value);

                      
                      if (_base64Image != null && _base64Image!.isNotEmpty) {
                        request['slika'] = _base64Image;
                      }

                      try {
                        final naziv = _formKey.currentState?.value['naziv'] as String;
                       if (widget.destinacija == null || widget.destinacija!.naziv != naziv) {
                          final isDuplicate = await _destinacijaProvider.checkDuplicate(naziv);
                          if (isDuplicate) {
                            _showErrorDialog(context, 'Zapis već postoji.');
                            return; 
                          }
                        } 
                        if (widget.destinacija == null) {
                          await _destinacijaProvider.insert(request);
                          _showSuccessDialog(context, 'Zapis uspješno dodan.');
                        } else {
                          await _destinacijaProvider.update(
                              widget.destinacija!.id!, request);
                              _showSuccessDialog(context, 'Zapis uspješno ažuriran.');
                        }
                      } on FormatException catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Greška"),
                            content: Text("Neispravan format podataka slike."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              )
                            ],
                          ),
                        );
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
                          title: Text("Greška pri validaciji"),
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
      title: this.widget.destinacija?.naziv ?? "Detalji destinacije",
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Naziv",
                  errorText: _formKey.currentState?.fields['naziv']?.errorText,
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
          ],
        ),
        Row(
          children: [
            Expanded(
              child: FormBuilderDropdown<String>(
                name: 'gradId',
                decoration: InputDecoration(
                  labelText: 'Grad',
                  errorText: _formKey.currentState?.fields['gradId']?.errorText,
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
            SizedBox(
              width: 10,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: FormBuilderField(
                name: 'slika',  
                builder: ((field) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      label: Text('Odaberite sliku'),
                      errorText: field.errorText,
                    ),
                    child: ListTile(
                      leading: Icon(Icons.photo),
                      title: Text("Odaberite sliku"),
                      trailing: Icon(Icons.file_upload),
                      onTap: getImage,
                    ),
                  );
                }),
              ),
            ),
          ],
        )
      ]),
    );
  }

  File? _image;
  String? _base64Image;

  Future<void> getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.isNotEmpty) {
      var filePath = result.files.single.path;
      if (filePath != null) {
        _image = File(filePath);
        _base64Image = base64Encode(_image!.readAsBytesSync());
      }
    }
  }
}
