using AutoMapper;
using eTuristickaAgencija.Models;
using eTuristickaAgencija.Models.Request;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eTuristickaAgencija.Service.DestinacijeStateMachine
{
    public class InitialDestinationState:BaseState
    {
        public InitialDestinationState(IServiceProvider serviceProvider, Database.TuristickaAgencijaContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Destinacija> Insert(DestinacijaInsertRequest request)
        {
            //TODO: EF CALL
            var set = _context.Set<Database.Destinacija>();

            var entity = _mapper.Map<Database.Destinacija>(request);

            entity.StateMachine = "draft";

            set.Add(entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<Destinacija>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Insert");

            return list;
        }
    }
}
