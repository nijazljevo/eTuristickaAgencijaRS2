using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class TerminInsertRequest
    {
        public int Id { get; set; }
        [Required]
        public int DestinacijaId { get; set; }
        [Required]
        [Range(0, 10000)]
        public decimal Cijena { get; set; }
        public float? Popust { get; set; }
        [Required]
        public int HotelId { get; set; }
        public decimal? CijenaPopust { get; set; }
        [Required]
        public bool AktivanTermin { get; set; }
        [Required]
        public DateTime DatumPolaska { get; set; }
        [Required]
        public DateTime DatumDolaska { get; set; }
        public int GradId { get; set; }
    }
}
