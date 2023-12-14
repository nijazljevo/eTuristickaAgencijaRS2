using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class KorisniciUpdateRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string Ime { get; set; }
        [Required(AllowEmptyStrings = false)]
        public string Prezime { get; set; }
         [Required(AllowEmptyStrings = false)]
         public string KorisnikoIme { get; set; }
         [Required(AllowEmptyStrings = false)]
        public string Email { get; set; }
        public byte[] Slika { get; set; }
    }
}
