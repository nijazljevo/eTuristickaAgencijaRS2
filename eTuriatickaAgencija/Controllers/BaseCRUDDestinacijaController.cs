using eTuristickaAgencija.Service;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eTuriatickaAgencija.Controllers
{
    [Route("[controller]")]
    public class BaseCRUDDestinacijaController<T, TSearch, TInsert, TUpdate> : BaseDestinacijaController<T, TSearch> where T : class where TSearch : class
    {
        protected new readonly ICRUDDestinacijeService<T, TSearch, TInsert, TUpdate> _service;
        protected readonly ILogger<BaseDestinacijaController<T, TSearch>> _logger;

        public BaseCRUDDestinacijaController(ILogger<BaseDestinacijaController<T, TSearch>> logger, ICRUDDestinacijeService<T, TSearch, TInsert, TUpdate> service)
            : base(logger, service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpPost]
        public virtual async Task<T> Insert([FromBody] TInsert insert)
        {
            return await _service.Insert(insert);
        }

        [HttpPut("{id}")]
        public virtual async Task<T> Update(int id, [FromBody] TUpdate update)
        {
            return await _service.Update(id, update);
        }

    }
}
