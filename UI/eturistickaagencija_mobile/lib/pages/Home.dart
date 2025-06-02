import 'package:flutter/material.dart';
import '../model/destinacija.dart';
import '../services/APIService.dart';
import 'DestinacijaDetails.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Destinacija>?> getPreporuceneDestinacije() async {
    try {
      final preporuceneDestinacije = await APIService.get(
          'Destinacije/preporuceno', APIService.korisnikId);

      print('Preporučene destinacije dobivene: $preporuceneDestinacije');
      if (preporuceneDestinacije != null) {
        return preporuceneDestinacije
            .map((i) => Destinacija.fromJson(i))
            .toList();
      } else {
        print('Nema podataka za preporučene destinacije.');
        return null;
      }
    } catch (e) {
      print('Greška prilikom dohvata preporučenih destinacija: $e');
      return null;
    }
  }

  Widget preporucenaHotelWidget(Destinacija destinacija) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DestinacijaDetailsScreen(destinacija: destinacija),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Destinacija: ${destinacija.naziv}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
        title: const Text('Početna'),
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Preporučeno',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25)),
            ),
          ),
          Flexible(
            child: FutureBuilder<List<Destinacija>?>(
              future: getPreporuceneDestinacije(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Destinacija>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          Destinacija destinacija = snapshot.data![index];
                          return preporucenaHotelWidget(destinacija);
                        },
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "Nema dovoljno podataka za prikaz.",
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      child: ListView(
        children: [
          DrawerHeader(
              margin: EdgeInsets.zero,
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${APIService.username}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ])),
          // Bijela linija
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16), // Padding sa lijeve i desne strane
            leading: const Icon(Icons.home),
            title: const Text(
              "Početna",
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('Home');
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16), // Padding sa lijeve i desne strane
            leading: const Icon(Icons.person),
            title: const Text(
              "Profil",
            ),
            onTap: () {
              Navigator.of(context).pushNamed('Profil');
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16), // Padding sa lijeve i desne strane
            leading: const Icon(Icons.hotel),
            title: const Text(
              "Hotel",
            ),
            onTap: () {
              Navigator.of(context).pushNamed('HotelListPage');
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16), // Padding sa lijeve i desne strane
            leading: const Icon(Icons.airplane_ticket),
            title: const Text(
              "Destinacija",
            ),
            onTap: () {
              Navigator.of(context).pushNamed('DestinacijaListPage');
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16), // Padding sa lijeve i desne strane
            leading: const Icon(Icons.hotel),
            title: const Text(
              "Moje rezervacije",
            ),
            onTap: () {
              Navigator.of(context).pushNamed('MojeRezervacijeScreen');
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16), // Padding sa lijeve i desne strane
            leading: const Icon(Icons.logout),
            title: const Text(
              "Odjava",
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Odjava'),
                    content: const Text('Da li zaista želite da se odjavite?'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                        child: const Text('Da'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Ne'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
