using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class ClanUpdateRequest
    {

        public int? KorisnikId { get; set; }
        public DateTime? DatumRegistracije { get; set; }
    }
}
