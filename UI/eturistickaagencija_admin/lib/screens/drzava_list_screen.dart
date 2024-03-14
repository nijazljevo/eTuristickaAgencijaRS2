
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
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Drzava list"),
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

                var data = await _drzavaProvider.get(filter: {
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
                    builder: (context) =>  DrzavaDetailsScreen(
                     drzava: null,
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
            
          ],
          rows: result?.result
                  .map((Drzava e) => DataRow(
                          onSelectChanged: (selected) => {
                                if (selected == true)
                                  {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DrzavaDetailsScreen(
                                          drzava: e,
                                        ),
                                      ),
                                    )
                                  }
                              },
                          cells: [
                            DataCell(Text(e.naziv ?? "")),
                          
                          ]))
                  .toList() ??
              []),
    ));
  }
}