using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eTuristickaAgencija.Service.Migrations
{
    /// <inheritdoc />
    public partial class slika : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "t2NRCOy1NXUXpF2nz/NSnG66Jc0=", "TlniqW5IKSAijMA6wg7k+w==" });

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "0QWfdvLKHNCXTITyiY1UqZNtMjE=", "kLXh1QHgSU5Q4/mlRyntRQ==" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "XpTaNNeppaR60dfMWrjjw0LEts0=", "yPPh1N/F1JFVYiLN//9X0g==" });

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "0C0Pkz4gNPhOyb8IWelJSRF5Xi0=", "r1WLWfFEeQwZlmAoPknKHQ==" });
        }
    }
}
