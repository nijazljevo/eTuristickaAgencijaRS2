
import 'package:eturistickaagencija_admin/providers/base_provider.dart';
import '../models/korisnik.dart';

class KorisnikProvider extends BaseProvider<Korisnik>{
  KorisnikProvider():super("Korisnici");

  @override
  Korisnik fromJson(data) {
    // TODO: implement fromJson
    return Korisnik.fromJson(data);
  }
   Future<bool> checkDuplicate(String korisnickoIme) async {
    try {
      var result = await get(filter: {"korisnikoIme": korisnickoIme});
      return result.result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}