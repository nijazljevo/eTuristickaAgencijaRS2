using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class DrzavaInsertRequest
    {
       [Required]
        public string Naziv { get; set; }
        [Required]
        public int? KontinentId { get; set; }
    }
}
