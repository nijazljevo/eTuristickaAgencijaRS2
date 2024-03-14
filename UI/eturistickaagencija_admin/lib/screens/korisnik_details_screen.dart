import 'dart:convert';
import 'dart:io';
import 'package:eturistickaagencija_admin/providers/korisnik_provider.dart';
import 'package:eturistickaagencija_admin/providers/uloga_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../models/search_result.dart';
import '../models/uloga.dart';
import '../widgets/master_screen.dart';

class KorisnikDetailsScreen extends StatefulWidget {
  Korisnik? korisnik;
  KorisnikDetailsScreen({Key? key, this.korisnik}) : super(key: key);

  @override
  State<KorisnikDetailsScreen> createState() => _KorisnikDetailsScreenState();
}

class _KorisnikDetailsScreenState extends State<KorisnikDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late UlogaProvider _ulogaProvider;
  late KorisnikProvider _korisnikProvider;
  Set<String> _existingNames = {};
  SearchResult<Uloga>? ulogaResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'ime': widget.korisnik?.ime,
      'prezime': widget.korisnik?.prezime,
      'email': widget.korisnik?.email,
      'korisnikoIme': widget.korisnik?.korisnikoIme,
      'password': widget.korisnik?.password,
      'passwordPotvrda': widget.korisnik?.passwordPotvrda,
      'ulogaId': widget.korisnik?.ulogaId?.toString(),
    };

    _ulogaProvider = context.read<UlogaProvider>();
    _korisnikProvider = context.read<KorisnikProvider>();

    initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future initForm() async {
    ulogaResult = await _ulogaProvider.get();

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
                          Map<String, dynamic>.from(_formKey.currentState!.value);

                      request['slika'] = _base64Image;

                      try {
                        final korisnickoIme = _formKey.currentState?.value['korisnikoIme'] as String;
                       if (widget.korisnik == null || widget.korisnik!.korisnikoIme != korisnickoIme) {
                          final isDuplicate = await _korisnikProvider.checkDuplicate(korisnickoIme);
                          if (isDuplicate) {
                            _showErrorDialog(context, 'Zapis već postoji.');
                            return; 
                          }
                        }
                        if (widget.korisnik == null) {
                          await _korisnikProvider.insert(request);
                          _showSuccessDialog(context, 'Zapis uspješno dodan.');
                        } else {
                          await _korisnikProvider.update(
                              widget.korisnik!.id!, request);
                              _showSuccessDialog(context, 'Zapis uspješno ažuriran.');
                        }
                      } on Exception catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Error"),
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
                          title: Text("Validation Error"),
                          content: Text("Molimo vas da ispravno popunite sva obavezna polja."),
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
      title: this.widget.korisnik?.ime ?? "Korisnik details",
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
                  labelText: "Ime",
                ),
                name: "ime",
               validator: validateSurname,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Prezime",
                ),
                name: "prezime",
               validator: validateSurname,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Email",
                ),
                name: "email",
               validator: (value) {
  if (value == null || value.isEmpty) {
    return "Polje 'Email' je obavezno.";
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return "Unesite ispravan format email adrese.";
  }
  return null;
},

              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Korisničko ime",
                ),
                name: "korisnikoIme",
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
            Expanded(
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Password",
                ),
                name: "password",
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
            Expanded(
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Password potvrda",
                ),
                name: "passwordPotvrda",
               validator: (value) {
  if (value == null || value.isEmpty) {
    return "Polje 'Password potvrda' je obavezno.";
  }
  if (value != _formKey.currentState?.value['password']) {
    return "Password potvrda se ne podudara sa passwordom.";
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
                name: 'ulogaId',
                decoration: InputDecoration(
                  labelText: 'Uloga',
                  suffix: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _formKey.currentState!.fields['ulogaId']?.reset();
                    },
                  ),
                   hintText: 'Odaberite ulogu',
                ),
               
                items: ulogaResult?.result
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
                name: 'imageId',
                builder: ((field) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        label: Text('Odaberite sliku'),
                        errorText: field.errorText),
                    child: ListTile(
                      leading: Icon(Icons.photo),
                      title: Text("Odaberite sliku"),
                      trailing: Icon(Icons.file_upload),
                      onTap: getImage,
                    ),
                  );
                }),
              ),
            )
          ],
        )
      ]),
    );
  }


  File? _image;
  String? _base64Image;

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
    }
  }
}
String? validateSurname(String? value) {
  if (value == null || value.isEmpty) {
    return "Polje je obavezno.";
  }

  if (!isValidSurname(value)) {
    return "Ime i prezime može sadržavati samo slova i može imati najviše 25 karaktera.";
  }

  return null;  // Vraća null ako je sve u redu
}

bool isValidSurname(String value) {
  // Provjerava je li prezime sastavljeno samo od slova i ima najviše 25 karaktera
  return RegExp(r'^[a-zA-Z]+$').hasMatch(value) && value.length <= 25;
}