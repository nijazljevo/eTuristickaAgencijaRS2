using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models
{
    public class Clan
    {
        public int Id { get; set; }
        public int? KorisnikId { get; set; }
        public DateTime? DatumRegistracije { get; set; }
    }
}
