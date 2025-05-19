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
    public class HoteliController : BaseCRUDController<eTuristickaAgencija.Models.Hotel, HotelSearchObject, HotelInsertRequest, HotelUpdateRequest>
    {
        private readonly IHotelService _hotelService;

        public HoteliController(ILogger<BaseController<Hotel, HotelSearchObject>> logger, IHotelService hotelService) : base(logger, hotelService)
        {
            _hotelService = hotelService;
        }

        //Dodavanje bez authorizacije
        // [AllowAnonymous]
        public override Task<Hotel> InsertFromFormAsync([FromForm] HotelInsertRequest insert)
        {
            return base.InsertFromFormAsync(insert);
        }
    }
}