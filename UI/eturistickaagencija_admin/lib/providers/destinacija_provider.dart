
import 'package:eturistickaagencija_admin/providers/base_provider.dart';

import '../models/destinacija.dart';



class DestinacijaProvider extends BaseProvider<Destinacija>{
  DestinacijaProvider():super("Destinacije");

  @override
  Destinacija fromJson(data) {
    // TODO: implement fromJson
    return Destinacija.fromJson(data);
  }
   Future<bool> checkDuplicate(String naziv) async {
    try {
      var result = await get(filter: {"naziv": naziv});
      return result.result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

}