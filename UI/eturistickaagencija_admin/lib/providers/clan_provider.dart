
import 'package:eturistickaagencija_admin/models/clan.dart';
import 'package:eturistickaagencija_admin/providers/base_provider.dart';


class ClanProvider extends BaseProvider<Clan>{
  ClanProvider():super("Clanovi");

  @override
  Clan fromJson(data) {
    // TODO: implement fromJson
    return Clan.fromJson(data);
  }
  Future<void> deleteClan(int id) async {
  try {
    await delete(id);
  } catch (e) {
    throw Exception("Greška prilikom brisanja clana: $e");
  }
}
}