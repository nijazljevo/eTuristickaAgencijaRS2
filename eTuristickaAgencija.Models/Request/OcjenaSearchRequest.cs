using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class OcjenaSearchRequest
    {
        public int Id { get; set; }
        public int DestinacijaID { get; set; }
        public int KorisnikID { get; set; }
        //public int OcjenaUsluge { get; set; }
        //public string Komentar { get; set; }
    }
}
