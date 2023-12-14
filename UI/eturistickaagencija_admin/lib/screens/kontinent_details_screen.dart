import 'package:eturistickaagencija_admin/models/kontinent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

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
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      try {
                        if (widget.kontinent == null) {
                          await _kontinentProvider.insert(_formKey.currentState?.value);
                        } else {
                          await _kontinentProvider.update(widget.kontinent!.id!, _formKey.currentState?.value);
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
                              ),
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
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Sačuvaj'),
                ),
              ),
            ],
          ),
        ],
      ),
      title: widget.kontinent?.naziv ?? 'Kontinent details',
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
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(context, errorText: "Polje je obavezno."),
            ]),
            initialValue: widget.kontinent?.naziv ?? '',
          ),
        ],
      ),
    );
  }
}
