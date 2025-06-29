// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../models/kontinent.dart';
import '../models/search_result.dart';
import '../providers/kontinent_provider.dart';
import '../widgets/master_screen.dart';
import 'kontinent_details_screen.dart';

class KontinentListScreen extends StatefulWidget {
  const KontinentListScreen({Key? key}) : super(key: key);

  @override
  State<KontinentListScreen> createState() => _KontinentListScreenState();
}

class _KontinentListScreenState extends State<KontinentListScreen> {
  late KontinentProvider _kontinentProvider;
  SearchResult<Kontinent>? result;
  final TextEditingController _nazivController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _kontinentProvider = context.read<KontinentProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    var data = await _kontinentProvider.get(filter: {'naziv': _nazivController.text});
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
          child: const Text("Kontinenti", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
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
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0), 
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
              controller: _nazivController,
            ),
          ),
        ),
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
            var newKontinent = await Navigator.of(context).push<Kontinent?>(
              MaterialPageRoute(
                builder: (context) => const KontinentDetailsScreen(kontinent: null),
              ),
            );
            if (newKontinent != null) {
              setState(() {
                result!.result.add(newKontinent);
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
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
            columns: const [
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Naziv',
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
            ],
            rows: result?.result
                  .map(
                    (Kontinent e) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            e.naziv ?? "",
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                          onTap: () async {
                            var updatedKontinent = await Navigator.of(context).push<Kontinent?>(
                              MaterialPageRoute(
                                builder: (context) => KontinentDetailsScreen(kontinent: e),
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