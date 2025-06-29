using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eTuristickaAgencija.Service.Migrations
{
    /// <inheritdoc />
    public partial class _11 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "YHQMughCbJcTRwsPvai9xMTTcAs=", "mh2X/uW7j70mFlTRwl+oHw==" });

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "jDwZnRBLTgFPKAthMvTcnn1vkvA=", "lBGENlcr7J6Qhyg6ipJJUw==" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "MOFDpaJlZtsNT9LJgbRfQ0Qywvc=", "tLmh+Exx0hroSz0zKwIlrA==" });

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "lCdfh4wGrfoA73XlT/HQzxJ1keU=", "U0EKoTs6LktvTMMXoWT3Jg==" });
        }
    }
}
