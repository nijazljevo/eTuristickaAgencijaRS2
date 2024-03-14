using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eTuristickaAgencija.Service.Migrations
{
    /// <inheritdoc />
    public partial class NoveOcjene : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
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

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "X/+vUioZak9IwR7KdQPskVqzyDo=", "mK41+MH6PzzIMBUqVg4Epw==" });

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "mobMqAxMeVtVv2FOH4THGoskJ18=", "onADX6oPz8UAHvJ3y5QGig==" });
        }
    }
}
