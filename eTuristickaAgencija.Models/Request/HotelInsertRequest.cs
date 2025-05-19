using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;

namespace eTuristickaAgencija.Models.Request
{
    public class HotelInsertRequest
    {
        [Required]
        public string Naziv { get; set; }

        public IFormFile Slika { get; set; }

        [Required]
        public int GradId { get; set; }

        public int BrojZvjezdica { get; set; }
    }
}