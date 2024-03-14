using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class RezervacijaUpdateRequest
    {
        [Range(0, 10000)]
        public decimal Cijena { get; set; }
        
        public int? HotelId { get; set; }
        
        public bool? Otkazana { get; set; }
       
        public DateTime DatumRezervacije { get; set; }
      
        public int? KorisnikId { get; set; }
    }
}
