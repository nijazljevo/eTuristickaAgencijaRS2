using AutoMapper;
using eTuristickaAgencija.Service.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eTuristickaAgencija.Service.DestinacijeStateMachine
{
    public class ActiveDestinationState : BaseState
    {
        public ActiveDestinationState(IServiceProvider serviceProvider, TuristickaAgencijaContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
        }
        public override async Task<Models.Destinacija> Hide(int id)
        {
            var set = _context.Set<Database.Destinacija>();

            var entity = await set.FindAsync(id);

            entity.StateMachine = "draft";

            await _context.SaveChangesAsync();
            return _mapper.Map<Models.Destinacija>(entity);
        }
        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();
            list.Add("Hide");

            return list;
        }
    }
}
