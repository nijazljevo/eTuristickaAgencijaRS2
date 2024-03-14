using AutoMapper;
using eTuristickaAgencija.Models.Request;
using eTuristickaAgencija.Models.Search_Objects;
using eTuristickaAgencija.Service.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace eTuristickaAgencija.Service
{
    public class AgencijaService
       : BaseCRUDService<Models.Agencija, Agencija, AgencijaSearchObject, AgencijaInsertRequest, AgencijaUpdateRequest>, IAgencijaService
    {

        public AgencijaService(TuristickaAgencijaContext eContext, IMapper mapper) : base(eContext, mapper)
        {
        }

        public override IQueryable<Agencija> AddFilter(IQueryable<Agencija> query, AgencijaSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.Id != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.Id == search.Id);
            }


            if (!string.IsNullOrEmpty(search?.Email))
            {
                filteredQuery = filteredQuery.Where(x => x.Email == search.Email);
            }
            if (!string.IsNullOrEmpty(search?.Adresa))
            {
                filteredQuery = filteredQuery.Where(x => x.Adresa == search.Adresa);
            }
            if (!string.IsNullOrEmpty(search?.Telefon))
            {
                filteredQuery = filteredQuery.Where(x => x.Telefon == search.Telefon);
            }

            return filteredQuery;
        }
    }

}