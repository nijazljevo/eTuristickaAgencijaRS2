using AutoMapper;
using eTuristickaAgencija.Models;
using eTuristickaAgencija.Models.Request;
using eTuristickaAgencija.Models.Search_Objects;
using eTuristickaAgencija.Service.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eTuristickaAgencija.Service
{
     public class OcjeneService
       : BaseCRUDService<Models.Ocjena, Database.Ocjena, OcjenaSearchObject, OcjenaInsertRequest, OcjenaUpdateRequest>, IOcjenaService
    {

        public OcjeneService(TuristickaAgencijaContext eContext, IMapper mapper) : base(eContext, mapper)
        {
        }

        public override IQueryable<Database.Ocjena> AddFilter(IQueryable<Database.Ocjena> query, OcjenaSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.Id != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.Id == search.Id);
            }


           
           

            return filteredQuery;
        }
    }
}
