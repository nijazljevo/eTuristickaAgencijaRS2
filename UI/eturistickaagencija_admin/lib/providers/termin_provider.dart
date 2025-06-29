
import 'package:eturistickaagencija_admin/models/termin.dart';
import 'package:eturistickaagencija_admin/providers/base_provider.dart';


class TerminProvider extends BaseProvider<Termin>{
  TerminProvider():super("Termini");

  @override
  Termin fromJson(data) {
    // TODO: implement fromJson
    return Termin.fromJson(data);
  }
  Future<void> deleteTermin(int id) async {
  try {
    await delete(id);
  } catch (e) {
    throw Exception("Greška prilikom brisanja termina: $e");
  }
}
}