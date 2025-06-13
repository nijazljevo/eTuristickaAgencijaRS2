using System;
using System.Collections.Generic;

namespace eTuristickaAgencija.Service.Database;

public partial class Destinacija
{
    public int Id { get; set; }

    public byte[]? Slika { get; set; }

    public string Naziv { get; set; } = null!;

    public int? GradId { get; set; }

    public string? StateMachine { get; set; }

    public virtual Grad? Grad { get; set; }

    public virtual ICollection<Ocjena> Ocjenas { get; set; } = new List<Ocjena>();

    public virtual ICollection<Termin> Termins { get; set; } = new List<Termin>();
}
