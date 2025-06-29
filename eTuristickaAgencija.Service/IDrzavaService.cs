using eTuristickaAgencija.Models.Request;
using eTuristickaAgencija.Models.Search_Objects;
using eTuristickaAgencija.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eTuristickaAgencija.Service
{
       public interface IDrzavaService : ICRUDService<Drzava, DrzavaSearchObject, DrzavaInsertRequest, DrzavaUpdateRequest>
    {
       
    }
}
