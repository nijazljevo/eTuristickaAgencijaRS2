import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/grad.dart';
import '../models/hotel.dart';
import '../models/search_result.dart';
import '../providers/grad.dart';
import '../providers/hotel_provider.dart';
import '../widgets/master_screen.dart';

class HotelDetailsScreen extends StatefulWidget {
  final Hotel? hotel;

  HotelDetailsScreen({Key? key, this.hotel}) : super(key: key);

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late GradProvider _gradProvider;
  late HotelProvider _hotelProvider;

  SearchResult<Grad>? gradResult;
  bool isLoading = true;
  File? _image;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'naziv': widget.hotel?.naziv,
      'brojZvjezdica': widget.hotel?.brojZvjezdica?.toString(),
      'gradId': widget.hotel?.gradId?.toString(),
    };

    _gradProvider = context.read<GradProvider>();
    _hotelProvider = context.read<HotelProvider>();

    initForm();
  }

  Future<void> initForm() async {
    try {
      gradResult = await _gradProvider.get();
      print(gradResult);
    } catch (e) {
      print('Error fetching data: $e');
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
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      Map<String, dynamic> request = Map<String, dynamic>.from(_formKey.currentState!.value);

                      if (_base64Image != null) {
                        request['slika'] = _base64Image;
                      }

                      try {
                        if (widget.hotel == null) {
                          await _hotelProvider.insert(request);
                        } else {
                          await _hotelProvider.update(widget.hotel!.id!, request);
                        }
                      } catch (e) {
                        print('Exception: $e');
                        if (e is http.ClientException) {
                          print('ClientException: ${e.message}');
                        } else if (e is http.Response) {
                          print('Server response code: ${e.statusCode}');
                          print('Server response body: ${e.body}');
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Error"),
                            content: Text("Something bad happened. Please try again."),
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
      title: widget.hotel?.naziv ?? "Hotel details",
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Broj zvjezdica"),
                  name: "brojZvjezdica",
                  initialValue: _initialValue['brojZvjezdica'],
                  onChanged: (_) => _formKey.currentState?.fields['brojZvjezdica']?.didChange(true),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    (value) {
                      if (value == null || value.isEmpty) {
                        return "Polje je obavezno.";
                      }
                      int? intValue = int.tryParse(value);
                      if (intValue == null || !isValidStarRating(intValue)) {
                        return "Unesite validan broj zvjezdica (1, 2, 3, 4 ili 5).";
                      }
                      return null;
                    },
                  ]),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Naziv"),
                  name: "naziv",
                  initialValue: _initialValue['naziv'],
                  onChanged: (_) => _formKey.currentState?.fields['naziv']?.didChange(true),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: FormBuilderDropdown<String>(
                  name: 'gradId',
                  decoration: InputDecoration(
                    labelText: 'Grad',
                    suffix: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState!.fields['gradId']?.reset();
                      },
                    ),
                    hintText: 'Select Grad',
                  ),
                  items: gradResult?.result
                          ?.map((item) => DropdownMenuItem(
                                value: item.id?.toString(),
                                child: Text(item.naziv ?? ""),
                              ))
                          .toList() ??
                      [],
                  initialValue: _initialValue['gradId'],
                  onChanged: (_) => _formKey.currentState?.fields['gradId']?.didChange(true),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: FormBuilderField(
                  name: 'slika',
                  builder: (field) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        label: Text('Odaberite sliku'),
                        errorText: field.errorText,
                      ),
                      child: ListTile(
                        leading: Icon(Icons.photo),
                        title: Text("Select image"),
                        trailing: Icon(Icons.file_upload),
                        onTap: getImage,
                      ),
                    );
                  },
                  initialValue: _initialValue['slika'],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getImage() async {
    try {
      var result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null && result.files.isNotEmpty) {
        var filePath = result.files.single.path;
        if (filePath != null) {
          _image = File(filePath);
          _base64Image = base64Encode(_image!.readAsBytesSync());
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }

    print('Image selected successfully.');
  }

  bool isValidStarRating(int value) {
    return [1, 2, 3, 4, 5].contains(value);
  }
}
