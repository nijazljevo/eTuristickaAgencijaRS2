import 'package:eturistickaagencija_admin/providers/agencija_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/agencija.dart';
import '../widgets/master_screen.dart';

class AgencijaDetailsScreen extends StatefulWidget {
  final Agencija? agencija;

  const AgencijaDetailsScreen({Key? key, this.agencija}) : super(key: key);

  @override
  State<AgencijaDetailsScreen> createState() => _AgencijaDetailsScreenState();
}

class _AgencijaDetailsScreenState extends State<AgencijaDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late AgencijaProvider _agencijaProvider;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _agencijaProvider = context.read<AgencijaProvider>();
    initForm();
  }

  Future<void> initForm() async {
    if (widget.agencija != null) {
      _formKey.currentState?.reset();
      _formKey.currentState?.fields['adresa']?.didChange(widget.agencija!.adresa);
      _formKey.currentState?.fields['email']?.didChange(widget.agencija!.email);
      _formKey.currentState?.fields['telefon']?.didChange(widget.agencija!.telefon);
    } else {
      _formKey.currentState?.reset();
      _formKey.currentState?.fields['adresa']?.didChange('');
      _formKey.currentState?.fields['email']?.didChange('');
      _formKey.currentState?.fields['telefon']?.didChange('');
    }

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
      // ignore: sort_child_properties_last
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
                        if (widget.agencija != null) {
                          await _agencijaProvider.update(widget.agencija!.id!, _formKey.currentState?.value);
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
                    }
                  },
                  child: const Text('Sacuvaj'),
                ),
              )
            ],
          )
        ],
      ),
      title: widget.agencija?.email ?? 'Agencija details',
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: {
        'adresa': widget.agencija?.adresa ?? '',
        'email': widget.agencija?.email ?? '',
        'telefon': widget.agencija?.telefon ?? '',
      },
      child: Column(
        children: [
          FormBuilderTextField(
            decoration: const InputDecoration(
              labelText: "Adresa",
            ),
            name: "adresa",
            validator: (value) {
  if (value == null || value.isEmpty) {
    return "Polje je obavezno.";
  }
  return null;
},

          ),
          FormBuilderTextField(
            decoration: const InputDecoration(
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
         FormBuilderTextField(
  decoration: InputDecoration(
    labelText: "Telefon",
  ),
  name: "telefon",
 validator: (value) {
  if (value == null || value.isEmpty) {
    return "Polje je obavezno.";
  }
  // Regularni izraz za provjeru formata telefonskog broja
  RegExp regExp = RegExp(r'^[0-9\-\+\s\(\)]{9,15}$');
  if (!regExp.hasMatch(value)) {
    return "Neispravan format telefonskog broja.";
  }
  return null;
},

  keyboardType: TextInputType.phone,
),

        ],
      ),
    );
  }
}
