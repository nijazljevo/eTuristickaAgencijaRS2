using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class RezervacijaInsertRequest
    {
        [Required]
        [Range(0,10000)]
        public decimal Cijena { get; set; }
        [Required]
        public int? HotelId { get; set; }
        [Required]
        public bool? Otkazana { get; set; }
        [Required]
        public DateTime DatumRezervacije { get; set; }
        [Required]
        public int? KorisnikId { get; set; }
    }
}
