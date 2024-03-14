
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/korisnik.dart';
import '../models/search_result.dart';
import '../providers/korisnik_provider.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';
import 'korisnik_details_screen.dart';

class KorisnikScreen extends StatefulWidget {
  const KorisnikScreen({Key? key}) : super(key: key);

  @override
  State<KorisnikScreen> createState() => _KorisnikScreenState();
}

class _KorisnikScreenState extends State<KorisnikScreen> {
  late KorisnikProvider _korisnikProvider;
  SearchResult<Korisnik>? result;
  // ignore: unnecessary_new
  final TextEditingController _imeController = new TextEditingController();
  List<Korisnik> korisniks = [];
  Korisnik? selectedKorisnik;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _korisnikProvider = context.read<KorisnikProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Korisnik list"),
      // ignore: avoid_unnecessary_containers
      child: Container(
        child: Column(children: [_buildSearch(), _buildDataListView()]),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(labelText: "Ime"),
              controller: _imeController,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
         
          ElevatedButton(
              onPressed: () async {
                print("login proceed");

                var data = await _korisnikProvider.get(filter: {
                  'ime': _imeController.text,
                });

                setState(() {
                  result = data;
                });

              },
              child: const Text("Pretraga")),
          const SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>  KorisnikDetailsScreen(
               korisnik: null,
                    ),
                  ),
                );
              },
              child: const Text("Dodaj"))
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    return Expanded(
        child: SingleChildScrollView(
      child: DataTable(
          columns: const [
           
           
            DataColumn(
              label: Expanded(
                child: Text(
                  'Ime',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Prezime',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
           DataColumn(
              label: Expanded(
                child: Text(
                  'Email',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
             DataColumn(
              label: Expanded(
                child: Text(
                  'Korisnicko ime',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Slika',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            )
          ],
          rows: result?.result
                  .map((Korisnik e) => DataRow(
                          onSelectChanged: (selected) => {
                                if (selected == true)
                                  {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            KorisnikDetailsScreen(
                                          korisnik: e,
                                        ),
                                      ),
                                    )
                                  }
                              },
                          cells: [
                           
                            DataCell(Text(e.ime ?? "")),
                            DataCell(Text(e.prezime ?? "")),
                            DataCell(Text(e.email ?? "")),
                            DataCell(Text(e.korisnikoIme ?? "")),
                            DataCell(e.slika != ""
                                // ignore: sized_box_for_whitespace
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    child: imageFromBase64String(e.slika!),
                                  )
                                : const Text(""))
                          ]))
                  .toList() ??
              []),
    ));
  }
}