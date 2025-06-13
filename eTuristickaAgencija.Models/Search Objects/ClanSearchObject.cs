using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models.Search_Objects
{
    public class ClanSearchObject : BaseSearchObject
    {
        public int Id { get; set; }
        public int? KorisnikId { get; set; }
        public DateTime? DatumRegistracije { get; set; }



    }
}
