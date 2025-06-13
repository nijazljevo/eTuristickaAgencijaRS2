
import 'package:eturistickaagencija_admin/models/uposlenik.dart';
import 'package:eturistickaagencija_admin/providers/base_provider.dart';


class UposlenikProvider extends BaseProvider<Uposlenik>{
  UposlenikProvider():super("Uposlenik");

  @override
  Uposlenik fromJson(data) {
    // TODO: implement fromJson
    return Uposlenik.fromJson(data);
  }
  Future<void> deleteUposlenik(int id) async {
  try {
    await delete(id);
  } catch (e) {
    throw Exception("Greška prilikom brisanja uposlenika: $e");
  }
}
}