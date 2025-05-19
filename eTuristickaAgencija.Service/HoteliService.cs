using AutoMapper;
using eTuristickaAgencija.Models.Request;
using eTuristickaAgencija.Models.Search_Objects;
using eTuristickaAgencija.Service.Database;

namespace eTuristickaAgencija.Service
{
    public class HoteliService
      : BaseCRUDService<Models.Hotel, Hotel, HotelSearchObject, HotelInsertRequest, HotelUpdateRequest>, IHotelService
    {
        private readonly TuristickaAgencijaContext _context;

        public HoteliService(TuristickaAgencijaContext eContext, IMapper mapper) : base(eContext, mapper)
        {
            _context = eContext;
        }

        public override async Task<Models.Hotel> InsertAsync(HotelInsertRequest insert)
        {
            using var memoryStream = new MemoryStream();
            await insert.Slika.CopyToAsync(memoryStream);

            Models.Hotel hotel = new()
            {
                Naziv = insert.Naziv,
                GradId = insert.GradId,
                Slika = memoryStream.ToArray(),
                BrojZvjezdica = insert.BrojZvjezdica
            };

            await _context.AddAsync(hotel);

            await _context.SaveChangesAsync();

            return hotel;
        }

        public override IQueryable<Hotel> AddFilter(IQueryable<Hotel> query, HotelSearchObject search = null)
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
            if (search?.GradId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.GradId == search.GradId);
            }

            return filteredQuery;
        }
    }
}