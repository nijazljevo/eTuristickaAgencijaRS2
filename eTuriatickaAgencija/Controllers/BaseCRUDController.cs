using eTuristickaAgencija.Service;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eTuriatickaAgencija.Controllers
{
    [Authorize]
    public class BaseCRUDController<T, TSearch, TInsert, TUpdate> : BaseController<T, TSearch>
        where T : class where TSearch : class
    {
        protected new readonly ICRUDService<T, TSearch, TInsert, TUpdate> _service;
        protected readonly ILogger<BaseController<T, TSearch>> _logger;

        public BaseCRUDController(ILogger<BaseController<T, TSearch>> logger, ICRUDService<T, TSearch, TInsert, TUpdate> service) : base(logger, service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpPost]
        public virtual T Insert([FromBody] TInsert insert)
        {
            var results = ((ICRUDService<T, TSearch, TInsert, TUpdate>)this.Service).Insert(insert);
            return results;
        }

        [HttpPost("form")]
        public virtual async Task<T> InsertFromFormAsync([FromForm] TInsert insert)
        {
            var results = await ((ICRUDService<T, TSearch, TInsert, TUpdate>)this.Service).InsertAsync(insert);
            return results;
        }

        [HttpPut("form")]
        public virtual async Task<T> UpdateFromFormAsync([FromForm] TUpdate update)
        {
            var results = await ((ICRUDService<T, TSearch, TInsert, TUpdate>)this.Service).UpdateAsync(update);
            return results;
        }

        [HttpPut("{id}")]
        public virtual T Update(int id, [FromBody] TUpdate update)
        {
            var results = ((ICRUDService<T, TSearch, TInsert, TUpdate>)this.Service).Update(id, update);
            return results;
        }

        [HttpDelete("{id}")]
        public virtual T Delete(int id)
        {
            var results = ((ICRUDService<T, TSearch, TInsert, TUpdate>)this.Service).Delete(id);
            return results;
        }
    }
}