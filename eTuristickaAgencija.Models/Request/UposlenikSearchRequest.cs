using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class UposlenikSearchRequest
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }

        public bool Aktivan { get; set; }

        public DateTime? DatumZaposlenja { get; set; }
    }
}
