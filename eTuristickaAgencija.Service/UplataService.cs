using AutoMapper;
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
    public class UplataService
       : BaseCRUDService<Models.Uplata, Uplate, UplataSearchObject, UplataInsertRequest, UplataUpdateRequest>, IUplataService
    {

        public UplataService(TuristickaAgencijaContext eContext, IMapper mapper) : base(eContext, mapper)
        {
        }

        public override IQueryable<Uplate> AddFilter(IQueryable<Uplate> query, UplataSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.Id != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.Id == search.Id);
            }


            if (!string.IsNullOrEmpty(search?.BrojTransakcije))
            {
                filteredQuery = filteredQuery.Where(x => x.BrojTransakcije == search.BrojTransakcije);
            }
            if (search?.KorisnikId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnikId == search.KorisnikId);
            }
           

            return filteredQuery;
        }
    }
}
