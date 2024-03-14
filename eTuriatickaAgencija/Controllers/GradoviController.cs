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
    public class GradoviController : BaseCRUDController<eTuristickaAgencija.Models.Grad, GradSearchObject, GradoviInsertRequest, GradoviUpdateRequest>
    {
        private readonly IGradService _gradService;
        public GradoviController(ILogger<BaseController<Grad, GradSearchObject>> logger, IGradService gradService) : base(logger,gradService)
        {
            _gradService = gradService;
        }

        //Dodavanje bez authorizacije
      //  [AllowAnonymous]
        public override eTuristickaAgencija.Models.Grad Insert([FromBody] GradoviInsertRequest gradInsertRequest)
        {
            return base.Insert(gradInsertRequest);
        }
    }
}
