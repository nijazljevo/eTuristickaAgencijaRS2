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
    public class TerminiService
       : BaseCRUDService<Models.Termin, Termin, TerminSearchObject, TerminInsertRequest, TerminUpdateRequest>, ITerminService
    {

        public TerminiService(TuristickaAgencijaContext eContext, IMapper mapper) : base(eContext, mapper)
        {
        }

        public override IQueryable<Termin> AddFilter(IQueryable<Termin> query, TerminSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.Id != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.Id == search.Id);
            }
            if (search.Cijena != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.Cijena == search.Cijena);
            }
            if (search.HotelId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.HotelId == search.HotelId);
            }
            if (search.GradId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.GradId == search.GradId);
            }

            return filteredQuery;
        }
    }
}
