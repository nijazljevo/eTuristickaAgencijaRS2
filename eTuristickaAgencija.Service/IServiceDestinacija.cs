using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eTuristickaAgencija.Service
{
    
    public interface IServiceDestinacija<T, TSearch> where TSearch : class
    {
        IEnumerable<T> Get(TSearch search = null);
        Task<T> GetById(int id);
    }
}
