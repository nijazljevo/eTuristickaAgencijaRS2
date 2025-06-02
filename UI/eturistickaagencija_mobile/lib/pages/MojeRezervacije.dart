import 'package:flutter/material.dart';
import 'package:eturistickaagencija_mobile/model/rezervacija.dart';
import 'package:eturistickaagencija_mobile/services/APIService.dart';
import 'package:eturistickaagencija_mobile/utils/util.dart';
import 'package:intl/intl.dart';

class MojeRezervacijeScreen extends StatefulWidget {
  const MojeRezervacijeScreen({Key? key}) : super(key: key);

  @override
  _MojeRezervacijeScreenState createState() => _MojeRezervacijeScreenState();
}

class _MojeRezervacijeScreenState extends State<MojeRezervacijeScreen> {
  List<Rezervacije> mojeRezervacije = [];
  late bool _isLoading;

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    fetchMojeRezervacije();
  }

  Future<void> fetchMojeRezervacije() async {
    try {
      final List<dynamic>? fetchedData =
          await APIService.get('Rezervacija', null);
      if (fetchedData != null) {
        final List<Rezervacije> fetchedRezervacije = fetchedData
            .map((json) => Rezervacije.fromJson(json))
            .where((rezervacija) =>
                rezervacija.korisnikId == APIService.korisnikId)
            .toList();
        setState(() {
          mojeRezervacije = fetchedRezervacije;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Greška'),
              content: const Text(
                  'Došlo je do greške prilikom dohvata podataka rezervacija.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Greška prilikom dohvata podataka rezervacija: $e');
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Greška'),
            content: const Text(
                'Došlo je do greške prilikom dohvata podataka rezervacija.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
        title: const Text(
          'Moje rezervacije',
        ),
        elevation: 0, // Uklanja sjenu ispod trake aplikacije
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 8),
                      child: (mojeRezervacije.isEmpty && _isLoading == false)
                          ? const Center(
                              child: Text('Nemate rezervacija.'),
                            )
                          : Column(
                              children: mojeRezervacije.map((rezervacija) {
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Datum rezervacije: '
                                              '${DateFormat("dd. MM. yyyy.").format(rezervacija.datumRezervacije)}',
                                              style: const TextStyle(),
                                            ),
                                            const Spacer(),
                                            Checkbox(
                                              value: !rezervacija.otkazana,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  if (rezervacija.otkazana)
                                                    return;
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Potvrda otkazivanja rezervacije'),
                                                        content: const Text(
                                                            'Da li ste sigurni da želite otkazati rezervaciju?'),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              final bool?
                                                                  result =
                                                                  await APIService
                                                                      .cancelRezervation(
                                                                          rezervacija
                                                                              .id!);
                                                              if (result ==
                                                                      null ||
                                                                  !result) {
                                                                await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title: const Text(
                                                                            'Greška'),
                                                                        content:
                                                                            const Text('Rezervaciju je moguće otkazati najkasnije 7 dana prije početka (check in).'),
                                                                        actions: [
                                                                          ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                const Text('OK'),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    });
                                                                return;
                                                              } else {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                setState(() {
                                                                  rezervacija
                                                                          .otkazana =
                                                                      true;
                                                                });
                                                              }
                                                            },
                                                            child: const Text(
                                                                'Da'),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'Ne'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Check-in: '
                                          '${DateFormat("dd. MM. yyyy.").format(rezervacija.checkIn)}',
                                        ),
                                        Text(
                                          'Check-out: '
                                          '${DateFormat("dd. MM. yyyy.").format(rezervacija.checkOut)}',
                                        ),
                                        Text(
                                          'Broj osoba: ${rezervacija.brojOsoba}',
                                        ),
                                        Text(
                                          'Tip sobe: ${rezervacija.tipSobe}',
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Cijena: ${rezervacija.cijena}',
                                          style: const TextStyle(),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Status: ${rezervacija.otkazana ? 'Otkazana' : 'Aktivna'}',
                                          style: const TextStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
