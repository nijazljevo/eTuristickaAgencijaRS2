using System;
using System.Collections.Generic;

namespace eTuristickaAgencija.Service.Database;

public partial class Clan
{
    public int Id { get; set; }

    public int? KorisnikId { get; set; }

    public DateTime? DatumRegistracije { get; set; }

    public virtual Korisnik? Korisnik { get; set; }
}
