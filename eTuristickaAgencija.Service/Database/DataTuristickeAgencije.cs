using eTuristickaAgencija.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using static System.Net.Mime.MediaTypeNames;

namespace eTuristickaAgencija.Service.Database
{
    public partial class TuristickaAgencijaContext
    {
        public static string GenerateSalt()
        {
            var buf = new byte[16];
            (new RNGCryptoServiceProvider()).GetBytes(buf);
            return Convert.ToBase64String(buf);
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

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder)
        {
            List<string> salts = new List<string>();
            for (int i = 0; i < 5; i++)
            {
                salts.Add(PasswordHelper.GenerateSalt());
            }

            modelBuilder.Entity<Clan>().HasData(
                 new Clan() { Id = 1, DatumRegistracije = new DateTime(2021, 07, 10), KorisnikId = 2 });

            modelBuilder.Entity<Agencija>().HasData(
                    new Agencija()
                    {
                        Id = 1,
                        Email = "agencija@gmail.com",
                        Telefon = "061-235-886",
                        Adresa = "Trg Ivana Krndelja 35, 88000 Mostar"
                    });

            modelBuilder.Entity<Kontinent>().HasData(
                  new Kontinent() { Id = 1, Naziv = "Evropa" },
              new Kontinent() { Id = 2, Naziv = "Azija" });

            modelBuilder.Entity<Uloga>().HasData(
                new Uloga() { Id = 1, Naziv = "Admin" },
            new Uloga() { Id = 2, Naziv = "Turist" });

            modelBuilder.Entity<Ocjena>().HasData(
                  new Ocjena() { Id = 1, Komentar = "Odlicno", DestinacijaId = 1, OcjenaUsluge = 5, KorisnikId = 2 });

            modelBuilder.Entity<Rezervacija>().HasData(
                     new Rezervacija()
                     {
                         Id = 1,
                         KorisnikId = 2,
                         Otkazana = false,
                         DatumRezervacije = new DateTime(2020, 09, 01),
                         CheckIn = new DateTime(2020, 09, 10),
                         CheckOut = new DateTime(2020, 09, 15),
                         BrojOsoba = 2,
                         TipSobe = "Dvokrevetna soba",
                         HotelId = 1,
                         Cijena = 300
                     });

            modelBuilder.Entity<Uposlenik>().HasData(
                      new Uposlenik() { Id = 1, KorisnikId = 1, Aktivan = true, DatumZaposlenja = new DateTime(2020, 09, 01) });
            modelBuilder.Entity<Kartum>().HasData(
                     new Kartum() { Id = 1, KorisnikId = 2, TerminId = 1, DatumKreiranja = new DateTime(2020, 09, 01) });

            //   modelBuilder.Entity<Drzava>().HasData(
            //    new Drzava() { Id = 1, KontinentId = 1, Naziv = "Turska" },
            //   new Drzava() { Id = 2, KontinentId = 2, Naziv = "Malezija" });
            Database.Drzava drzava = new Database.Drzava()
            {
                Id = 1,
                Naziv = "Turska",
                KontinentId = 1
            };

            modelBuilder.Entity<Drzava>().HasData(drzava);

            Database.Drzava drzava2 = new Database.Drzava()
            {
                Id = 2,
                Naziv = "Malezija",
                KontinentId = 2
            };

            modelBuilder.Entity<Drzava>().HasData(drzava2);
            modelBuilder.Entity<Grad>().HasData(
                  new Grad() { Id = 1, DrzavaId = 1, Naziv = "Istanbul" },
                   new Grad() { Id = 2, DrzavaId = 2, Naziv = "Kuala Lumpur" });

            modelBuilder.Entity<Hotel>().HasData(
                  new Hotel() { Id = 1, GradId = 1, Naziv = "Levent", BrojZvjezdica = 5 },
                   new Hotel() { Id = 2, GradId = 2, Naziv = "Hotel Malezija", BrojZvjezdica = 5 });

            modelBuilder.Entity<Destinacija>().HasData(
                  new Destinacija() { Id = 1, GradId = 1, Naziv = "Putovanje u Tursku" },
                   new Destinacija() { Id = 2, GradId = 2, Naziv = "Putovanje u Maleziju" },
                   new Destinacija() { Id = 3, GradId = 2, Naziv = "putovanje1" },
                   new Destinacija() { Id = 4, GradId = 1, Naziv = "putovanje2" });

            modelBuilder.Entity<Termin>().HasData(
                 new Termin()
                 {
                     Id = 1,
                     GradId = 1,
                     HotelId = 1,
                     DestinacijaId = 1,
                     AktivanTermin = true,
                     Cijena = 900,
                     CijenaPopust = 0,
                     Popust = 0,
                     DatumPolaska = new DateTime(2021, 08, 15),
                     DatumDolaska = new DateTime(2021, 08, 20)
                 },
                  new Termin()
                  {
                      Id = 2,
                      GradId = 2,
                      HotelId = 2,
                      DestinacijaId = 2,
                      AktivanTermin = true,
                      Cijena = 450,
                      CijenaPopust = 0,
                      Popust = 0,
                      DatumPolaska = new DateTime(2021, 04, 10),
                      DatumDolaska = new DateTime(2021, 04, 17)
                  },
                  new Termin()
                  {
                      Id = 3,
                      GradId = 1,
                      HotelId = 1,
                      DestinacijaId = 3,
                      AktivanTermin = true,
                      Cijena = 670,
                      CijenaPopust = 0,
                      Popust = 0,
                      DatumPolaska = new DateTime(2022, 09, 30),
                      DatumDolaska = new DateTime(2022, 10, 20)
                  });

            modelBuilder.Entity<Uplate>().HasData(
                  new Uplate() { Id = 1, KorisnikId = 2, Iznos = 500 });

            //    modelBuilder.Entity<Korisnik>()
            //                 .HasData
            //               (
            //                 new Korisnik { Id = 1, Ime = "Nijaz", KorisnikoIme = "admin", Prezime = "Ljevo",Email="nijaz@gmail.com",UlogaId=1, LozinkaSalt = salts[0],  LozinkaHash = PasswordHelper.GenerateHash(salts[0], "test") },
            //               new Korisnik { Id = 2, Ime = "test", KorisnikoIme = "mobile", Prezime = "test",Email="test@gmail.com",UlogaId=2, LozinkaSalt = salts[1],  LozinkaHash = PasswordHelper.GenerateHash(salts[1], "test") }
            //         );

            Database.Korisnik korisnik = new Database.Korisnik()
            {
                Id = 1,
                Ime = "Nijaz",
                Prezime = "Ljevo",
                KorisnikoIme = "admin",
                Email = "nijaz@gmail.com",
                UlogaId = 1,
            };
            korisnik.LozinkaSalt = GenerateSalt();
            korisnik.LozinkaHash = GenerateHash(korisnik.LozinkaSalt, "test");
            modelBuilder.Entity<Korisnik>().HasData(korisnik);

            Database.Korisnik korisnik2 = new Database.Korisnik()
            {
                Id = 2,
                Ime = "Amna",
                Prezime = "Spahalic",
                KorisnikoIme = "mobile",
                Email = "amna@gmail.com",
                UlogaId = 2,
            };
            korisnik2.LozinkaSalt = GenerateSalt();
            korisnik2.LozinkaHash = GenerateHash(korisnik2.LozinkaSalt, "test");
            modelBuilder.Entity<Korisnik>().HasData(korisnik2);
        }
    }
}