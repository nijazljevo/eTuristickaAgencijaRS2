import 'package:eturistickaagencija_admin/models/kontinent.dart';
import 'package:eturistickaagencija_admin/providers/base_provider.dart';

class KontinentProvider extends BaseProvider<Kontinent>{
  KontinentProvider():super("Kontinenti");

  @override
  Kontinent fromJson(data) {
    // Implementacija fromJson metode
    return Kontinent.fromJson(data);
  }

  Future<bool> checkDuplicate(String naziv) async {
    try {
      var result = await get(filter: {"naziv": naziv});
      return result.result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  Future<void> deleteKontinent(int id) async {
  try {
    await delete(id);
  } catch (e) {
    throw Exception("Greška prilikom brisanja kontinenta: $e");
  }
}

}
