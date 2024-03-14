using System;
using System.Collections.Generic;
using System.Text;

namespace eTuristickaAgencija.Models.Search_Objects
{
    public class KorisnikSearchObject : BaseSearchObject
    {
        public int Id { get; set; }
        public string Ime { get; set; }
        public string Prezime { get; set; }
        public string Email { get; set; }
        public string KorisnikoIme { get; set; }
       


    }
}
