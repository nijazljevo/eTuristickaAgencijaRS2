import 'dart:convert';
import 'dart:io';

import 'package:eturistickaagencija_admin/models/kontinent.dart';
import 'package:eturistickaagencija_admin/providers/grad.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/drzava.dart';
import '../models/grad.dart';
import '../models/search_result.dart';
import '../providers/drzava_provider.dart';
import '../providers/hotel_provider.dart';
import '../providers/kontinent_provider.dart';
import '../widgets/master_screen.dart';

class GradDetailsScreen extends StatefulWidget {
  Grad? grad;
  GradDetailsScreen({Key? key, this.grad}) : super(key: key);

  @override
  State<GradDetailsScreen> createState() => _GradDetailsScreenState();
}

class _GradDetailsScreenState extends State<GradDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late DrzavaProvider _drzavaProvider;
  late GradProvider _gradProvider;
  Set<String> _existingNames = {};
  SearchResult<Drzava>? drzavaResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'naziv': widget.grad?.naziv,
      'drzavaId': widget.grad?.drzavaId?.toString(),
    };

    _drzavaProvider = context.read<DrzavaProvider>();
    _gradProvider = context.read<GradProvider>();

    initForm();
  }

  Future initForm() async {
    drzavaResult = await _drzavaProvider.get();
    // ignore: avoid_print
    print(drzavaResult);

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
              await _gradProvider.deleteGrad(widget.grad!.id!);
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

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(widget.grad?.naziv ?? 'Grad ',style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black) ),
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

                      try {
                        final naziv = _formKey.currentState?.value['naziv'] as String;
                        if (widget.grad == null || widget.grad!.naziv != naziv) {
                          final isDuplicate = await _gradProvider.checkDuplicate(naziv);
                          if (isDuplicate) {
                            // ignore: use_build_context_synchronously
                            _showErrorDialog(context, 'Zapis već postoji.');
                            return; 
                          }
                        }
                        if (widget.grad == null) {
                          await _gradProvider.insert(request);
                          // ignore: use_build_context_synchronously
                          _showSuccessDialog(context, 'Zapis uspješno dodan.');
                        } else {
                          await _gradProvider.update(widget.grad!.id!, request);
                          // ignore: use_build_context_synchronously
                          _showSuccessDialog(context, 'Zapis uspješno ažuriran.');
                        }
                      } on Exception catch (e) {
                        showDialog(
                          // ignore: use_build_context_synchronously
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
         Padding(padding: const EdgeInsets.only(left: 10),
        child:SizedBox(
              width: 550,
              child: FormBuilderTextField(
               decoration: InputDecoration(
                
  labelText: "Naziv",
  labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
          const SizedBox(height: 10,),
          Padding(padding: const EdgeInsets.only(left: 10),
        child:SizedBox(
              width: 550,
                child: FormBuilderDropdown<String>(
                  name: 'drzavaId',
                  decoration: InputDecoration(
                    labelText: 'Država',
                    labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    errorText: _formKey.currentState?.fields['drzavaId']?.errorText,
                    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(7.0),
  ),
  filled: true,
  fillColor: Colors.grey[200],
                    suffix: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState!.fields['drzavaId']?.reset();
                      },
                    ),
                    hintText: 'Select Država',
                  ),
                  items: drzavaResult?.result
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
        ],
      ),
    );
  }
}
