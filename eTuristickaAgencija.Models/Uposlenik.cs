using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models
{
    public class Uposlenik
    {
        public int Id { get; set; }
        public int? KorisnikId { get; set; }
        public DateTime DatumZaposlenja { get; set; }
        public bool? Aktivan { get; set; }
    }
}
