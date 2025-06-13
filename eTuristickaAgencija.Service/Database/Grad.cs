using System;
using System.Collections.Generic;

namespace eTuristickaAgencija.Service.Database;

public partial class Grad
{
    public int Id { get; set; }

    public string Naziv { get; set; } = null!;

    public int? DrzavaId { get; set; }

    public virtual ICollection<Destinacija> Destinacijas { get; set; } = new List<Destinacija>();

    public virtual Drzava? Drzava { get; set; }

    public virtual ICollection<Hotel> Hotels { get; set; } = new List<Hotel>();

    public virtual ICollection<Termin> Termins { get; set; } = new List<Termin>();
}
