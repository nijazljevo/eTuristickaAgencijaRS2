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
    print(drzavaResult);

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
                        if (widget.grad == null || widget.grad!.naziv != naziv) {
                          final isDuplicate = await _gradProvider.checkDuplicate(naziv);
                          if (isDuplicate) {
                            _showErrorDialog(context, 'Zapis već postoji.');
                            return; 
                          }
                        }
                        if (widget.grad == null) {
                          await _gradProvider.insert(request);
                          _showSuccessDialog(context, 'Zapis uspješno dodan.');
                        } else {
                          await _gradProvider.update(widget.grad!.id!, request);
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
      title: this.widget.grad?.naziv ?? "Grad details",
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
                  name: 'drzavaId',
                  decoration: InputDecoration(
                    labelText: 'Država',
                    errorText: _formKey.currentState?.fields['drzavaId']?.errorText,
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
