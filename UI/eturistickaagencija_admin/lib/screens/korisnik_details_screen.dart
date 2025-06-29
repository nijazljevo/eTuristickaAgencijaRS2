// ignore_for_file: use_build_context_synchronously, avoid_print

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
              await _korisnikProvider.deleteKorisnik(widget.korisnik!.id!);
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
        widget.korisnik?.korisnikoIme ?? 'Korisnik',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    body: MasterScreenWidget(
      child: SingleChildScrollView(
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
                            await _korisnikProvider.update(widget.korisnik!.id!, request);
                            _showSuccessDialog(context, 'Zapis uspješno ažuriran.');
                          }
                        } on Exception catch (e) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Error"),
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
                            title: const Text("Validation Error"),
                            content: const Text("Molimo vas da ispravno popunite sva obavezna polja."),
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
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0), 
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
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 550,
              height:45,
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Ime",
                  labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  errorText: _formKey.currentState?.fields['ime']?.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: "Unesite ime",
                ),
                name: "ime",
                validator: validateSurname,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 550,
              height:45,
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Prezime",
                  labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  errorText: _formKey.currentState?.fields['prezime']?.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: "Unesite prezime",
                ),
                name: "prezime",
                validator: validateSurname,
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 550,
              height:45,
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  errorText: _formKey.currentState?.fields['email']?.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: "Unesite email",
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
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 550,
              height:45,
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Korisničko ime",
                  labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  errorText: _formKey.currentState?.fields['korisnikoIme']?.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: "Unesite korisničko ime",
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
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 550,
              height:45,
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  errorText: _formKey.currentState?.fields['password']?.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: "Unesite password",
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
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 550,
              height:45,
              child: FormBuilderTextField(
                decoration: InputDecoration(
                  labelText: "Password potvrda",
                  labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  errorText: _formKey.currentState?.fields['passwordPotvrda']?.errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: "Potvrdite password",
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
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child:SizedBox(
            width: 550,
            height:55,
            child: FormBuilderDropdown<String>(
              name: 'ulogaId',
              decoration: InputDecoration(
                labelText: 'Uloga',
                labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                errorText: _formKey.currentState?.fields['ulogaId']?.errorText,
                border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(7.0),
  ),
  filled: true,
  fillColor: Colors.grey[200],
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
            )
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10),
             child:SizedBox(
              width: 550,
              height:60,
            child: FormBuilderField(
              name: 'imageId',
              builder: ((field) {
                return InputDecorator(
                  decoration: InputDecoration(
                      labelText: 'Odaberite sliku',
                      labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      errorText: field.errorText,
                      border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(7.0),
  ),
  filled: true,
  fillColor: Colors.grey[200],),
                  child: ListTile(
                    leading: const Icon(Icons.photo),
                    title: const Text("Odaberite sliku"),
                    trailing: const Icon(Icons.file_upload),
                    onTap: getImage,
                  ),
                );
              }),
            ),
          ),
          )
        ],
      ),
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

  return null;  
}

bool isValidSurname(String value) {
  return RegExp(r'^[a-zA-Z]+$').hasMatch(value) && value.length <= 25;
}