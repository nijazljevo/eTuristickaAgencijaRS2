using eTuristickaAgencija.Models;
using eTuristickaAgencija.Models.Request;
using eTuristickaAgencija.Models.Search_Objects;
using eTuristickaAgencija.Service;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eTuriatickaAgencija.Controllers
{
   
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class AgencijaController : BaseCRUDController<eTuristickaAgencija.Models.Agencija, AgencijaSearchObject, AgencijaInsertRequest, AgencijaUpdateRequest>
    {
        private readonly IAgencijaService _agencijaServis;
        public AgencijaController(ILogger<BaseController<Agencija,AgencijaSearchObject>>logger, IAgencijaService agencijaServis) : base(logger,agencijaServis)
        {
            _agencijaServis = agencijaServis;
        }

        //Dodavanje bez authorizacije
       // [AllowAnonymous]
        public override eTuristickaAgencija.Models.Agencija Insert([FromBody] AgencijaInsertRequest agencijaInsertRequest)
        {
            return base.Insert(agencijaInsertRequest);
        }
    }
}
