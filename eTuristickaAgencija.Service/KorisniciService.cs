using AutoMapper;
using eTuristickaAgencija.Models.Request;
using eTuristickaAgencija.Service.Database;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using eTuristickaAgencija.Models.Exceptions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using eTuristickaAgencija.Models.Search_Objects;

namespace eTuristickaAgencija.Service
{
    public class KorisniciService
        : BaseCRUDService<Models.Korisnik, Korisnik, KorisnikSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>, IKorisniciService
    {

        public KorisniciService(TuristickaAgencijaContext eContext, IMapper mapper) : base(eContext, mapper)
        {
        }

      
        public static string GenerateSalt()
        {
            RNGCryptoServiceProvider provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);
            return Convert.ToBase64String(byteArray);
        }


        public override void BeforeInsert(KorisniciInsertRequest insert, Korisnik entity)
        {
            var salt = GenerateSalt();
            entity.LozinkaSalt = salt;
            entity.LozinkaHash = GenerateHash(salt, insert.Password);
            entity.KorisnikoIme = insert.KorisnikoIme;
            //entity.Uloga = insert.UlogaId;
            if (Context.Korisniks.Any(k => k.KorisnikoIme == insert.KorisnikoIme))
            {
                throw new ConflictException("User with this username already exists.");
            }
            else if (Context.Korisniks.Any(k => k.Email == insert.Email))
            {
                throw new ConflictException("User with this email already exists.");
            }
            base.BeforeInsert(insert, entity);
        }

        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        public override IQueryable<Korisnik> AddFilter(IQueryable<Korisnik> query, KorisnikSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.Id != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.Id == search.Id);
            }

            
            if (!string.IsNullOrEmpty(search?.Email))
            {
                filteredQuery = filteredQuery.Where(x => x.Email == search.Email);
            }
            if (!string.IsNullOrEmpty(search?.KorisnikoIme))
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnikoIme == search.KorisnikoIme);
            }
            
            return filteredQuery;
        }
        public async Task<Models.Korisnik> Login(string username, string password)
        {
            var entity = await Context.Korisniks.FirstOrDefaultAsync(x => x.KorisnikoIme == username);

            if (entity == null)
            {
                return null;
            }

            var hash = GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }
            return Mapper.Map<Models.Korisnik>(entity);
        }
    }

}
