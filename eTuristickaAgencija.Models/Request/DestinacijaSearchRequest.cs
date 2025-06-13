using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class DestinacijaSearchRequest
    {
        public int Id { get; set; }
        public string Naziv { get; set; }
        public int? GradId { get; set; }
    }
}
