using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models.Search_Objects
{
    public class TerminSearchObject : BaseSearchObject
    {
        public int Id { get; set; }

        public int DestinacijaId { get; set; }


        public decimal Cijena { get; set; }


        public int HotelId { get; set; }

        public bool AktivanTermin { get; set; }

        public DateTime DatumPolaska { get; set; }

        public DateTime DatumDolaska { get; set; }
        public int GradId { get; set; }



    }
}
