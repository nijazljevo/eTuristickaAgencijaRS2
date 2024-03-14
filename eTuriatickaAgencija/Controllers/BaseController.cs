using eTuristickaAgencija.Service;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eTuriatickaAgencija.Controllers
{
  //  [ApiController]
    [Route("[controller]")]
   // [Authorize]
    public class BaseController<T, TSearch> : ControllerBase where T : class where TSearch : class
    {
        public IService<T, TSearch> Service { get; set; }
        protected readonly ILogger<BaseController<T, TSearch>> _logger;

        public BaseController(ILogger<BaseController<T, TSearch>> logger, IService<T, TSearch> service)
        {
            _logger = logger;
            Service = service;
        }
        

        [HttpGet]
        public IEnumerable<T> Get([FromQuery] TSearch search = null)
        {
            return Service.Get(search);
        }

        [HttpGet("{id}")]
        public T GetById(int id)
        {
            return Service.GetById(id);
        }
    }
}
