using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models
{

    public class Rezervacija
    {
        public int Id { get; set; }
        public decimal Cijena { get; set; }
        public int? HotelId { get; set; }
        public bool? Otkazana { get; set; }
        public DateTime DatumRezervacije { get; set; }
        public int? KorisnikId { get; set; }

        public static implicit operator List<object>(Rezervacija v)
        {
            throw new NotImplementedException();
        }
    }
}
