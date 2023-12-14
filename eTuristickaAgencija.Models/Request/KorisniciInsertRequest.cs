using Microsoft.EntityFrameworkCore.Storage;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class KorisniciInsertRequest
    {
        public int Id { get; set; }
        
        public byte[] Slika { get; set; }
        [Required]
        public string Ime { get; set; }
        [Required]
        
        public string Prezime { get; set; }
        [Required]
        
        public string KorisnikoIme { get; set; }
        [EmailAddress(ErrorMessage ="Email adresa format")]
        public string Email { get; set; }
        [Required]
        public int? UlogaId { get; set; }
        [Required(AllowEmptyStrings = false)]
       
        public string Password { get; set; }
        [Required(AllowEmptyStrings =false)]
        public string PasswordPotvrda { get; set; }
    }
}
