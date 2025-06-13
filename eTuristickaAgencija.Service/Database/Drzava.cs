using System;
using System.Collections.Generic;

namespace eTuristickaAgencija.Service.Database;

public partial class Drzava
{
    public int Id { get; set; }

    public string Naziv { get; set; } = null!;

    public int? KontinentId { get; set; }

    public virtual ICollection<Grad> Grads { get; set; } = new List<Grad>();

    public virtual Kontinent? Kontinent { get; set; }
}
