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
    public class UplateController : BaseCRUDController<eTuristickaAgencija.Models.Uplata, UplataSearchObject, UplataInsertRequest, UplataUpdateRequest>
    {
        private readonly IUplataService _uplataServis;
        public UplateController(ILogger<BaseController<Uplata, UplataSearchObject>> logger, IUplataService uplataServis) : base(logger, uplataServis)
        {
            _uplataServis = uplataServis;
        }

        //Dodavanje bez authorizacije
        //[AllowAnonymous]
        public override eTuristickaAgencija.Models.Uplata Insert([FromBody] UplataInsertRequest uplataInsertRequest)
        {
            return base.Insert(uplataInsertRequest);
        }
    }
}
