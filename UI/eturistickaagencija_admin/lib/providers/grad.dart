
import 'package:eturistickaagencija_admin/models/grad.dart';
import 'package:eturistickaagencija_admin/providers/base_provider.dart';


class GradProvider extends BaseProvider<Grad>{
  GradProvider():super("Gradovi");

  @override
  Grad fromJson(data) {
    // TODO: implement fromJson
    return Grad.fromJson(data);
  }
   Future<bool> checkDuplicate(String naziv) async {
    try {
      var result = await get(filter: {"naziv": naziv});
      return result.result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  Future<void> deleteGrad(int id) async {
  try {
    await delete(id);
  } catch (e) {
    throw Exception("Greška prilikom brisanja grada: $e");
  }
}

}