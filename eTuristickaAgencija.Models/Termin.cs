using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models
{
    public class Termin
    {
        public int Id { get; set; }
        public int? DestinacijaId { get; set; }
        public decimal Cijena { get; set; }
        public float? Popust { get; set; }
        public int? HotelId { get; set; }
        public decimal CijenaPopust { get; set; }
        public bool AktivanTermin { get; set; }
        public DateTime DatumPolaska { get; set; }
        public DateTime DatumDolaska { get; set; }
        public int? GradId { get; set; }
    }
}
