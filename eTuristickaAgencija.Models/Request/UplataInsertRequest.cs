using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class UplataInsertRequest
    {
        public double Iznos { get; set; }
        public DateTime DatumTransakcije { get; set; }
        public string BrojTransakcije { get; set; }
        public int KorisnikId { get; set; }
    }
}
