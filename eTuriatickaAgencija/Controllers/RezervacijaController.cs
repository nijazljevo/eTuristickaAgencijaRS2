using eTuristickaAgencija.Models;
using eTuristickaAgencija.Models.Request;
using eTuristickaAgencija.Models.Search_Objects;
using eTuristickaAgencija.Service;
using eTuristickaAgencija.Service.RabbitMQ;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eTuriatickaAgencija.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class RezervacijaController : BaseCRUDController<eTuristickaAgencija.Models.Rezervacija, RezervacijaSearchObject, RezervacijaInsertRequest, RezervacijaUpdateRequest>
    {
        private readonly IRezervacijaService _rezervacijaService;
        private readonly IRabbitMQProducer _rabbitMQProducer;

        public RezervacijaController(ILogger<BaseController<Rezervacija, RezervacijaSearchObject>> logger,
            IRezervacijaService rezervacijaService, IRabbitMQProducer rabitMQProducer) : base(logger, rezervacijaService)
        {
            _rezervacijaService = rezervacijaService;
            _rabbitMQProducer = rabitMQProducer;
        }

        //Dodavanje bez authorizacije
        //[AllowAnonymous]
        public override eTuristickaAgencija.Models.Rezervacija Insert([FromBody] RezervacijaInsertRequest rezervacijaInsertRequest)
        {
            return base.Insert(rezervacijaInsertRequest);
        }

        [AllowAnonymous]
        public override eTuristickaAgencija.Models.Rezervacija Update(int id, [FromBody] RezervacijaUpdateRequest rezervacijaUpdateRequest)
        {
            return base.Update(id, rezervacijaUpdateRequest);
        }

        [HttpPost("SendConfirmationEmail")]
        public IActionResult SendConfirmationEmail([FromBody] EmailModel emailModel)
        {
            _rabbitMQProducer.SendMessage(emailModel);
            Thread.Sleep(TimeSpan.FromSeconds(15));
            return Ok();
        }


        [HttpPut("otkazi")]
        public async Task<IActionResult> Otkazi([FromQuery] int rezervacijaId)
        {
            var otkazana = await _rezervacijaService.CancelReservation(rezervacijaId);
            return Ok(otkazana);
        }

        public class EmailModel
        {
            public string Sender { get; set; }
            public string Recipient { get; set; }
            public string Subject { get; set; }
            public string Content { get; set; }
        }
    }
}