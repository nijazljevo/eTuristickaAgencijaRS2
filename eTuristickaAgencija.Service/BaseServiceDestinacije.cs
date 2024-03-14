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
    
       public class BaseServiceDestinacije<T, TDb, TSearch> : IServiceDestinacija<T, TSearch> where TDb : class where T : class where TSearch : BaseSearchObject
    {
        protected TuristickaAgencijaContext _context;
        protected IMapper _mapper { get; set; }
        public BaseServiceDestinacije(TuristickaAgencijaContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public virtual IEnumerable<T> Get(TSearch? search = null)
        {
            var entity = _context.Set<TDb>().AsQueryable();
            entity = AddFilter(entity, search);
          
            var list = entity.ToList();

            return _mapper.Map<IEnumerable<T>>(list);
        }


        public virtual IQueryable<TDb> AddInclude(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }

        public virtual IQueryable<TDb> AddFilter(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }

        public virtual async Task<T> GetById(int id)
        {
            var entity = await _context.Set<TDb>().FindAsync(id);

            return _mapper.Map<T>(entity);
        }
    }
}
