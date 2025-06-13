class Ocjena {
  final int? id;
  final int? korisnikId;
  final int? destinacijaId;
  final int? ocjenaUsluge;
  final String? komentar;

  Ocjena({
    this.id,
    this.korisnikId,
    this.destinacijaId,
    this.ocjenaUsluge,
    this.komentar,
  });

  factory Ocjena.fromJson(Map<String, dynamic> json) {
    return Ocjena(
      id: json['id'],
      korisnikId: json['korisnikId'],
      destinacijaId: json['destinacijaId'],
      ocjenaUsluge: json['ocjenaUsluge'],
      komentar: json['komentar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'korisnikId': korisnikId,
      'destinacijaId': destinacijaId,
      'ocjenaUsluge': ocjenaUsluge,
      'komentar': komentar,
    };
  }
}
