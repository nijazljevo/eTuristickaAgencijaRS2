import 'dart:io';

import 'package:eturistickaagencija_admin/models/termin.dart';
import 'package:eturistickaagencija_admin/providers/termin_provider.dart';
import 'package:eturistickaagencija_admin/screens/termin_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/search_result.dart';
import '../widgets/master_screen.dart';

class TerminListScreen extends StatefulWidget {
  const TerminListScreen({Key? key}) : super(key: key);

  @override
  State<TerminListScreen> createState() => _TerminListScreenState();
}

class _TerminListScreenState extends State<TerminListScreen> {
  late TerminProvider _terminProvider;
  SearchResult<Termin>? result;
  final TextEditingController _cijenaController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _terminProvider = context.read<TerminProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    final cijenaFilter = _cijenaController.text.isNotEmpty ? {'cijena': _cijenaController.text} : null;

    var data = await _terminProvider.get(filter: cijenaFilter);
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: MasterScreenWidget(
        title_widget: Container(
          padding: const EdgeInsets.all(12),
          child: const Text("Termini", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
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
              controller: _cijenaController,
              decoration: InputDecoration(
                labelText: "Cijena",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () async {
              await _loadData();
            },
            icon: const Icon(Icons.search),
            label: const Text("Pretraga"),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () async {
              var newTermin = await Navigator.of(context).push<Termin?>(
                MaterialPageRoute(
                  builder: (context) => TerminDetailsScreen(termin: null),
                ),
              );
              if (newTermin != null) {
                setState(() {
                  result!.result.add(newTermin);
                });
              }
              _loadData();
            },
            icon: const Icon(Icons.add),
            label: const Text("Dodaj"),
          ),
         
        ],
      ),
    );
  }

  Widget _buildDataListView() {
   return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0), // Adjust the left padding here
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
            columns: const [
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Cijena',
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Popust',
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Cijena sa popustom',
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Datum polaska',
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Datum dolaska',
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
             
            ],
            rows: result?.result
                .map(
                  (Termin e) => DataRow(
                    cells: [
                      DataCell(
                        Text(
                          e.cijena?.toString() ?? "",
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                        onTap: () async {
                          var updatedTermin = await Navigator.of(context).push<Termin?>(
                            MaterialPageRoute(
                              builder: (context) => TerminDetailsScreen(termin: e),
                            ),
                          );
                          if (updatedTermin != null) {
                            setState(() {
                              int index = result!.result.indexWhere((element) => element.id == updatedTermin!.id);
                              result!.result[index] = updatedTermin;
                            });
                          }
                          _loadData();
                        },
                      ),
                       DataCell(
                        Text(
                          e.popust?.toString() ?? "",
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                        onTap: () async {
                          var updatedTermin = await Navigator.of(context).push<Termin?>(
                            MaterialPageRoute(
                              builder: (context) => TerminDetailsScreen(termin: e),
                            ),
                          );
                          if (updatedTermin != null) {
                            setState(() {
                              int index = result!.result.indexWhere((element) => element.id == updatedTermin!.id);
                              result!.result[index] = updatedTermin;
                            });
                          }
                          _loadData();
                        },
                      ),
                       DataCell(
                        Text(
                          e.cijenaPopust?.toString() ?? "",
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                        onTap: () async {
                          var updatedTermin = await Navigator.of(context).push<Termin?>(
                            MaterialPageRoute(
                              builder: (context) => TerminDetailsScreen(termin: e),
                            ),
                          );
                          if (updatedTermin != null) {
                            setState(() {
                              int index = result!.result.indexWhere((element) => element.id == updatedTermin!.id);
                              result!.result[index] = updatedTermin;
                            });
                          }
                          _loadData();
                        },
                      ),
                      
                      DataCell(
                        Text(
                          e.datumPolaska != null ? e.datumPolaska.toString() : '',
                        ),
                        onTap: () async {
                         var updatedTermin = await Navigator.of(context).push<Termin?>(
                            MaterialPageRoute(
                              builder: (context) => TerminDetailsScreen(termin: e),
                            ),
                          );
                          if (updatedTermin != null) {
                            setState(() {
                              int index = result!.result.indexWhere((element) => element.id == updatedTermin!.id);
                              result!.result[index] = updatedTermin;
                            });
                          }
                          _loadData();
                        },
                      ),
                      
                       DataCell(
                        Text(
                          e.datumDolaska != null ? e.datumDolaska.toString() : '',
                        ),
                        onTap: () async {
                         var updatedTermin = await Navigator.of(context).push<Termin?>(
                            MaterialPageRoute(
                              builder: (context) => TerminDetailsScreen(termin: e),
                            ),
                          );
                          if (updatedTermin != null) {
                            setState(() {
                              int index = result!.result.indexWhere((element) => element.id == updatedTermin!.id);
                              result!.result[index] = updatedTermin;
                            });
                          }
                          _loadData();
                        },
                      ),
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
