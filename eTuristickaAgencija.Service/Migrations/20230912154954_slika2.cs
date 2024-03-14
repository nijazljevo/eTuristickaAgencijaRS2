using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eTuristickaAgencija.Service.Migrations
{
    /// <inheritdoc />
    public partial class slika2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "e+QVu/wa8hQP5L2U9noHX/DBnyRjyDT1g+lWwn9g8GM=", "fOpTlLK6TiuliPhVxcwtzA==" });

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "0dm7nBvbX9i6T5sF7ZGoo0befpt86uISfMvnYa6qfIU=", "0WBMvnU0AtVlyl0wfQ7OMw==" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "VakemccgSerME7cp7degDwh+HcLzWNZoLKUy7niQ274=", "lhWOGx2QfpMmOyWDEZ3Wuw==" });

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "4ZYtJCUmdiRpQDndCyn5T9xOI/LUDMIPrTsFPcgkuCE=", "SM5evrfHElibg4iUg+W5Lw==" });
        }
    }
}
