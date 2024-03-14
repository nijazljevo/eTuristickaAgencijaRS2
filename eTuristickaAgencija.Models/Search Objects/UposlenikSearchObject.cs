using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models.Search_Objects
{
    public class UposlenikSearchObject : BaseSearchObject
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public bool Aktivan { get; set; }
        public DateTime DatumZaposlenja { get; set; }



    }
}
