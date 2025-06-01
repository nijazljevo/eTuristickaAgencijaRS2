using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eTuristickaAgencija.Service.Migrations
{
    /// <inheritdoc />
    public partial class UpdateRezervacija : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Ocjena",
                keyColumn: "ID",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Ocjena",
                keyColumn: "ID",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Ocjena",
                keyColumn: "ID",
                keyValue: 9);

            migrationBuilder.AddColumn<int>(
                name: "BrojOsoba",
                table: "Rezervacija",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<DateTime>(
                name: "CheckIn",
                table: "Rezervacija",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<DateTime>(
                name: "CheckOut",
                table: "Rezervacija",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<string>(
                name: "TipSobe",
                table: "Rezervacija",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "cdBhoZU8wGqdpyhQAmETLn6GRgE=", "HiYms7gbeYYsNYXuKJrAeQ==" });

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "M1zKh+ZDhjDmnf88kUjgDOyE9WQ=", "q+wWdC9snYOiTpSPYQXVkg==" });

            migrationBuilder.UpdateData(
                table: "Rezervacija",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "BrojOsoba", "CheckIn", "CheckOut", "TipSobe" },
                values: new object[] { 2, new DateTime(2020, 9, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2020, 9, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "Dvokrevetna" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "BrojOsoba",
                table: "Rezervacija");

            migrationBuilder.DropColumn(
                name: "CheckIn",
                table: "Rezervacija");

            migrationBuilder.DropColumn(
                name: "CheckOut",
                table: "Rezervacija");

            migrationBuilder.DropColumn(
                name: "TipSobe",
                table: "Rezervacija");

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "w/+CSQYJ1d700Ch9fD8302r/MkA=", "3Lr/BpQQY+6njDnSD5Cw3Q==" });

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "gP7hyHxa8nrdZ0OMbX7WckErZ5U=", "ssKlHW3BJMUQz4avEAjzOQ==" });

            migrationBuilder.InsertData(
                table: "Ocjena",
                columns: new[] { "ID", "DestinacijaID", "Komentar", "KorisnikID", "OcjenaUsluge" },
                values: new object[,]
                {
                    { 7, 2, "komentar", 2, 4 },
                    { 8, 1, "destinacija za preporuku", 1, 5 },
                    { 9, 2, "top", 1, 4 }
                });
        }
    }
}
