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
    public class TerminiController : BaseCRUDController<eTuristickaAgencija.Models.Termin, TerminSearchObject, TerminInsertRequest, TerminUpdateRequest>
    {
        private readonly ITerminService _terminService;
        public TerminiController(ILogger<BaseController<Termin, TerminSearchObject>> logger, ITerminService terminService) : base(logger, terminService)
        {
            _terminService = terminService;
        }

        //Dodavanje bez authorizacije
      //  [AllowAnonymous]
        public override eTuristickaAgencija.Models.Termin Insert([FromBody] TerminInsertRequest terminInsertRequest)
        {
            return base.Insert(terminInsertRequest);
        }
    }
}
