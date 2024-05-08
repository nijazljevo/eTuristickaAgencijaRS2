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
    public class GradoviService
       : BaseCRUDService<Models.Grad, Database.Grad, GradSearchObject, GradoviInsertRequest, GradoviUpdateRequest>, IGradService
    {

        public GradoviService(TuristickaAgencijaContext eContext, IMapper mapper) : base(eContext, mapper)
        {
        }

        public override IQueryable<Grad> AddFilter(IQueryable<Grad> query, GradSearchObject search=null)
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
            if (search.DrzavaId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.DrzavaId == search.DrzavaId);
            }

            return filteredQuery;
        }
    }
}
