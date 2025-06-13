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
       public interface IDestinacijaService : ICRUDDestinacijeService<Destinacija, DestinacijaSearchObject, DestinacijaInsertRequest, DestinacijaUpdateRequest>
    {
        Task<Destinacija> Activate(int id);
        Task<Destinacija> Hide(int id);
        Task<List<string>> AllowedActions(int id);
        List<Destinacija> GetPreporucenaDestinacija(int id);
    }
}
