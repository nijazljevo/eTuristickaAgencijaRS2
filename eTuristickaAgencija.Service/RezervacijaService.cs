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
    public class RezervacijaService
       : BaseCRUDService<Models.Rezervacija, Database.Rezervacija, RezervacijaSearchObject, RezervacijaInsertRequest, RezervacijaUpdateRequest>, IRezervacijaService
    {
        private readonly TuristickaAgencijaContext _context;

        public RezervacijaService(TuristickaAgencijaContext eContext, IMapper mapper) : base(eContext, mapper)
        {
            _context = eContext;
        }

        public override IQueryable<Database.Rezervacija> AddFilter(IQueryable<Database.Rezervacija> query, RezervacijaSearchObject search=null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.Id != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.Id == search.Id);
            }
            if (search?.Otkazana != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Otkazana == search.Otkazana);
            }


            if (search.Cijena != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.Cijena == search.Cijena);
            }

            return filteredQuery;
        }

        public async Task<bool> CancelReservation(int rezervacijaId)
        {
            var rezervacija = await _context.FindAsync<Database.Rezervacija>(rezervacijaId);
            if (rezervacija == null)
            {
                throw new Exception("Rezervacija not found");
            }

            if (rezervacija.CheckIn.Subtract(DateTime.Now).Days >= 7)
                rezervacija.Otkazana = true;
            else
                return false;

            await _context.SaveChangesAsync();

            return true;
        }
    }
}
     