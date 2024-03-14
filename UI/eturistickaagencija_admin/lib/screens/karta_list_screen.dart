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
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Lista karata"),
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
          const SizedBox(
            width: 8,
          ),
          ElevatedButton(
            onPressed: () async {
              var filter = <String, dynamic>{};

              var data = await _kartaProvider.get(filter: filter);

              setState(() {
                result = data;
              });
            },
            child: const Text("Pretraga"),
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
              label: Text(
                'Datum Kreiranja',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: result?.result
                  .map(
                    (Karta e) => DataRow(
                      
                      
                      cells: [
                      DataCell(Text(
                           e.datumKreiranja.toString()
                          
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
