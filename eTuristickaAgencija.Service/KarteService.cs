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
    public class KarteService
       : BaseCRUDService<Models.Karta, Kartum, KartaSearchObject, KartaInsertRequest, KartaUpdateRequest>, IKartaService
    {

        public KarteService(TuristickaAgencijaContext eContext, IMapper mapper) : base(eContext, mapper)
        {
        }

        public override IQueryable<Kartum> AddFilter(IQueryable<Kartum> query, KartaSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.Id != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.Id == search.Id);
            }


           /* if (!string.IsNullOrEmpty(search?.Ponistena))
            {
                filteredQuery = filteredQuery.Where(x => x.Ponistena == search.Ponistena);
            }*/
            if (search.TerminId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.TerminId == search.TerminId);
            }
            if (search.KorisnikId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnikId == search.KorisnikId);
            }

            return filteredQuery;
        }
    }
}
