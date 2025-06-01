using AutoMapper;
using eTuristickaAgencija.Models;
using eTuristickaAgencija.Models.Request;
using eTuristickaAgencija.Models.Search_Objects;
using eTuristickaAgencija.Service.Database;
using eTuristickaAgencija.Service.DestinacijeStateMachine;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
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

        public override IQueryable<Database.Destinacija> AddFilter(IQueryable<Database.Destinacija> query, DestinacijaSearchObject? search=null )
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

        public List<Models.Destinacija> GetPreporucenaDestinacija(int id)
        {
            lock (isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    var destinationData = _context.Destinacijas.Include("Ocjenas").ToList();

                    var data = new List<DestinationEntry>();

                    foreach (var destination in destinationData)
                    {
                        if (destination.Ocjenas != null && destination.Ocjenas.Count > 1)
                        {
                            var distinctUserId = destination.Ocjenas
                                .Where(x => x.KorisnikId.HasValue && x.DestinacijaId.HasValue)
                                .Select(x => x.KorisnikId.Value)
                                .Distinct()
                                .ToList();

                            foreach (var userId in distinctUserId)
                            {
                                var ratedDestinations = destination.Ocjenas
                                    .Where(x => x.KorisnikId != userId && x.DestinacijaId.HasValue);

                                foreach (var ratedDestination in ratedDestinations)
                                {
                                    if (destination.Id > 0 && ratedDestination.DestinacijaId.HasValue)
                                    {
                                        data.Add(new DestinationEntry()
                                        {
                                            DestinationID = (uint)destination.Id,
                                            CoRatedDestinationID = (uint)ratedDestination.DestinacijaId.Value,
                                            Label = 1f
                                        });
                                    }
                                }
                            }
                        }
                    }

                    if (!data.Any())
                    {
                        model = null;
                        return new List<Models.Destinacija>();
                    }

                    var traindata = mlContext.Data.LoadFromEnumerable(data);

                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                    options.MatrixColumnIndexColumnName = nameof(DestinationEntry.DestinationID);
                    options.MatrixRowIndexColumnName = nameof(DestinationEntry.CoRatedDestinationID);
                    options.LabelColumnName = "Label";
                    options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                    options.Alpha = 0.01;
                    options.Lambda = 0.025;
                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    model = est.Fit(traindata);
                }
            }

            if (model == null)
            {
                // Ovjde je pucalo ako nisam dodao ovu liniju
                mlContext = null;
                return new List<Models.Destinacija>();
            }

            // Prediction
            var destinations = _context.Destinacijas.Where(x => x.Id != id).ToList();

            var predictionResult = new List<Tuple<Database.Destinacija, float>>();

            foreach (var destination in destinations)
            {
                var predictionengine = mlContext.Model.CreatePredictionEngine<DestinationEntry, CoRatedDestinationPrediction>(model);
                var prediction = predictionengine.Predict(
                    new DestinationEntry()
                    {
                        DestinationID = (uint)id,
                        CoRatedDestinationID = (uint)destination.Id,
                        Label = 0f
                    });

                predictionResult.Add(new Tuple<Database.Destinacija, float>(destination, prediction.Score));
            }

            var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();

            return _mapper.Map<List<Models.Destinacija>>(finalResult);
        }

       

        public class CoRatedDestinationPrediction
        {
            public float Score { get; set; }
        }

        public class DestinationEntry
        {
            [KeyType(count: 10)]
            public uint DestinationID { get; set; }

            [KeyType(count: 10)]
            public uint CoRatedDestinationID { get; set; }

            public float Label { get; set; }
        }

    }
}
