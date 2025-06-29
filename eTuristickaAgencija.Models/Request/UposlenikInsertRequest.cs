using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class UposlenikInsertRequest
    {

        [Required]
        public int KorisnikId { get; set; }
        [Required]
        public bool Aktivan { get; set; }
        [Required]
        public DateTime DatumZaposlenja { get; set; }
    }
}
