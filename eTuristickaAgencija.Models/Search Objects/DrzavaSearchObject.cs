using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models.Search_Objects
{
    public class DrzavaSearchObject : BaseSearchObject
    {
        public int Id { get; set; }
        public string Naziv { get; set; }

        public int? KontinentId { get; set; }



    }
}
