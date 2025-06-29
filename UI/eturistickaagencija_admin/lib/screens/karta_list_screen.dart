import 'package:eturistickaagencija_admin/providers/karta_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/karta.dart';
import '../models/search_result.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';
import 'package:intl/intl.dart';

class KartaScreen extends StatefulWidget {
  const KartaScreen({Key? key}) : super(key: key);

  @override
  State<KartaScreen> createState() => _KartaScreenState();
}

class _KartaScreenState extends State<KartaScreen> {
  late KartaProvider _kartaProvider;
  SearchResult<Karta>? result;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _kartaProvider = context.read<KartaProvider>();
    _loadData();
  }
Future<void> _loadData() async {
    var data = await _kartaProvider.get();
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
          child: const Text("Karte", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
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
                    'Datum kreiranja',
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
          rows: result?.result
                  .map(
                    (Karta e) => DataRow(
                      
                      
                      cells: [
                      DataCell(
                        Text(
                           e.datumKreiranja.toString(),
                           style: const TextStyle(fontWeight: FontWeight.normal),
                          
                    )),



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
