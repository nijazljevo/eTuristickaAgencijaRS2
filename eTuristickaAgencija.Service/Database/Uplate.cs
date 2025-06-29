using System;
using System.Collections.Generic;

namespace eTuristickaAgencija.Service.Database;

public partial class Uplate
{
    public int Id { get; set; }

    public decimal? Iznos { get; set; }

    public int? KorisnikId { get; set; }

    public DateTime? DatumTransakcije { get; set; }

    public string? BrojTransakcije { get; set; }

    public virtual Korisnik? Korisnik { get; set; }
}
