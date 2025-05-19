using AutoMapper;
using eTuristickaAgencija.Service.Database;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eTuristickaAgencija.Models.Search_Objects;

namespace eTuristickaAgencija.Service
{
    public class BaseCRUDService<T, TDb, TSearch, TInsert, TUpdate> : BaseService<T, TDb, TSearch>, ICRUDService<T, TSearch, TInsert, TUpdate>
        where T : class where TDb : class where TSearch : BaseSearchObject where TInsert : class where TUpdate : class
    {
        public BaseCRUDService(TuristickaAgencijaContext eContext, IMapper mapper) : base(eContext, mapper)
        {
        }

        public virtual T Insert(TInsert insert)
        {
            var set = Context.Set<TDb>();
            TDb entity = Mapper.Map<TDb>(insert);
            set.Add(entity);
            BeforeInsert(insert, entity);
            Context.SaveChanges();
            return Mapper.Map<T>(entity);
        }

        public virtual async Task<T> InsertAsync(TInsert insert)
        {
            var set = Context.Set<TDb>();
            TDb entity = Mapper.Map<TDb>(insert);
            await set.AddAsync(entity);
            await BeforeInsertAsync(insert, entity);
            await Context.SaveChangesAsync();
            return Mapper.Map<T>(entity);
        }

        public virtual void BeforeInsert(TInsert insert, TDb entity)
        {
        }

        public virtual async Task BeforeInsertAsync(TInsert insert, TDb entity)
        {
        }

        public virtual T Update(int id, TUpdate update)
        {
            var set = Context.Set<TDb>();
            var entity = set.Find(id);
            if (entity != null)
            {
                Mapper.Map(update, entity);
            }
            else
            {
                return null;
            }
            Context.SaveChanges();
            return Mapper.Map<T>(entity);
        }

        public virtual T Delete(int id)
        {
            var set = Context.Set<TDb>();
            var entity = set.Find(id);
            if (entity != null)
            {
                var tmp = entity;
                Context.Remove(entity);
                int result = Context.SaveChanges(); // Dodajte ovaj red za proveru rezultata brisanja
                Console.WriteLine($"Delete result: {result}"); // Dodajte ovaj red za proveru rezultata brisanja
                return Mapper.Map<T>(tmp);
            }
            else
            {
                return null;
            }
        }
    }
}