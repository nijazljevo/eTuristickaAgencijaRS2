import 'package:eturistickaagencija_admin/models/kontinent.dart';
import 'package:eturistickaagencija_admin/models/search_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  // ignore: prefer_final_fields
  TextEditingController _nazivController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _kontinentProvider = context.read<KontinentProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Kontinent list"),
      // ignore: avoid_unnecessary_containers
      child: Container(
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
              decoration: const InputDecoration(labelText: "Naziv"),
              controller: _nazivController,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              var data = await _kontinentProvider.get(filter: {'naziv': _nazivController.text});
              setState(() {
                result = data;
              });
            },
            child: const Text("Pretraga"),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const KontinentDetailsScreen(kontinent: null),
                ),
              );
            },
            child: const Text("Dodaj"),
          ),
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
                  .map(
                    (Kontinent e) => DataRow(
                      onSelectChanged: (selected) {
                        if (selected == true) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => KontinentDetailsScreen(kontinent: e),
                            ),
                          );
                        }
                      },
                      cells: [
                        DataCell(Text(e.naziv ?? "")),
                      ],
                    ),
                  )
                  .toList() ??
              [],
        ),
      ),
    );
  }
}