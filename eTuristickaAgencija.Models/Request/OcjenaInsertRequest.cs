using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class OcjenaInsertRequest
    {
        //public int Id { get; set; }
        public int? KorisnikId{ get; set; }
        public int? DestinacijaId { get; set; }
        [Required]
        [Range(1, 5, ErrorMessage = "Ocjena mora biti između 1 i 5.")]
        public int OcjenaUsluge { get; set; }

        public string Komentar { get; set; }
    }
}
