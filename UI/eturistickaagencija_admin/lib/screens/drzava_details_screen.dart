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
    print(kontinentResult);

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

                      try {
                        final naziv = _formKey.currentState?.value['naziv'] as String;
                        if (widget.drzava == null || widget.drzava!.naziv != naziv) {
                          final isDuplicate = await _drzavaProvider.checkDuplicate(naziv);
                          if (isDuplicate) {
                            _showErrorDialog(context, 'Zapis već postoji.');
                            return; 
                          }
                        }

                        if (widget.drzava == null) {
                          await _drzavaProvider.insert(request);
                          _showSuccessDialog(context, 'Zapis uspješno dodan.');
                        } else {
                          await _drzavaProvider.update(widget.drzava!.id!, request);
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
      title: this.widget.drzava?.naziv ?? "Detalji Države",
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
                  name: 'kontinentId',
                  decoration: InputDecoration(
                    labelText: 'Kontinent',
                    errorText: _formKey.currentState?.fields['kontinentId']?.errorText,
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
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
