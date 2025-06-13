using AutoMapper;
using EasyNetQ;
using eTuristickaAgencija.Models;
using eTuristickaAgencija.Models.Exceptions;
using eTuristickaAgencija.Models.Request;
using Microsoft.Extensions.Logging;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eTuristickaAgencija.Service.DestinacijeStateMachine
{
    public class DraftDestinationState : BaseState
    {
        protected ILogger<DraftDestinationState> _logger;
        public DraftDestinationState(ILogger<DraftDestinationState> logger, IServiceProvider serviceProvider, Database.TuristickaAgencijaContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
            _logger = logger;
        }
        public override async Task<Destinacija> Update(int id, DestinacijaUpdateRequest request)
        {
            var set = _context.Set<Database.Destinacija>();

            var entity = await set.FindAsync(id);

            _mapper.Map(request, entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<Models.Destinacija>(entity);
        }
        public override async Task<Destinacija> Activate(int id)
        {
            _logger.LogInformation($"Aktivacija destinacije: {id}");

            _logger.LogWarning($"W: Aktivacija destinacije: {id}");

            _logger.LogError($"E: Aktivacija destinacije: {id}");

            var set = _context.Set<Database.Destinacija>();

            var entity = await set.FindAsync(id);

            entity.StateMachine = "active";

            await _context.SaveChangesAsync();


            //var factory = new ConnectionFactory { HostName = "localhost" };
            //using var connection = factory.CreateConnection();
            //using var channel = connection.CreateModel();


            //string message = "";

            //var body = Encoding.UTF8.GetBytes(message);

            //channel.BasicPublish(exchange: string.Empty,
            //                     routingKey: "product_added",
            //                     basicProperties: null,
            //                     body: body);

            var mappedEntity = _mapper.Map<Models.Destinacija>(entity);

            using var bus = RabbitHutch.CreateBus("host=localhost");

            bus.PubSub.Publish(mappedEntity);

            return mappedEntity;
        }

        //    public override async Task<Destinacija> Activate(int id){ 
        //    _logger.LogInformation($"Aktivacija destinacije: {id}");

        //     _logger.LogWarning($"W: Aktivacija destinacije: {id}");

        //   _logger.LogError($"E: Aktivacija destinacije: {id}");

        // var set = _context.Set<Database.Destinacija>();

        // var entity = await set.FindAsync(id);

        //            entity.StateMachine = "active";

        //          await _context.SaveChangesAsync();


        //var factory = new ConnectionFactory { HostName = "localhost" };
        //using var connection = factory.CreateConnection();
        //using var channel = connection.CreateModel();


        //string message = "";

        //var body = Encoding.UTF8.GetBytes(message);

        //channel.BasicPublish(exchange: string.Empty,
        //                     routingKey: "product_added",
        //                     basicProperties: null,
        //                     body: body);

        //       var mappedEntity = _mapper.Map<Models.Destinacija>(entity);

        //       using var bus = RabbitHutch.CreateBus("host=localhost");

        //     bus.PubSub.Publish(mappedEntity);

        //   return mappedEntity;
        //}
        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Update");
            list.Add("Activate");

            return list;
        }

    }
}
