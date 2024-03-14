using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Search_Objects
{
    public class HotelSearchObject : BaseSearchObject
    {
        public int Id { get; set; }
        public string Naziv { get; set; }
        public int GradId { get; set; }
        public int BrojZvjezdica { get; set; }



    }
}
