import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/agencija.dart';
import '../models/search_result.dart';
import '../providers/agencija_provider.dart';
import 'agencija_details_screen.dart';
import '../widgets/master_screen.dart';

class AgencijaListScreen extends StatefulWidget {
  const AgencijaListScreen({Key? key}) : super(key: key);

  @override
  State<AgencijaListScreen> createState() => _AgencijaListScreenState();
}

class _AgencijaListScreenState extends State<AgencijaListScreen> {
  late AgencijaProvider _agencijaProvider;
  SearchResult<Agencija>? result;
  // ignore: prefer_final_fields
  TextEditingController _emailController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _agencijaProvider = context.read<AgencijaProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    var data = await _agencijaProvider.get(filter: {'email': _emailController.text});
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
          child: const Text("Agencija", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
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
                labelText: "Naziv",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              ),
            controller: _emailController,
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
              label: Text(
                'Adresa',
                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Email',
                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Telefon',
                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: result?.result
                  .map(
                    (Agencija e) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            e.adresa ?? "",
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                          onTap: () async {
                            var updatedKontinent = await Navigator.of(context).push<Agencija?>(
                              MaterialPageRoute(
                                builder: (context) => AgencijaDetailsScreen(agencija: e),
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
                            e.email ?? "",
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                            onTap: () async {
                            var updatedKontinent = await Navigator.of(context).push<Agencija?>(
                              MaterialPageRoute(
                                builder: (context) => AgencijaDetailsScreen(agencija: e),
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
                            e.telefon ?? "",
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                            onTap: () async {
                            var updatedKontinent = await Navigator.of(context).push<Agencija?>(
                              MaterialPageRoute(
                                builder: (context) => AgencijaDetailsScreen(agencija: e),
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