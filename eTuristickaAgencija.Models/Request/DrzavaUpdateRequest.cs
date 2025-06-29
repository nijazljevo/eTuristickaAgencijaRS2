using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class DrzavaUpdateRequest
    {
       
        public string Naziv { get; set; }
        
        public int? KontinentId { get; set; }
    }
}
