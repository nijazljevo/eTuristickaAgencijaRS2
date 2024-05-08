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
  
    public class ClanoviService
       : BaseCRUDService<Models.Clan, Clan, ClanSearchObject, ClanInsertRequest, ClanUpdateRequest>, IClanService
    {

        public ClanoviService(TuristickaAgencijaContext eContext, IMapper mapper) : base(eContext, mapper)
        {
        }

        public override IQueryable<Clan> AddFilter(IQueryable<Clan> query, ClanSearchObject search=null )
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.Id != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.Id == search.Id);
            }


            if (search?.DatumRegistracije != null)
            {
                filteredQuery = filteredQuery.Where(x => x.DatumRegistracije.Value <= search.DatumRegistracije.Value);
            }

            return filteredQuery;
        }
    }
}
