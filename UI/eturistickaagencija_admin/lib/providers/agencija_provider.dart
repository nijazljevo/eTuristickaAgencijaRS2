import 'package:eturistickaagencija_admin/models/agencija.dart';
import 'package:eturistickaagencija_admin/providers/base_provider.dart';



class AgencijaProvider extends BaseProvider<Agencija>{
  AgencijaProvider():super("Agencija");

  @override
  Agencija fromJson(data) {
    // TODO: implement fromJson
    return Agencija.fromJson(data);
  }
Future<void> deleteAgencija(int id) async {
  try {
    await delete(id);
  } catch (e) {
    throw Exception("Greška prilikom brisanja agencije: $e");
  }
}
}