
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/grad.dart';
import '../models/search_result.dart';
import '../providers/grad.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';
import 'grad_details_screen.dart';
import 'hotel_details_screen.dart';

class GradListScreen extends StatefulWidget {
  const GradListScreen({Key? key}) : super(key: key);

  @override
  State<GradListScreen> createState() => _GradListScreenState();
}

class _GradListScreenState extends State<GradListScreen> {
  late GradProvider _gradProvider;
  SearchResult<Grad>? result;
  // ignore: prefer_final_fields, unnecessary_new
  TextEditingController _nazivController = new TextEditingController();
  
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _gradProvider = context.read<GradProvider>();
    _loadData();
  }
Future<void> _loadData() async {
    var data = await _gradProvider.get(filter: {'naziv': _nazivController.text});
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
          child: const Text("Gradovi", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
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
              var newGrad = await Navigator.of(context).push<Grad?>(
                MaterialPageRoute(
                  builder: (context) => GradDetailsScreen(grad: null),
                ),
              );
              if (newGrad != null) {
                setState(() {
                  result!.result.add(newGrad);
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
                    (Grad e) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            e.naziv ?? "",
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                          onTap: () async {
                            var updatedKontinent = await Navigator.of(context).push<Grad?>(
                              MaterialPageRoute(
                                builder: (context) => GradDetailsScreen(grad: e),
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