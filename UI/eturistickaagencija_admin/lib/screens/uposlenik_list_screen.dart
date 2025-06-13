// ignore_for_file: unnecessary_nullable_for_final_variable_declarations, avoid_unnecessary_containers

import 'package:eturistickaagencija_admin/screens/uposlenik_details_screen.dart';
import 'package:eturistickaagencija_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/uposlenik.dart';
import '../models/search_result.dart';
import '../providers/uposlenik_provider.dart';

class UposlenikListScreen extends StatefulWidget {
  const UposlenikListScreen({Key? key}) : super(key: key);

  @override
  State<UposlenikListScreen> createState() => _UposlenikListScreenState();
}

class _UposlenikListScreenState extends State<UposlenikListScreen> {
  late UposlenikProvider _uposlenikProvider;
  SearchResult<Uposlenik>? result;
  final TextEditingController _datumZaposlenjaController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _uposlenikProvider = context.read<UposlenikProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    DateTime? parsedDate;
    final String? dateString = _datumZaposlenjaController.text;

    if (dateString != null && dateString.isNotEmpty) {
      parsedDate = DateTime.parse(dateString);
    }

    final datumFilter = parsedDate != null ? {'datumZaposlenja': parsedDate} : null;

    var data = await _uposlenikProvider.get(filter: datumFilter);
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
          child: const Text("Uposlenici", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
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
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _datumZaposlenjaController,
              decoration: InputDecoration(
                labelText: "Datum zaposlenja",
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
              var newUposlenik = await Navigator.of(context).push<Uposlenik?>(
                MaterialPageRoute(
                  builder: (context) => const UposlenikDetailsScreen(uposlenik: null),
                ),
              );
              if (newUposlenik != null) {
                setState(() {
                  result!.result.add(newUposlenik);
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
        padding: const EdgeInsets.only(left: 400,right:400),
        child: result != null && result!.result.isNotEmpty ? DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
          columns: const [
            DataColumn(
              label: Expanded(
                child: Text(
                  'Datum zaposlenja',
                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          rows: result!.result
              .map(
                (Uposlenik e) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        e.datumZaposlenja != null ? e.datumZaposlenja.toString() : '',
                      ),
                       onTap: () async {
                          var updatedUposlenik = await Navigator.of(context).push<Uposlenik?>(
                            MaterialPageRoute(
                              builder: (context) => UposlenikDetailsScreen(uposlenik: e),
                            ),
                          );
                          if (updatedUposlenik != null) {
                            setState(() {
                              int index = result!.result.indexWhere((element) => element.id == updatedUposlenik!.id);
                              result!.result[index] = updatedUposlenik;
                            });
                          }
                          _loadData();
                        },
                    ),
                  ],
                ),
              )
              .toList(),
        ) : Container(),
      ),
    ),
  );
}


}
