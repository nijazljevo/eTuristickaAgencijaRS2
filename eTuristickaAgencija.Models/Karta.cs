using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models
{
    public class Karta
    {
        public int Id { get; set; }
        public int? TerminId { get; set; }
        public int? KorisnikId { get; set; }
        public DateTime DatumKreiranja { get; set; }
        public bool Ponistena { get; set; }
    }
}
