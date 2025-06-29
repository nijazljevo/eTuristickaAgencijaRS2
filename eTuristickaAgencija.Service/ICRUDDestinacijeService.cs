using eTuristickaAgencija.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eTuristickaAgencija.Service
{
    public interface ICRUDDestinacijeService<T, TSearch, TInsert, TUpdate> : IServiceDestinacija<T, TSearch> where TSearch : class
    {
        List<Destinacija> GetPreporucenaDestinacija(int korisnikId);
        Task<T> Insert(TInsert insert);
        Task<T> Update(int id, TUpdate update);
        Task<T> Delete (int id);
    }

}
