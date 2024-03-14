using System;
using System.Collections.Generic;

namespace eTuristickaAgencija.Service.Database;

public partial class Kartum
{
    public int Id { get; set; }

    public int? TerminId { get; set; }

    public DateTime DatumKreiranja { get; set; }

    public bool Ponistena { get; set; }

    public int? KorisnikId { get; set; }

    public virtual Korisnik? Korisnik { get; set; }

    public virtual Termin? Termin { get; set; }
}
