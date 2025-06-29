using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eTuristickaAgencija.Service.Migrations
{
    /// <inheritdoc />
    public partial class sifra : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "bETqoyxSiCjQvfUibQhvKq3/6rA=", "AfyHRCYBg9qfZHC0DleYQg==" });

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "Email", "Ime", "LozinkaHash", "LozinkaSalt", "Prezime" },
                values: new object[] { "amna@gmail.com", "Amna", "IMfi53brfYYGJbAhvnvtS4WSCUY=", "c/J37atIQgQM4oK8hv9CCA==", "Spahalic" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "0Mo2rJj1xvtid1iyvw5LPY49W+q8Py4Qgalkp4Lwhqs=", "bPnBuRf/tcAxKGGRTcl67w==" });

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "Email", "Ime", "LozinkaHash", "LozinkaSalt", "Prezime" },
                values: new object[] { "test@gmail.com", "test", "qv2vZ8c9cIzqC7N/qL4o4BKAwiACdmjHay1V26EMDBI=", "mTfIXiIP8ketWx+Bi/jCCA==", "test" });
        }
    }
}
