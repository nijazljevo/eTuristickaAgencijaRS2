using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models
{
    public class Grad
    {
        public int Id { get; set; }
        public string Naziv { get; set; }
        public int? DrzavaId { get; set; }
    }
}
