using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class UposlenikUpdateRequest
    {

        public int KorisnikId { get; set; }
       
        public bool Aktivan { get; set; }
        
        public DateTime DatumZaposlenja { get; set; }
    }
}
