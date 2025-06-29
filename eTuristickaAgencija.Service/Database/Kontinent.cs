using System;
using System.Collections.Generic;

namespace eTuristickaAgencija.Service.Database;

public partial class Kontinent
{
    public int Id { get; set; }

    public string Naziv { get; set; } = null!;

    public virtual ICollection<Drzava> Drzavas { get; set; } = new List<Drzava>();
}
