import 'package:eturistickaagencija_admin/models/kontinent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/drzava.dart';
import '../models/search_result.dart';
import '../providers/drzava_provider.dart';
import '../providers/kontinent_provider.dart';
import '../widgets/master_screen.dart';

class DrzavaDetailsScreen extends StatefulWidget {
  Drzava? drzava;
  DrzavaDetailsScreen({Key? key, this.drzava}) : super(key: key);

  @override
  State<DrzavaDetailsScreen> createState() => _DrzavaDetailsScreenState();
}

class _DrzavaDetailsScreenState extends State<DrzavaDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late KontinentProvider _kontinentProvider;
  late DrzavaProvider _drzavaProvider;
  Set<String> _existingNames = {};
  SearchResult<Kontinent>? kontinentResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'naziv': widget.drzava?.naziv,
      'kontinentId': widget.drzava?.kontinentId?.toString(),
    };

    _kontinentProvider = context.read<KontinentProvider>();
    _drzavaProvider = context.read<DrzavaProvider>();

    initForm();
  }

  Future initForm() async {
    kontinentResult = await _kontinentProvider.get();
    // ignore: avoid_print
    print(kontinentResult);

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
      content: const Text("Jeste li sigurni da želite obrisati ovu drzavu?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            try {
              await _drzavaProvider.deleteDrzava(widget.drzava!.id!);
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
        title: Text(widget.drzava?.naziv ?? 'Drzava',style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black) ),
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
                        if (widget.drzava == null || widget.drzava!.naziv != naziv) {
                          final isDuplicate = await _drzavaProvider.checkDuplicate(naziv);
                          if (isDuplicate) {
                            // ignore: use_build_context_synchronously
                            _showErrorDialog(context, 'Zapis već postoji.');
                            return; 
                          }
                        }

                        if (widget.drzava == null) {
                          await _drzavaProvider.insert(request);
                          // ignore: use_build_context_synchronously
                          _showSuccessDialog(context, 'Zapis uspješno dodan.');
                        } else {
                          await _drzavaProvider.update(widget.drzava!.id!, request);
                          // ignore: use_build_context_synchronously
                          _showSuccessDialog(context, 'Zapis uspješno ažuriran.');
                        }
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
                  name: 'kontinentId',
                  decoration: InputDecoration(
                    labelText: 'Kontinent',
                    labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    errorText: _formKey.currentState?.fields['kontinentId']?.errorText,
                    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(7.0),
  ),
  filled: true,
  fillColor: Colors.grey[200],
                    suffix: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState!.fields['kontinentId']?.reset();
                      },
                    ),
                    hintText: 'Odaberi Kontinent',
                  ),
                  items: kontinentResult?.result
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
