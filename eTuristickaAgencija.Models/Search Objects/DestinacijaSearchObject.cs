using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models.Search_Objects
{
    public class DestinacijaSearchObject : BaseSearchObject
    {
        public int Id { get; set; }
        public string Naziv { get; set; }

        public int? GradId { get; set; }



    }
}
