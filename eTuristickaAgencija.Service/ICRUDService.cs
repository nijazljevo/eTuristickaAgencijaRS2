using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eTuristickaAgencija.Service
{
    public interface ICRUDService<T, TSearch, TInsert, TUpdate> : IService<T, TSearch> where TSearch : class
    {
        T Insert(TInsert insert);
        T Update(int id, TUpdate update);
        T Delete (int id);
    }
}
