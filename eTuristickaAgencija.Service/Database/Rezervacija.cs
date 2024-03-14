using System;
using System.Collections.Generic;

namespace eTuristickaAgencija.Service.Database;

public partial class Rezervacija
{
    public int Id { get; set; }

    public decimal Cijena { get; set; }

    public int? HotelId { get; set; }

    public bool? Otkazana { get; set; }

    public DateTime DatumRezervacije { get; set; }

    public int? KorisnikId { get; set; }

    public virtual Hotel? Hotel { get; set; }

    public virtual Korisnik? Korisnik { get; set; }
}
