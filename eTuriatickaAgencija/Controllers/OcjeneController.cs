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
    public class OcjeneController : BaseCRUDController<eTuristickaAgencija.Models.Ocjena, OcjenaSearchObject, OcjenaInsertRequest, OcjenaUpdateRequest>
    {
        private readonly IOcjenaService _ocjenaService;
        public OcjeneController(ILogger<BaseController<Ocjena, OcjenaSearchObject>> logger, IOcjenaService ocjenaService) : base(logger, ocjenaService)
        {
            _ocjenaService = ocjenaService;
        }

        //Dodavanje bez authorizacije
        //[AllowAnonymous]
        public override eTuristickaAgencija.Models.Ocjena Insert([FromBody] OcjenaInsertRequest ocjenaInsertRequest)
        {
            return base.Insert(ocjenaInsertRequest);
        }
    }
}
