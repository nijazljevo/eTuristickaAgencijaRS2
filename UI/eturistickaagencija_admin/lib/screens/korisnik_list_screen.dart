
// ignore_for_file: avoid_print, avoid_unnecessary_containers

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
    _loadData();
  }
Future<void> _loadData() async {
    var data = await _korisnikProvider.get(filter: {'ime': _imeController.text});
    setState(() {
      result = data;
    });
  }
  @override
 Widget build(BuildContext context) {
    return Container(
      child: MasterScreenWidget(
        title_widget: Container(
          padding: const EdgeInsets.all(12),
          child: const Text("Korisnici", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        child: Column(
          children: [
            _buildSearch(),
            _buildDataListView(),
          ],
        ),
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
               decoration: InputDecoration(
                labelText: "Ime",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              ),
              controller: _imeController,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
         
       ElevatedButton.icon(
            onPressed: () async {
              await _loadData();
            },
            icon: const Icon(Icons.search),
            label: const Text("Pretraga"),
          ),
          const SizedBox(
            width: 8,
          ),
          ElevatedButton.icon(
            onPressed: () async {
              var newKorisnik = await Navigator.of(context).push<Korisnik?>(
                MaterialPageRoute(
                  builder: (context) => KorisnikDetailsScreen(korisnik: null),
                ),
              );
              if (newKorisnik != null) {
                setState(() {
                  result!.result.add(newKorisnik);
                });
              }
              _loadData();
            },
              icon: const Icon(Icons.add),
            label: const Text("Dodaj"),)
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    return Expanded(
        child: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
          columns: const [
            DataColumn(
              label: Expanded(
                child: Text(
                  'Ime',
                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Prezime',
                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
              ),
            ),
           DataColumn(
              label: Expanded(
                child: Text(
                  'Email',
                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
              ),
            ),
             DataColumn(
              label: Expanded(
                child: Text(
                  'Korisnicko ime',
                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Slika',
                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
          rows: result?.result
                  .map(
                    (Korisnik e) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            e.ime ?? "",
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                          onTap: () async {
                            var updatedKontinent = await Navigator.of(context).push<Korisnik?>(
                              MaterialPageRoute(
                                builder: (context) => KorisnikDetailsScreen(korisnik: e),
                              ),
                            );
                            if (updatedKontinent != null) {
                              setState(() {
                                int index = result!.result.indexWhere((element) => element.id == updatedKontinent!.id);
                                result!.result[index] = updatedKontinent;
                              });
                            }
                            _loadData();
                          },
                        ),
                           DataCell(
                          Text(
                            e.prezime?.toString() ?? "",
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                          onTap: () async {
                            var updatedKontinent = await Navigator.of(context).push<Korisnik?>(
                              MaterialPageRoute(
                                builder: (context) => KorisnikDetailsScreen(korisnik: e),
                              ),
                            );
                            if (updatedKontinent != null) {
                              setState(() {
                                int index = result!.result.indexWhere((element) => element.id == updatedKontinent!.id);
                                result!.result[index] = updatedKontinent;
                              });
                            }
                            _loadData();
                          },
                        ),
                         DataCell(
                          Text(
                            e.email?.toString() ?? "",
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                          onTap: () async {
                            var updatedKontinent = await Navigator.of(context).push<Korisnik?>(
                              MaterialPageRoute(
                                builder: (context) => KorisnikDetailsScreen(korisnik: e),
                              ),
                            );
                            if (updatedKontinent != null) {
                              setState(() {
                                int index = result!.result.indexWhere((element) => element.id == updatedKontinent!.id);
                                result!.result[index] = updatedKontinent;
                              });
                            }
                            _loadData();
                          },
                        ),
                         DataCell(
                          Text(
                            e.korisnikoIme?.toString() ?? "",
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                          onTap: () async {
                            var updatedKontinent = await Navigator.of(context).push<Korisnik?>(
                              MaterialPageRoute(
                                builder: (context) => KorisnikDetailsScreen(korisnik: e),
                              ),
                            );
                            if (updatedKontinent != null) {
                              setState(() {
                                int index = result!.result.indexWhere((element) => element.id == updatedKontinent!.id);
                                result!.result[index] = updatedKontinent;
                              });
                            }
                            _loadData();
                          },
                        ),
                          DataCell(
                          e.slika != ""
                              // ignore: sized_box_for_whitespace
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  child: imageFromBase64String(e.slika!),
                                )
                              : const Text(""),
                        )
                      ],
                    ),
                  )
                  .toList() ??
              [],
          ),
        ),
      ),
    );
  }
}