using System;
using System.Collections.Generic;

namespace eTuristickaAgencija.Service.Database;

public partial class Uposlenik
{
    public int Id { get; set; }

    public int? KorisnikId { get; set; }

    public DateTime? DatumZaposlenja { get; set; }

    public bool? Aktivan { get; set; }

    public virtual Korisnik? Korisnik { get; set; }
}
