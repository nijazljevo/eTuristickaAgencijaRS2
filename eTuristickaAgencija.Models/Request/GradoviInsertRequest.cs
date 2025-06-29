using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class GradoviInsertRequest
    {
        public int Id { get; set; }
        [Required]
        public string Naziv { get; set; }
        [Required]
        public int DrzavaId { get; set; }
    }
}
