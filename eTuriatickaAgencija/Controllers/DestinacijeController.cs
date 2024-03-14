using eTuristickaAgencija.Models;
using eTuristickaAgencija.Models.Request;
using eTuristickaAgencija.Models.Search_Objects;
using eTuristickaAgencija.Service;
using Microsoft.AspNetCore.Mvc;

namespace eTuriatickaAgencija.Controllers
{
    [ApiController]
    [Route("[controller]")]
      public class DestinacijeController : BaseCRUDDestinacijaController<Destinacija, DestinacijaSearchObject,DestinacijaInsertRequest, DestinacijaUpdateRequest>
    {
        public DestinacijeController(ILogger<BaseDestinacijaController<Destinacija, DestinacijaSearchObject>> logger, IDestinacijaService service) : base(logger, service)
        {

        }

        [HttpPut("{id}/activate")]
        public virtual async Task<Destinacija> Activate(int id)
        {
            return await (_service as IDestinacijaService).Activate(id);
        }

       
        [HttpPut("{id}/hide")]
        public virtual async Task<Destinacija> Hide(int id)
        {
            return await (_service as IDestinacijaService).Hide(id);
        }
        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IDestinacijaService).AllowedActions(id);
        }
        [HttpGet("preporuceno/{id}")]
        public List<eTuristickaAgencija.Models.Destinacija> GetPreporucenaDestinacija(int id)
        {
            return _service.GetPreporucenaDestinacija(id);
        }
       


    }

}
