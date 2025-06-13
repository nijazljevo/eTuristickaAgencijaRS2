using eTuristickaAgencija.Service;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Stripe;

namespace eTuriatickaAgencija.Controllers
{
    
    [Route("[controller]")]
    [Authorize]
    public class BaseDestinacijaController<T, TSearch> : ControllerBase where T : class where TSearch : class
    {
        protected readonly IServiceDestinacija<T, TSearch> _service;
        protected readonly ILogger<BaseDestinacijaController<T, TSearch>> _logger;

        public BaseDestinacijaController(ILogger<BaseDestinacijaController<T, TSearch>> logger, IServiceDestinacija<T, TSearch> service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpGet]
        public IEnumerable<T> Get([FromQuery] TSearch search = null)
        {
            return _service.Get(search);
        }

        [HttpGet("{id}")]
        public async Task<T> GetById(int id)
        {
            return await _service.GetById(id);
        }
    }
}
