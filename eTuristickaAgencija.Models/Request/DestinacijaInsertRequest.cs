using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class DestinacijaInsertRequest
    {
        [Required]
        public string Naziv { get; set; }
        
        public byte[] Slika { get; set; }
        [Required]
        public int? GradId { get; set; }
    }
}
