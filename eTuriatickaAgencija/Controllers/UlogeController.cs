using eTuristickaAgencija.Models;
using eTuristickaAgencija.Models.Search_Objects;
using eTuristickaAgencija.Service;

namespace eTuriatickaAgencija.Controllers
{
    public class UlogeController : BaseController<Uloga, UlogaSearchObject>
    {
        private readonly IUlogeService _ulogeService;

        public UlogeController(ILogger<BaseController<Uloga, UlogaSearchObject>> logger, IUlogeService ulogeService) : base(logger, ulogeService)
        {
            _ulogeService = ulogeService;
        }
    }
}
