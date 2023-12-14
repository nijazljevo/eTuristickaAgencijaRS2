using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class DestinacijaUpdateRequest
    {
        
        public string Naziv { get; set; }
        
        public int? GradId { get; set; }
        public byte[] Slika { get; set; }
    }
}
