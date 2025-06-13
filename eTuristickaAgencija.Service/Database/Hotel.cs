using System;
using System.Collections.Generic;

namespace eTuristickaAgencija.Service.Database;

public partial class Hotel
{
    public int Id { get; set; }

    public byte[]? Slika { get; set; }

    public string Naziv { get; set; } = null!;

    public int? GradId { get; set; }

    public int? BrojZvjezdica { get; set; }

    public virtual Grad? Grad { get; set; }

    public virtual ICollection<Rezervacija> Rezervacijas { get; set; } = new List<Rezervacija>();

    public virtual ICollection<Termin> Termins { get; set; } = new List<Termin>();
}
