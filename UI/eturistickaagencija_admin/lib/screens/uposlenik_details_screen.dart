// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:eturistickaagencija_admin/models/uposlenik.dart';
import 'package:eturistickaagencija_admin/providers/uposlenik_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../models/korisnik.dart';
import '../models/search_result.dart';
import '../providers/korisnik_provider.dart';
import '../widgets/master_screen.dart';

class UposlenikDetailsScreen extends StatefulWidget {
  final Uposlenik? uposlenik;

  const UposlenikDetailsScreen({Key? key, this.uposlenik}) : super(key: key);

  @override
  State<UposlenikDetailsScreen> createState() => _UposlenikDetailsScreenState();
}

class _UposlenikDetailsScreenState extends State<UposlenikDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late KorisnikProvider _korisnikProvider;
  late UposlenikProvider _uposlenikProvider;
  SearchResult<Korisnik>? korisnikResult;
  bool isLoading = true;
  DateTime? selectedDate;
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'korisnikId': widget.uposlenik?.korisnikId?.toString(),
      'datumRezervacije': widget.uposlenik?.datumZaposlenja ?? DateTime.now(),
      'aktivan': widget.uposlenik?.aktivan ?? false,
    };

    _korisnikProvider = context.read<KorisnikProvider>();
    _uposlenikProvider = context.read<UposlenikProvider>();
    if (widget.uposlenik != null) {
      selectedDate = widget.uposlenik!.datumZaposlenja;
    } else {
      selectedDate = DateTime.now();
    }

    initForm();
  }

  Future<void> initForm() async {
    korisnikResult = await _korisnikProvider.get();


    setState(() {
      isLoading = false;
    });
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
              await _uposlenikProvider.deleteUposlenik(widget.uposlenik!.id!);
              Navigator.of(context).pop();
              _showSuccessDialog(context, 'Zapis uspješno obrisan.');
            } on Exception catch (e) {
              print("Delete error: $e"); 
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
        title: Text(widget.uposlenik?.datumZaposlenja.toString() ?? 'Uposlenik',style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black) ),
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

                      request['datumZaposlenja'] = (request['datumZaposlenja'] as DateTime).toIso8601String();

                      try {
                        if (widget.uposlenik == null) {
                          await _uposlenikProvider.insert(request);
                          _showSuccessDialog(context, 'Zapis uspješno dodan.');
                        } else {
                          await _uposlenikProvider.update(widget.uposlenik!.id!, request);
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


  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
        
        
       Padding(padding: const EdgeInsets.only(left: 400,right:400),
        child:SizedBox(
              width: 550,
                child: FormBuilderDropdown<String>(
                  name: 'korisnikId',
                  decoration: InputDecoration(
                    labelText: 'Korisnik',
                    labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    errorText: _formKey.currentState?.fields['korisnikId']?.errorText,
                      border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(7.0),
  ),
  filled: true,
  fillColor: Colors.grey[200],
                    suffix: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState!.fields['korisnikId']?.reset();
                      },
                    ),
                    hintText: 'Odaberi Korisnika',
                  ),
                  items: korisnikResult?.result
                          .map((item) => DropdownMenuItem(
                                alignment: AlignmentDirectional.center,
                                value: item.id!.toString(),
                                child: Text('${item.ime ?? ""} ${item.prezime ?? ""}'),
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
    const SizedBox(height: 10,),
        
       Padding(padding: const EdgeInsets.only(left: 400,right:400),
        child:SizedBox(
              width: 550,
              child:FormBuilderDateTimePicker(
  name: 'datumZaposlenja',
  decoration: InputDecoration(labelText: 'Datum zaposlenja',
  labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
   border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(7.0),
  ),
  filled: true,
  fillColor: Colors.grey[200],),
  validator: (value) {
    if (value == null) {
      return 'Polje "Datum zaposlenja" je obavezno.';
    }
    return null;
  },
  inputType: InputType.date,
  initialDate: selectedDate != null && selectedDate!.isAfter(DateTime.now()) ? selectedDate! : DateTime.now(),
  firstDate: DateTime.now(),
  lastDate: DateTime.now().add(const Duration(days: 365)), 
),
),
),


Padding(padding: const EdgeInsets.only(left: 400,right:400),
          child: FormBuilderCheckbox(
            name: 'aktivan',
            initialValue: false,
            title: const Text('Aktivan'),
          ),
)
        ],
      ),
    );
  }
}
