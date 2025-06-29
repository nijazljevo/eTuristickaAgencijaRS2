using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class TerminUpdateRequest
    {
        
        
        public int DestinacijaId { get; set; }

        [Range(0, 10000)]
        public decimal Cijena { get; set; }
      public decimal Popust { get; set; }
       public decimal CijenaPopust { get; set; }
       
        public int HotelId { get; set; }
        
        public bool AktivanTermin { get; set; }
        
        public DateTime DatumPolaska { get; set; }
        
        public DateTime DatumDolaska { get; set; }
        public int GradId { get; set; }
    }
}
