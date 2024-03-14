import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/kontinent.dart';
import '../providers/kontinent_provider.dart';
import '../widgets/master_screen.dart';

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
  Set<String> _existingNames = {};

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
      title: widget.kontinent?.naziv ?? 'Kontinent details',
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
                            _showSuccessDialog(context, 'Zapis uspješno dodan.');
                          } else {
                            await _kontinentProvider.update(widget.kontinent!.id!, _formKey.currentState?.value);
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
                  child: Text('Sačuvaj'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          FormBuilderTextField(
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

            initialValue: widget.kontinent?.naziv ?? '',
          ),
        ],
      ),
    );
  }
}
