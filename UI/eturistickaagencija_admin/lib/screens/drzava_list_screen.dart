
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/drzava.dart';
import '../models/search_result.dart';
import '../providers/drzava_provider.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';
import 'drzava_details_screen.dart';

class DrzavaListScreen extends StatefulWidget {
  const DrzavaListScreen({Key? key}) : super(key: key);

  @override
  State<DrzavaListScreen> createState() => _DrzavaListScreenState();
}

class _DrzavaListScreenState extends State<DrzavaListScreen> {
  late DrzavaProvider _drzavaProvider;
  SearchResult<Drzava>? result;
  // ignore: prefer_final_fields, unnecessary_new
  TextEditingController _nazivController = new TextEditingController();
  List<Drzava> drzavas = [];
  Drzava? selectedDrzava;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _drzavaProvider = context.read<DrzavaProvider>();
    _loadData();
  }
   Future<void> _loadData() async {
    var data = await _drzavaProvider.get(filter: {'naziv': _nazivController.text});
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
          child: const Text("Drzave", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
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
              controller: _nazivController,
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
              var newDrzava = await Navigator.of(context).push<Drzava?>(
                MaterialPageRoute(
                  builder: (context) => DrzavaDetailsScreen(drzava: null),
                ),
              );
              if (newDrzava != null) {
                setState(() {
                  result!.result.add(newDrzava);
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
                    (Drzava e) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            e.naziv ?? "",
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                          onTap: () async {
                            var updatedKontinent = await Navigator.of(context).push<Drzava?>(
                              MaterialPageRoute(
                                builder: (context) => DrzavaDetailsScreen(drzava: e),
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