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
    public class DrzaveController : BaseCRUDController<eTuristickaAgencija.Models.Drzava, DrzavaSearchObject, DrzavaInsertRequest, DrzavaUpdateRequest>
    {
        private readonly IDrzavaService _drzavaService;
        public DrzaveController(ILogger<BaseController<Drzava, DrzavaSearchObject>> logger, IDrzavaService drzavaService) : base(logger, drzavaService)
        {
            _drzavaService = drzavaService;
        }

        //Dodavanje bez authorizacije
        // [AllowAnonymous]
        public override eTuristickaAgencija.Models.Drzava Insert([FromBody] DrzavaInsertRequest drzavaInsertRequest)
        {
            return base.Insert(drzavaInsertRequest);
        }
       
    }
}
