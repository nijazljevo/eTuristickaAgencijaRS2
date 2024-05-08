
import 'package:eturistickaagencija_admin/models/drzava.dart';
import 'package:eturistickaagencija_admin/providers/base_provider.dart';



class DrzavaProvider extends BaseProvider<Drzava>{
  DrzavaProvider():super("Drzave");

  @override
  Drzava fromJson(data) {
    // TODO: implement fromJson
    return Drzava.fromJson(data);
  }
  Future<bool> checkDuplicate(String naziv) async {
    try {
      var result = await get(filter: {"naziv": naziv});
      return result.result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
   Future<void> deleteDrzava(int id) async {
  try {
    await delete(id);
  } catch (e) {
    throw Exception("Greška prilikom brisanja drzave: $e");
  }
}

}