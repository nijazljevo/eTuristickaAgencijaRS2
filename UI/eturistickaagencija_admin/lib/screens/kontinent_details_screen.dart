// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/kontinent.dart';
import '../providers/kontinent_provider.dart';
import '../widgets/master_screen.dart';
import 'kontinent_list_screen.dart'; // Import ekrana s popisom kontinenata

class KontinentDetailsScreen extends StatefulWidget {
  final Kontinent? kontinent;

  const KontinentDetailsScreen({Key? key, this.kontinent}) : super(key: key);

  @override
  State<KontinentDetailsScreen> createState() => _KontinentDetailsScreenState();
}

class _KontinentDetailsScreenState extends State<KontinentDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late KontinentProvider _kontinentProvider;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _kontinentProvider = context.read<KontinentProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initForm();
  }

  Future<void> initForm() async {
    if (widget.kontinent != null) {
      _formKey.currentState?.reset();
      _formKey.currentState?.fields['naziv']?.didChange(widget.kontinent!.naziv);
    } else {
      _formKey.currentState?.reset();
      _formKey.currentState?.fields['naziv']?.didChange('');
    }

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
              await _kontinentProvider.deleteKontinent(widget.kontinent!.id!);
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
        title: Text(
          widget.kontinent?.naziv ?? 'Kontinent',
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
                        try {
                          final naziv = _formKey.currentState?.value['naziv'] as String;
                          if (widget.kontinent == null || widget.kontinent!.naziv != naziv) {
                            final isDuplicate = await _kontinentProvider.checkDuplicate(naziv);
                            if (isDuplicate) {
                              _showErrorDialog(context, 'Zapis već postoji.');
                              return;
                            }
                          }
                          if (widget.kontinent == null) {
                            await _kontinentProvider.insert(_formKey.currentState?.value);
                            // ignore: use_build_context_synchronously
                            _showSuccessDialog(context, 'Zapis uspješno dodan.');
                          } else {
                            await _kontinentProvider.update(widget.kontinent!.id!, _formKey.currentState?.value);
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
      child: Column(
        children: [
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
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
                initialValue: widget.kontinent?.naziv ?? '',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
