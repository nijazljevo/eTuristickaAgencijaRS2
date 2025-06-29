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

        public DateTime CheckIn { get; set; }

        [Required]
        public DateTime CheckOut { get; set; }

        [Required]
        [Range(1, 10)]
        public int BrojOsoba { get; set; }

        [Required]
        [StringLength(50)]
        public string TipSobe { get; set; }

        public int? KorisnikId { get; set; }
    }
}