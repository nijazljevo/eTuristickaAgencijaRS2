// ignore_for_file: avoid_unnecessary_containers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rezervacija.dart';
import '../models/search_result.dart';
import '../widgets/master_screen.dart';
import '../providers/rezervacija_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'rezervacija_details_screen.dart';

class RezervacijeScreen extends StatefulWidget {
  const RezervacijeScreen({Key? key}) : super(key: key);

  @override
  State<RezervacijeScreen> createState() => _RezervacijeScreenState();
}

class _RezervacijeScreenState extends State<RezervacijeScreen> {
  late RezervacijaProvider _rezervacijaProvider;
  SearchResult<Rezervacija>? result;
  final TextEditingController _cijenaController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rezervacijaProvider = context.read<RezervacijaProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    // Provjera da li je tekstualno polje prazno
    final cijenaFilter = _cijenaController.text.isNotEmpty ? {'cijena': _cijenaController.text} : null;

    var data = await _rezervacijaProvider.get(filter: cijenaFilter);
    setState(() {
      result = data;
    });
  }

  Future<void> generatePDFReport() async {
    final pdf = pw.Document();

    final currentDate = DateTime.now();
    final formattedDate = "${currentDate.day}.${currentDate.month}.${currentDate.year}.";

    final rezervacije = result?.result ?? [];
    final numberOfRezervacije = rezervacije.length;

    double ukupnaCijena = 0;
    for (final rezervacija in rezervacije) {
      ukupnaCijena += rezervacija.cijena ?? 0;
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Izvjestaj", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0x000080))),
                pw.SizedBox(height: 10),
                pw.Text("Datum: $formattedDate", style: const pw.TextStyle(fontSize: 18, color: PdfColor.fromInt(0x808080))),
                pw.SizedBox(height: 10),
                pw.Text("Broj rezervacija: $numberOfRezervacije", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Table(
                  columnWidths: {
                    0: const pw.FixedColumnWidth(150),
                    1: const pw.FixedColumnWidth(150),
                  },
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Text("Datum rezervacije", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                        pw.Text("Cijena", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    for (final rezervacija in rezervacije)
                      pw.TableRow(
                        children: [
                          pw.Text(rezervacija.datumRezervacije?.toString() ?? "", style: const pw.TextStyle(fontSize: 16)),
                          pw.Text(rezervacija.cijena.toString() ?? "", style: const pw.TextStyle(fontSize: 16)),
                        ],
                      ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text("Ukupno: $ukupnaCijena", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );

    final directory = await path_provider.getTemporaryDirectory();
    final filePath = path.join(directory.path, 'izvjestaj.pdf');

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    await openFile(file.path);
  }

  Future<void> openFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      if (Platform.isWindows) {
        await Process.run('start', [filePath], runInShell: true);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [filePath], runInShell: true);
      } else if (Platform.isMacOS) {
        await Process.run('open', [filePath], runInShell: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MasterScreenWidget(
        title_widget: Container(
          padding: const EdgeInsets.all(12),
          child: const Text("Rezervacije", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
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
              controller: _cijenaController,
              decoration: InputDecoration(
                labelText: "Cijena",
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
              var newRezervacija = await Navigator.of(context).push<Rezervacija?>(
                MaterialPageRoute(
                  builder: (context) => const ReservationScreen(rezervacija: null),
                ),
              );
              if (newRezervacija != null) {
                setState(() {
                  result!.result.add(newRezervacija);
                });
              }
              _loadData();
            },
            icon: const Icon(Icons.add),
            label: const Text("Dodaj"),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () async {
              await generatePDFReport();
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text("Generiši izvještaj"),
          ),
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
                    'Cijena',
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Datum rezervacije',
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
             
            ],
            rows: result?.result
                .map(
                  (Rezervacija e) => DataRow(
                    cells: [
                      DataCell(
                        Text(
                          e.cijena?.toString() ?? "",
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                        onTap: () async {
                          var updatedRezervacija = await Navigator.of(context).push<Rezervacija?>(
                            MaterialPageRoute(
                              builder: (context) => ReservationScreen(rezervacija: e),
                            ),
                          );
                          if (updatedRezervacija != null) {
                            setState(() {
                              int index = result!.result.indexWhere((element) => element.id == updatedRezervacija!.id);
                              result!.result[index] = updatedRezervacija;
                            });
                          }
                          _loadData();
                        },
                      ),
                      DataCell(
                        Text(
                          e.datumRezervacije != null ? e.datumRezervacije.toString() : '',
                        ),
                        onTap: () async {
                          var updatedRezervacija = await Navigator.of(context).push<Rezervacija?>(
                            MaterialPageRoute(
                              builder: (context) => ReservationScreen(rezervacija: e),
                            ),
                          );
                          if (updatedRezervacija != null) {
                            setState(() {
                              int index = result!.result.indexWhere((element) => element.id == updatedRezervacija!.id);
                              result!.result[index] = updatedRezervacija;
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
