using eTuristickaAgencija.Models;
using eTuristickaAgencija.Models.Request;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eTuristickaAgencija.Models.Search_Objects;

namespace eTuristickaAgencija.Service
{
    public interface IKorisniciService : ICRUDService<Korisnik, KorisnikSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
       public Task<Models.Korisnik> Login(string username, string password);
    }

}
