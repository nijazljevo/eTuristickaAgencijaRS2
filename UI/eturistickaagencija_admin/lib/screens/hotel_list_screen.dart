import 'dart:io';

import 'package:eturistickaagencija_admin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/hotel.dart';
import '../models/search_result.dart';
import '../providers/hotel_provider.dart';
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
  final TextEditingController _nazivController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hotelProvider = context.read<HotelProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    var data = await _hotelProvider.get(filter: {'naziv': _nazivController.text});
    setState(() {
      result = data;
    });
  }

  Future<void> generatePDFReport() async {
    final pdf = pw.Document();

    final currentDate = DateTime.now();
    final formattedDate = "${currentDate.day}.${currentDate.month}.${currentDate.year}.";

    final hotels = result?.result ?? [];
    final numberOfHotels = hotels.length;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Izvještaj hotela", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0x000080))),
                pw.SizedBox(height: 10),
                pw.Text("Datum: $formattedDate", style: const pw.TextStyle(fontSize: 18, color: PdfColor.fromInt(0x808080))),
                pw.SizedBox(height: 10),
                pw.Text("Broj hotela: $numberOfHotels", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          alignment: pw.Alignment.center,
                          child: pw.Text("Naziv", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          alignment: pw.Alignment.center,
                          child: pw.Text("Broj zvjezdica", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                        ),
                      ],
                    ),
                    for (final hotel in hotels)
                      pw.TableRow(
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.all(8),
                            alignment: pw.Alignment.center,
                            child: pw.Text(hotel.naziv ?? "", style: const pw.TextStyle(fontSize: 16)),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.all(8),
                            alignment: pw.Alignment.center,
                            child: pw.Text(hotel.brojZvjezdica?.toString() ?? "", style: const pw.TextStyle(fontSize: 16)),
                          ),
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
    // ignore: avoid_unnecessary_containers
    return Container(
      child: MasterScreenWidget(
        title_widget: Container(
          padding: const EdgeInsets.all(12),
          child: const Text("Hoteli", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
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
              decoration: InputDecoration(
                labelText: "Naziv",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              ),
              controller: _nazivController,
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
              var newHotel = await Navigator.of(context).push<Hotel?>(
                MaterialPageRoute(
                  builder: (context) => const HotelDetailsScreen(hotel: null),
                ),
              );
              if (newHotel != null) {
                setState(() {
                  result!.result.add(newHotel);
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
                    'Naziv',
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Broj zvjezdica',
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Slika',
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
            rows: result?.result
                  .map(
                    (Hotel e) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            e.naziv ?? "",
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                          onTap: () async {
                            var updatedKontinent = await Navigator.of(context).push<Hotel?>(
                              MaterialPageRoute(
                                builder: (context) => HotelDetailsScreen(hotel: e),
                              ),
                            );
                            if (updatedKontinent != null) {
                              setState(() {
                                int index = result!.result.indexWhere((element) => element.id == updatedKontinent!.id);
                                result!.result[index] = updatedKontinent;
                              });
                            }
                            _loadData();
                          },
                        ),
                        DataCell(
                          Text(
                            e.brojZvjezdica?.toString() ?? "",
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ),
                        DataCell(
                          e.slika != ""
                              // ignore: sized_box_for_whitespace
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  child: imageFromBase64String(e.slika!),
                                )
                              : const Text(""),
                        )
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
