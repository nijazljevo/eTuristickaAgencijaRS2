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
    public class UposlenikController : BaseCRUDController<eTuristickaAgencija.Models.Uposlenik, UposlenikSearchObject, UposlenikInsertRequest, UposlenikUpdateRequest>
    {
        private readonly IUposlenikService _uposlenikService;
        public UposlenikController(ILogger<BaseController<Uposlenik, UposlenikSearchObject>> logger, IUposlenikService uposlenikService) : base(logger, uposlenikService)
        {
            _uposlenikService = uposlenikService;
        }

        //Dodavanje bez authorizacije
        //[AllowAnonymous]
        public override eTuristickaAgencija.Models.Uposlenik Insert([FromBody] UposlenikInsertRequest uposlenikInsertRequest)
        {
            return base.Insert(uposlenikInsertRequest);
        }
        
    }
}
