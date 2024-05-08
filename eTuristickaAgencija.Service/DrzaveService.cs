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
     public class DrzaveService
       : BaseCRUDService<Models.Drzava, Database.Drzava, DrzavaSearchObject, DrzavaInsertRequest, DrzavaUpdateRequest>, IDrzavaService
    {

        public DrzaveService(TuristickaAgencijaContext eContext, IMapper mapper) : base(eContext, mapper)
        {
        }

        public override IQueryable<Database.Drzava> AddFilter(IQueryable<Database.Drzava> query, DrzavaSearchObject search=null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.Id != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.Id == search.Id);
            }


            if (!string.IsNullOrEmpty(search?.Naziv))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv == search.Naziv);
            }
           
            

            return filteredQuery;
        }
    }
}
