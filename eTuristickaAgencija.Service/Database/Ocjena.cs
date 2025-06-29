using System;
using System.Collections.Generic;

namespace eTuristickaAgencija.Service.Database;

public partial class Ocjena
{
    public int Id { get; set; }

    public int OcjenaUsluge { get; set; }

    public string? Komentar { get; set; }

    public int? DestinacijaId { get; set; }

    public int? KorisnikId { get; set; }

    public virtual Destinacija? Destinacija { get; set; }

    public virtual Korisnik? Korisnik { get; set; }
}
