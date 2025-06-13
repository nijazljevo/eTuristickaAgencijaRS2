
import 'package:eturistickaagencija_admin/models/clan.dart';
import 'package:eturistickaagencija_admin/providers/clan_provider.dart';
import 'package:eturistickaagencija_admin/screens/clan_details_screen.dart';
import 'package:eturistickaagencija_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/search_result.dart';

class ClanListScreen extends StatefulWidget {
  const ClanListScreen({Key? key}) : super(key: key);

  @override
  State<ClanListScreen> createState() => _ClanListScreenState();
}

class _ClanListScreenState extends State<ClanListScreen> {
  late ClanProvider _clanProvider;
  SearchResult<Clan>? result;
  // ignore: prefer_final_fields
  TextEditingController _datumRegistracijeController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _clanProvider = context.read<ClanProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    DateTime? parsedDate;
    // ignore: unnecessary_nullable_for_final_variable_declarations
    final String? dateString = _datumRegistracijeController.text;

    if (dateString != null && dateString.isNotEmpty) {
      parsedDate = DateTime.parse(dateString);
    }

    final datumFilter = parsedDate != null ? {'datumRegistracije': parsedDate} : null;

    var data = await _clanProvider.get(filter: datumFilter);
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
          child: const Text("Clanovi", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
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
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _datumRegistracijeController,
              decoration: InputDecoration(
                labelText: "Datum registracije",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              ),
            ),
          ),
          const SizedBox(width: 8),
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
              var newClan = await Navigator.of(context).push<Clan?>(
                MaterialPageRoute(
                  builder: (context) => const ClanDetailsScreen(clan: null),
                ),
              );
              if (newClan != null) {
                setState(() {
                  result!.result.add(newClan);
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
        child: result != null && result!.result.isNotEmpty ? DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
          columns: const [
            DataColumn(
              label: Expanded(
                child: Text(
                  'Datum registracije',
                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          rows: result!.result
              .map(
                (Clan e) => DataRow(
                  cells: [
                    DataCell(
                      Text(
                        e.datumRegistracije != null ? e.datumRegistracije.toString() : '',
                      ),
                       onTap: () async {
                          var updatedUposlenik = await Navigator.of(context).push<Clan?>(
                            MaterialPageRoute(
                              builder: (context) => ClanDetailsScreen(clan: e),
                            ),
                          );
                          if (updatedUposlenik != null) {
                            setState(() {
                              int index = result!.result.indexWhere((element) => element.id == updatedUposlenik!.id);
                              result!.result[index] = updatedUposlenik;
                            });
                          }
                          _loadData();
                        },
                    ),
                  ],
                ),
              )
              .toList(),
        ) : Container(),
      ),
    ),
  );
}


}
