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
                      fontWeight: FontWeight.bold,
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
        title: const Text('Početna'),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 185, 213, 236),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppBar(
                backgroundColor: const Color.fromARGB(255, 185, 213, 236),
                title: const Text(
                  "Meni",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
            ),
            const Divider(
              color: Colors.white,
              indent: 16, // Padding sa lijeve strane
              endIndent: 16, // Padding sa desne strane
            ),
            // Bijela linija
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16), // Padding sa lijeve i desne strane
              leading: const Icon(Icons.home),
              title: const Text(
                "Početna",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('Home');
              },
            ),
            const Divider(
              color: Colors.white,
              indent: 16, // Padding sa lijeve strane
              endIndent: 16, // Padding sa desne strane
            ),

            ListTile(
              contentPadding:const  EdgeInsets.symmetric(
                  horizontal: 16), // Padding sa lijeve i desne strane
              leading: const Icon(Icons.person),
              title: const Text(
                "Profil",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('Profil');
              },
            ),
            const Divider(
              color: Colors.white,
              indent: 16, // Padding sa lijeve strane
              endIndent: 16, // Padding sa desne strane
            ),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16), // Padding sa lijeve i desne strane
              leading: const Icon(Icons.hotel),
              title: const Text(
                "Hotel",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('HotelListPage');
              },
            ),
            const Divider(
              color: Colors.white,
              indent: 16, // Padding sa lijeve strane
              endIndent: 16, // Padding sa desne strane
            ),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16), // Padding sa lijeve i desne strane
              leading: const Icon(Icons.airplane_ticket),
              title: const Text(
                "Destinacija",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('DestinacijaListPage');
              },
            ),
            const Divider(
              color: Colors.white,
              indent: 16, // Padding sa lijeve strane
              endIndent: 16, // Padding sa desne strane
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16), // Padding sa lijeve i desne strane
              leading: const Icon(Icons.hotel),
              title: const Text(
                "Moje rezervacije",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('MojeRezervacijeScreen');
              },
            ),
            const Divider(
              color: Colors.white,
              indent: 16, // Padding sa lijeve strane
              endIndent: 16, // Padding sa desne strane
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16), // Padding sa lijeve i desne strane
              leading: const Icon(Icons.logout),
              title: const Text(
                "Odjava",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
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
