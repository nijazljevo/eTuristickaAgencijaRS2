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
    public class KarteController : BaseCRUDController<eTuristickaAgencija.Models.Karta, KartaSearchObject, KartaInsertRequest, KartaUpdateRequest>
    {
        private readonly IKartaService _kartaService;
        public KarteController(ILogger<BaseController<Karta, KartaSearchObject>> logger, IKartaService kartaService) : base(logger, kartaService)
        {
            _kartaService = kartaService;
        }

        //Dodavanje bez authorizacije
        //[AllowAnonymous]
        public override eTuristickaAgencija.Models.Karta Insert([FromBody] KartaInsertRequest kartaInsertRequest)
        {
            return base.Insert(kartaInsertRequest);
        }
    }
}
