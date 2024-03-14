import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/agencija.dart';
import '../models/search_result.dart';
import '../providers/agencija_provider.dart';
import 'agencija_details_screen.dart';
import '../widgets/master_screen.dart';

class AgencijaListScreen extends StatefulWidget {
  const AgencijaListScreen({Key? key}) : super(key: key);

  @override
  State<AgencijaListScreen> createState() => _AgencijaListScreenState();
}

class _AgencijaListScreenState extends State<AgencijaListScreen> {
  late AgencijaProvider _agencijaProvider;
  SearchResult<Agencija>? result;
  // ignore: prefer_final_fields
  TextEditingController _emailController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _agencijaProvider = context.read<AgencijaProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Agencija"),
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
            decoration: const InputDecoration(labelText: "Email"),
            controller: _emailController,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () async {
            var data = await _agencijaProvider.get(filter: {'email': _emailController.text});
            setState(() {
              if (data?.result.isEmpty ?? true) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Nema rezultata'),
                    content: const Text('Nema agencija s unesenim e-mailom.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
              result = data;
            });
          },
          child: const Text("Pretraga"),
        ),
        const SizedBox(width: 8),
        // ElevatedButton(
        //   onPressed: () async {
        //     Navigator.of(context).push(
        //       MaterialPageRoute(
        //         builder: (context) => const AgencijaDetailsScreen(),
        //       ),
        //     );
        //   },
        //   child: const Text("Dodaj"),
        // ),
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
                'Adresa',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Email',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Telefon',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: result?.result
                  .map(
                    (Agencija e) => DataRow(
                      onSelectChanged: (selected) {
                        if (selected == true) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AgencijaDetailsScreen(agencija: e),
                            ),
                          );
                        }
                      },
                      cells: [
                        DataCell(Text(e.adresa ?? "")),
                        DataCell(Text(e.email ?? "")),
                        DataCell(Text(e.telefon ?? "")),
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
