using AutoMapper;
using eTuristickaAgencija.Models;
using eTuristickaAgencija.Models.Request;
using eTuristickaAgencija.Models.Search_Objects;
using eTuristickaAgencija.Service.Database;
using eTuristickaAgencija.Service.DestinacijeStateMachine;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eTuristickaAgencija.Service
{
      public class DestinacijeService
       : BaseCRUDDestinacijeService<Models.Destinacija, Database.Destinacija, DestinacijaSearchObject, DestinacijaInsertRequest, DestinacijaUpdateRequest>, IDestinacijaService
    {
        public BaseState _baseState { get; set; }
        public DestinacijeService(BaseState baseState,TuristickaAgencijaContext eContext, IMapper mapper) : base(eContext, mapper)
        {
            _baseState = baseState;
        }

        public override IQueryable<Database.Destinacija> AddFilter(IQueryable<Database.Destinacija> query, DestinacijaSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.Id != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.Id == search.Id);
            }
            

            if (!string.IsNullOrEmpty(search?.Naziv))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv == search.Naziv);
            }
            return filteredQuery;
        }
        public override async Task<Models.Destinacija> Insert(DestinacijaInsertRequest insert)
        {
            var state = _baseState.CreateState("initial");

            return  await state.Insert(insert);

        }
        public override async Task<Models.Destinacija> Update(int id, DestinacijaUpdateRequest update)
        {
            var entity = await _context.Destinacijas.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Update(id, update);
        }
        public async Task<Models.Destinacija> Activate(int id)
        {
            var entity = await _context.Destinacijas.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Activate(id);
        }
        //     public async Task<Models.Destinacija> Activate(int id)
        //   {
        //     var entity = await _context.Destinacijas.FindAsync(id);

        //   var state = _baseState.CreateState(entity.StateMachine);

        // return await state.Activate(id);
        // }
        public async Task<Models.Destinacija> Hide(int id)
        {
            var entity = await _context.Destinacijas.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Hide(id);
        }
        public async Task<List<string>> AllowedActions(int id)
        {
            var entity = await _context.Destinacijas.FindAsync(id);
            var state = _baseState.CreateState(entity?.StateMachine ?? "initial");
            return await state.AllowedActions();
        }
        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;
        public List<Models.Destinacija> GetPreporucenaDestinacija(int korisnikId)
        {
            var korisnici = _context.Korisniks.Where(e => e.Id != korisnikId).ToList();

            Dictionary<Database.Korisnik, List<Database.Ocjena>> ocjena = new Dictionary<Database.Korisnik, List<Database.Ocjena>>();
            foreach (var korisnik in korisnici)
            {
                var ocjene = _context.Ocjenas
                    .Where(e => e.KorisnikId == korisnik.Id)
                    .ToList();
                ocjena.Add(korisnik, ocjene);
            }

            var ocjeneKorisnik = _context.Ocjenas.Where(e => e.KorisnikId == korisnikId).ToList();

            if (ocjeneKorisnik == null || ocjeneKorisnik.Count == 0)
                return null;

            List<Database.Ocjena> zajednickeOcjeneKorisnik = new List<Database.Ocjena>();
            List<Database.Ocjena> zajednickeOcjeneKorisnik2 = new List<Database.Ocjena>();

            var preporuceneDestinacijeIds = new List<int>();

            foreach (var item in ocjena)
            {
                foreach (var recenzija in ocjeneKorisnik)
                {
                    if (item.Value.Any(x => x.DestinacijaId == recenzija.DestinacijaId))
                    {
                        zajednickeOcjeneKorisnik.Add(recenzija);
                        zajednickeOcjeneKorisnik2.Add(item.Value.FirstOrDefault(e => e.DestinacijaId == recenzija.DestinacijaId));
                    }
                }

                double slicnost = GetSlicnost(zajednickeOcjeneKorisnik, zajednickeOcjeneKorisnik2);

                if (slicnost > 0.5)
                {
                    var dobroOcjenjeneDestinacijeIds = ocjena
                        .Select(e => e.Value)
                        .SelectMany(e => e)
                        .Where(e => e.OcjenaUsluge >= 3)
                        .Select(e => e.DestinacijaId)
                        .Where(e => !preporuceneDestinacijeIds.Contains((int)e))
                        .ToList();

                    dobroOcjenjeneDestinacijeIds.ForEach(e => {
                        if (!preporuceneDestinacijeIds.Contains((int)e))
                            preporuceneDestinacijeIds.Add((int)e);
                    });
                }

                zajednickeOcjeneKorisnik.Clear();
                zajednickeOcjeneKorisnik2.Clear();
            }

            var preporuceneDestinacije = _context.Set<Database.Destinacija>()
                .Where(x => preporuceneDestinacijeIds.Contains(x.Id))
                .ToList();

            var result = _mapper.Map<List<Models.Destinacija>>(preporuceneDestinacije);
            return result;
        }
        private double GetSlicnost(List<Database.Ocjena> zajednickeOcjene1, List<Database.Ocjena> zajednickeOcjene2)
        {
            if (zajednickeOcjene1.Count != zajednickeOcjene2.Count)
                return 0;

            double brojnik = 0, nazivnik1 = 0, nazivnik2 = 0;

            for (int i = 0; i < zajednickeOcjene1.Count; i++)
            {
                brojnik += zajednickeOcjene1[i].OcjenaUsluge * zajednickeOcjene2[i].OcjenaUsluge;
                nazivnik1 += zajednickeOcjene1[i].OcjenaUsluge * zajednickeOcjene1[i].OcjenaUsluge;
                nazivnik2 += zajednickeOcjene2[i].OcjenaUsluge * zajednickeOcjene2[i].OcjenaUsluge;
            }
            nazivnik1 = Math.Sqrt(nazivnik1);
            nazivnik2 = Math.Sqrt(nazivnik2);

            double nazivnik = nazivnik1 * nazivnik2;
            if (nazivnik == 0)
                return 0;
            else
                return brojnik / nazivnik;
        }
    }
}
