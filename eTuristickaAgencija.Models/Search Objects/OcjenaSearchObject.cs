using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models.Search_Objects
{
    public class OcjenaSearchObject : BaseSearchObject
    {
        public int Id { get; set; }
        public int? KorisnikId { get; set; }
        public int? DestinacijaId { get; set; }
        public int OcjenaUsluge { get; set; }
        public string Komentar { get; set; }



    }
}
