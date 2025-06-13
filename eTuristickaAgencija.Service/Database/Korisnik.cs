using System;
using System.Collections.Generic;

namespace eTuristickaAgencija.Service.Database;

public partial class Korisnik
{
    public int Id { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string KorisnikoIme { get; set; } = null!;

    public string LozinkaHash { get; set; } = null!;

    public string LozinkaSalt { get; set; } = null!;

    public byte[]? Slika { get; set; }

    public string? Email { get; set; }

    public int? UlogaId { get; set; }

    public virtual ICollection<Clan> Clans { get; set; } = new List<Clan>();

    public virtual ICollection<Kartum> Karta { get; set; } = new List<Kartum>();

    public virtual ICollection<Ocjena> Ocjenas { get; set; } = new List<Ocjena>();

    public virtual ICollection<Rezervacija> Rezervacijas { get; set; } = new List<Rezervacija>();

    public virtual Uloga? Uloga { get; set; }

    public virtual ICollection<Uplate> Uplates { get; set; } = new List<Uplate>();

    public virtual ICollection<Uposlenik> Uposleniks { get; set; } = new List<Uposlenik>();
}
