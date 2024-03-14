
import 'dart:io';

import 'package:eturistickaagencija_admin/providers/hotel_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/hotel.dart';
import '../models/search_result.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';
import 'hotel_details_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;



class HotelListScreen extends StatefulWidget {
  const HotelListScreen({Key? key}) : super(key: key);

  @override
  State<HotelListScreen> createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  late HotelProvider _hotelProvider;
  SearchResult<Hotel>? result;
  // ignore: prefer_final_fields, unnecessary_new
  TextEditingController _nazivController = new TextEditingController();
  
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _hotelProvider = context.read<HotelProvider>();
  }
 Future<void> generatePDFReport() async {
    final pdf = pw.Document();

    // Uzmi trenutni datum
    final currentDate = DateTime.now();
    final formattedDate = "${currentDate.day}.${currentDate.month}.${currentDate.year}.";

    // Uzmi podatke o hotelima iz rezultata pretrage
    final hotels = result?.result ?? [];
    final numberOfHotels = hotels.length; // Broj hotela

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

                pw.Text("Broj hotela: $numberOfHotels", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),

                

                // Tabela sa podacima o hotelima
                pw.Table(
                  columnWidths: {
                    0: pw.FixedColumnWidth(200),
                    1: pw.FixedColumnWidth(100),
                    2: pw.FixedColumnWidth(100),
                  },
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Text("Naziv", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                        pw.Text("Broj zvjezdica", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    for (final hotel in hotels)
                      pw.TableRow(
                        children: [
                          pw.Text(hotel.naziv ?? "", style: pw.TextStyle(fontSize: 16)),
                          pw.Text(hotel.brojZvjezdica?.toString() ?? "", style: pw.TextStyle(fontSize: 16)),
                        ],
                      ),
                  ],
                ),
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
      title_widget: const Text("Hotel list"),
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

                var data = await _hotelProvider.get(filter: {
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
                    builder: (context) =>  HotelDetailsScreen(
                     hotel: null,
                    ),
                  ),
                );
              },
              child: const Text("Dodaj")),
              ElevatedButton(
  onPressed: () async {
    // Generiši PDF izvještaj
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
                  'Broj zvjezdica',
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
                  .map((Hotel e) => DataRow(
                          onSelectChanged: (selected) => {
                                if (selected == true)
                                  {
                                   Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            HotelDetailsScreen(
                                          hotel: e,
                                        ),
                                      ),
                                    )
                                  }
                              },
                          cells: [
                            DataCell(Text(e.naziv ?? "")),
                            DataCell(Text(e.brojZvjezdica?.toString() ?? "")),
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