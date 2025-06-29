import 'package:eturistickaagencija_admin/models/destinacija.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/search_result.dart';
import '../providers/destinacija_provider.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';
import 'destinacija_details_screen.dart';

class DestinacijaListScreen extends StatefulWidget {
  const DestinacijaListScreen({Key? key}) : super(key: key);

  @override
  State<DestinacijaListScreen> createState() => _DestinacijaListScreenState();
}

class _DestinacijaListScreenState extends State<DestinacijaListScreen> {
  late DestinacijaProvider _destinacijaProvider;
  SearchResult<Destinacija>? result;
  // ignore: prefer_final_fields, unnecessary_new
  TextEditingController _nazivController = new TextEditingController();
  List<Destinacija> destinacijas = [];
  Destinacija? selectedDestinacija;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _destinacijaProvider = context.read<DestinacijaProvider>();
    _loadData();
  }
 Future<void> _loadData() async {
    var data = await _destinacijaProvider.get(filter: {'naziv': _nazivController.text});
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
          child: const Text("Destinacije", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
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
              var newDestinacija = await Navigator.of(context).push<Destinacija?>(
                MaterialPageRoute(
                  builder: (context) => DestinacijaDetailsScreen(destinacija: null),
                ),
              );
              if (newDestinacija != null) {
                setState(() {
                  result!.result.add(newDestinacija);
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
          padding: const EdgeInsets.only(left: 8.0), // Adjust the left padding here
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
                    (Destinacija e) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            e.naziv ?? "",
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                          onTap: () async {
                            var updatedKontinent = await Navigator.of(context).push<Destinacija?>(
                              MaterialPageRoute(
                                builder: (context) => DestinacijaDetailsScreen(destinacija: e),
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