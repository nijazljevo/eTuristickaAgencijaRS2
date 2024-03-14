import 'package:eturistickaagencija_admin/models/agencija.dart';
import 'package:eturistickaagencija_admin/providers/base_provider.dart';



class AgencijaProvider extends BaseProvider<Agencija>{
  AgencijaProvider():super("Agencija");

  @override
  Agencija fromJson(data) {
    // TODO: implement fromJson
    return Agencija.fromJson(data);
  }

}