using eTuristickaAgencija.Service;
using eTuristickaAgencija.Models.Request;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using eTuristickaAgencija.Models.Search_Objects;
using Microsoft.AspNetCore.Authorization;
using eTuristickaAgencija.Models;

namespace eTuriatickaAgencija.Controllers
{
    [ApiController]
    [Route("[controller]")]
    //[Authorize]
    public class KorisniciController : BaseCRUDController<eTuristickaAgencija.Models.Korisnik, KorisnikSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        private readonly IKorisniciService _korisniciServis;
        public KorisniciController(ILogger<BaseController<Korisnik, KorisnikSearchObject>> logger, IKorisniciService korisniciServis) : base(logger, korisniciServis)
        {
            _korisniciServis = korisniciServis;
        }

        //Dodavanje bez authorizacije
        [AllowAnonymous]
        public override eTuristickaAgencija.Models.Korisnik Insert([FromBody] KorisniciInsertRequest korisnikInsertRequest)
        {
            return base.Insert(korisnikInsertRequest);
        }
        [AllowAnonymous]
        public override eTuristickaAgencija.Models.Korisnik Update(int id,[FromBody] KorisniciUpdateRequest korisnikUpdateRequest)
        {
            return base.Update(id,korisnikUpdateRequest);
        }
    }
}
