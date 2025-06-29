using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models
{
    public class Uplata
    {
        public int Id { get; set; }
        public decimal Iznos { get; set; }
        public string BrojTransakcije { get; set; }
        public DateTime DatumTransakcije { get; set; }
        public int KorisnikId { get; set; }
    }
}
