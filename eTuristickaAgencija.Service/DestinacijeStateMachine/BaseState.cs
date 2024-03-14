using AutoMapper;
using eTuristickaAgencija.Models.Exceptions;
using eTuristickaAgencija.Models.Request;
using eTuristickaAgencija.Service.Database;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eTuristickaAgencija.Service.DestinacijeStateMachine
{
    public class BaseState
    {
        protected TuristickaAgencijaContext _context;
        protected IMapper _mapper { get; set; }
        public IServiceProvider _serviceProvider { get; set; }
        public BaseState(IServiceProvider serviceProvider, TuristickaAgencijaContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public virtual Task<Models.Destinacija> Insert(DestinacijaInsertRequest request)
        {
            throw new UserException("Not allowed");
        }
        public virtual Task<Models.Destinacija> Update(int id, DestinacijaUpdateRequest request)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Models.Destinacija> Activate(int id)
        {
            throw new UserException("Not allowed");
        }
        //      public virtual Task<Models.Destinacija> Activate(int id)
        //    {
        //      throw new UserException("Not allowed");
        //  }
        public virtual Task<Models.Destinacija> Hide(int id)
        {
            throw new UserException("Not allowed");
        }
        public virtual Task<Models.Destinacija> Delete(int id)
        {
            throw new UserException("Not allowed");
        }
        public BaseState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                case null:
                    return _serviceProvider.GetService<InitialDestinationState>();
                    break;
                case "draft":
                    return _serviceProvider.GetService<DraftDestinationState>();
                    break;
                case "active":
                    return _serviceProvider.GetService<ActiveDestinationState>();
                    break;

                default:
                    throw new UserException("Not allowed");
            }
        }
        public virtual async Task<List<string>> AllowedActions()
        {
            return new List<string>();
        }
    }
}
