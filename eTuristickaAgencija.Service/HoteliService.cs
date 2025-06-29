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
        private readonly IMapper _mapper;

        public HoteliService(TuristickaAgencijaContext eContext, IMapper mapper) : base(eContext, mapper)
        {
            _context = eContext;
            _mapper = mapper;
        }

        public override async Task<Models.Hotel> InsertAsync(HotelInsertRequest insert)
        {
            try
            {
                using var memoryStream = new MemoryStream();
                if (insert.Slika != null)
                    await insert.Slika.CopyToAsync(memoryStream);

                Hotel hotel = new()
                {
                    Naziv = insert.Naziv,
                    GradId = insert.GradId,
                    Slika = insert.Slika != null ? memoryStream.ToArray() : null,
                    BrojZvjezdica = insert.BrojZvjezdica
                };

                await _context.AddAsync(hotel);
                await _context.SaveChangesAsync();

                return _mapper.Map<Models.Hotel>(hotel);
            }
            catch (Exception ex)
            {
                // Log the exception or handle it appropriately
                throw new Exception($"Error inserting hotel: {ex.Message}", ex);
            }
        }

        public override async Task<Models.Hotel> UpdateAsync(HotelUpdateRequest update)
        {
            try
            {
                var hotel = await _context.Hotels.FindAsync(update.Id);
                if (hotel == null)
                {
                    throw new Exception("Hotel not found");
                }

                using var memoryStream = new MemoryStream();

                if (update.Slika != null)
                    await update.Slika.CopyToAsync(memoryStream);

                hotel.Naziv = update.Naziv;
                hotel.GradId = update.GradId;
                hotel.Slika = update.Slika != null ? memoryStream.ToArray() : null;
                hotel.BrojZvjezdica = update.BrojZvjezdica;

                _context.Hotels.Update(hotel);
                await _context.SaveChangesAsync();

                return _mapper.Map<Models.Hotel>(hotel);
            }
            catch (Exception ex)
            {
                throw new Exception($"Error updating hotel: {ex.Message}", ex);
            }
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
                filteredQuery = filteredQuery.Where(x => x.Naziv.Contains(search.Naziv));
            }
            if (search?.GradId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.GradId == search.GradId);
            }
            if (search?.BrojZvjezdica != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.BrojZvjezdica == search.BrojZvjezdica);
            }

            return filteredQuery;
        }
    }
}