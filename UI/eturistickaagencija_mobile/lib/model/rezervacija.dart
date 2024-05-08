class Rezervacije {
  final int? id;
  int hotelId;
  int korisnikId;
  DateTime datumRezervacije;
  bool otkazana;
  double cijena;

  Rezervacije({
    this.id,
    required this.hotelId,
    required this.korisnikId,
    required this.datumRezervacije,
     required this.otkazana,
    required this.cijena,
  });
 factory Rezervacije.fromJson(Map<String, dynamic> json) {
  return Rezervacije(
    id: json['id'],
    korisnikId: json['korisnikId'],
    hotelId: json['hotelId'],
    otkazana: json['otkazana'],
    cijena: json['cijena'],
    datumRezervacije: DateTime.parse(json['datumRezervacije']), 
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'hotelId': hotelId,
      'korisnikId': korisnikId,
      'datumRezervacije': datumRezervacije.toIso8601String(),
      'otkazana': otkazana,
      'cijena': cijena,
    };
  }
}
