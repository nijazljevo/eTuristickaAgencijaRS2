import 'dart:io';

import 'package:eturistickaagencija_admin/screens/rezervacija_details_screen.dart';
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

class RezervacijeScreen extends StatefulWidget {
  const RezervacijeScreen({Key? key}) : super(key: key);

  @override
  State<RezervacijeScreen> createState() => _RezervacijeScreenState();
}

class _RezervacijeScreenState extends State<RezervacijeScreen> {
  late RezervacijaProvider _rezervacijaProvider;
  SearchResult<Rezervacija>? result;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rezervacijaProvider = context.read<RezervacijaProvider>();
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
              pw.Text("Izvjestaj", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColor.fromInt(0x000080))),
              pw.SizedBox(height: 10),

              pw.Text("Datum: $formattedDate", style: pw.TextStyle(fontSize: 18, color: PdfColor.fromInt(0x808080))),
              pw.SizedBox(height: 10),

              pw.Text("Broj rezervacija: $numberOfRezervacije", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),

              pw.Table(
                columnWidths: {
                  0: pw.FixedColumnWidth(150), 
                  1: pw.FixedColumnWidth(150), 
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
                        pw.Text(rezervacija.datumRezervacije?.toString() ?? "", style: pw.TextStyle(fontSize: 16)),
                        pw.Text(rezervacija.cijena.toString() ?? "", style: pw.TextStyle(fontSize: 16)),
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
    return MasterScreenWidget(
      title_widget: const Text("Lista rezervacija"),
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
          ElevatedButton(
            onPressed: () async {
              print("Pretraga");

              var data = await _rezervacijaProvider.get();

              setState(() {
                result = data;
              });
            },
            child: const Text("Pretraga"),
          ),
          const SizedBox(
            width: 8,
          ),
          ElevatedButton(
            onPressed: () async {
               Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>  ReservationScreen(
                     
                    ),
                  ),
                ); 
            },
            child: const Text("Dodaj"),
          ),
           ElevatedButton(
            onPressed: () async {
              await generatePDFReport();
            },
            child: const Text("Generiši izvještaj"),
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
                'Cijena',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
             DataColumn(
              label: Text(
                'Datum rezervacije',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: result?.result
                  .map(
                    (Rezervacija e) => DataRow(
                      onSelectChanged: (selected) => {
                        if (selected == true)
                                  {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReservationScreen(
                                          rezervacija: e,
                                        ),
                                      ),
                                    )
                                  }
                              },
                      cells: [
                        DataCell(Text(e.cijena.toString() ?? "")),
                                                    DataCell(Text(
                              // ignore: unnecessary_null_comparison
                              e.datumRezervacije != null
                                  ? e.datumRezervacije.toString()
                                  : '',
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

