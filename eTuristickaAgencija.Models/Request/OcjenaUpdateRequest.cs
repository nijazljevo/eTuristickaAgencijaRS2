using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class OcjenaUpdateRequest
    {
        
        public int? KorisnikId{ get; set; }
        public int? DestinacijaId { get; set; }
        [Range(1, 5, ErrorMessage = "Ocjena mora biti između 1 i 5.")]
        public int OcjenaUsluge { get; set; }
        public string Komentar { get; set; }
    }
}
