using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using eTuristickaAgencija.Models.Request;

namespace eTuristickaAgencija.Service
{
    public class MappingProfile:Profile
    {
        public MappingProfile() {
            CreateMap<Database.Uloga, Models.Uloga>();
            CreateMap<Database.Korisnik, Models.Korisnik>();
            CreateMap<KorisniciInsertRequest, Database.Korisnik>();
            CreateMap<KorisniciUpdateRequest, Database.Korisnik>();
            CreateMap<Database.Agencija, Models.Agencija>();
            CreateMap<AgencijaInsertRequest, Database.Agencija>();
            CreateMap<AgencijaUpdateRequest, Database.Agencija>();
            CreateMap<Database.Clan, Models.Clan>();
            CreateMap<ClanInsertRequest, Database.Clan>();
            CreateMap<ClanUpdateRequest, Database.Clan>();
            CreateMap<Database.Destinacija, Models.Destinacija>();
            CreateMap<DestinacijaInsertRequest, Database.Destinacija>();
            CreateMap<DestinacijaUpdateRequest, Database.Destinacija>();
            CreateMap<Database.Drzava, Models.Drzava>();
            CreateMap<DrzavaInsertRequest, Database.Drzava>();
            CreateMap<DrzavaUpdateRequest, Database.Drzava>();
            CreateMap<Database.Grad, Models.Grad>();
            CreateMap<GradoviInsertRequest, Database.Grad>();
            CreateMap<GradoviUpdateRequest, Database.Grad>();
            CreateMap<Database.Hotel, Models.Hotel>();
            CreateMap<HotelInsertRequest, Database.Hotel>();
            CreateMap<HotelUpdateRequest, Database.Hotel>();
            CreateMap<Database.Kartum, Models.Karta>();
            CreateMap<KartaInsertRequest, Database.Kartum>();
            CreateMap<KartaUpdateRequest, Database.Kartum>();
            CreateMap<Database.Kontinent, Models.Kontinent>();
            CreateMap<KontinentInsertRequest, Database.Kontinent>();
            CreateMap<KontinentUpdateRequest, Database.Kontinent>();
            CreateMap<Database.Ocjena, Models.Ocjena>();
            CreateMap<OcjenaInsertRequest, Database.Ocjena>();
            CreateMap<OcjenaUpdateRequest, Database.Ocjena>();
            CreateMap<Database.Rezervacija, Models.Rezervacija>();
            CreateMap<RezervacijaInsertRequest, Database.Rezervacija>();
            CreateMap<RezervacijaUpdateRequest, Database.Rezervacija>();
            CreateMap<Database.Termin, Models.Termin>();
            CreateMap<TerminInsertRequest, Database.Termin>();
            CreateMap<TerminUpdateRequest, Database.Termin>();
            CreateMap<Database.Uposlenik, Models.Uposlenik>();
            CreateMap<UposlenikInsertRequest, Database.Uposlenik>();
            CreateMap<UposlenikUpdateRequest, Database.Uposlenik>();
            CreateMap<Database.Uplate, Models.Uplata>();
            CreateMap<UplataInsertRequest, Database.Uplate>();
            CreateMap<UplataUpdateRequest, Database.Uplate>();
            /*CreateMap<Database.Agencija, Models.Agencija>();
            CreateMap<AgencijaInsertRequest, Database.Agencija>();
            CreateMap<AgencijaUpdateRequest, Database.Agencija>();*/
        }
    }
}
