
import 'package:eturistickaagencija_admin/models/destinacija.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/search_result.dart';
import '../providers/destinacija_provider.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';
import 'destinacija_details_screen.dart';
import 'hotel_details_screen.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Destinacija list"),
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
              decoration: const InputDecoration(labelText: "Naziv"),
              controller: _nazivController,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
         
          ElevatedButton(
              onPressed: () async {
                // ignore: avoid_print
                print("login proceed");

                var data = await _destinacijaProvider.get(filter: {
                  'naziv': _nazivController.text,
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
                    builder: (context) =>  DestinacijaDetailsScreen(
                     destinacija: null,
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
                  'Naziv',
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
                  .map((Destinacija e) => DataRow(
                          onSelectChanged: (selected) => {
                                if (selected == true)
                                  {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DestinacijaDetailsScreen(
                                          destinacija: e,
                                        ),
                                      ),
                                    )
                                  }
                              },
                          cells: [
                            DataCell(Text(e.naziv ?? "")),
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