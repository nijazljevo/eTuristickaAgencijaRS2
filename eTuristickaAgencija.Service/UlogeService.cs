using AutoMapper;
using eTuristickaAgencija.Models.Search_Objects;
using eTuristickaAgencija.Service.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eTuristickaAgencija.Service
{
    public class UlogeService : BaseService<Models.Uloga, Uloga, UlogaSearchObject>, IUlogeService
    {
        public UlogeService(TuristickaAgencijaContext eContext, IMapper mapper) : base(eContext, mapper)
        {
        }
        public override IQueryable<Database.Uloga> AddFilter(IQueryable<Database.Uloga> query, UlogaSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);
            if (!string.IsNullOrEmpty(search?.Naziv))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv == search.Naziv);
            }
            return filteredQuery;
        }
    }
}
