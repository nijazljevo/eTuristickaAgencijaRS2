
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
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Grad list"),
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

                var data = await _gradProvider.get(filter: {
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
                    builder: (context) =>  GradDetailsScreen(
                     grad: null,
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
    .map((Grad e) {
      return DataRow(
        onSelectChanged: (selected) {
          if (selected == true) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GradDetailsScreen(
                  grad: e,
                ),
              ),
            );
          }
        },
        cells: [
          DataCell(Text(e.naziv ?? "")),
        ],
      );
    })
    .toList() ??
    [],
),
    ));
  }
}