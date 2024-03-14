using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eTuristickaAgencija.Service.Migrations
{
    /// <inheritdoc />
    public partial class hotel : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "Q7xP0BhBd3ulh0GrA7RHB68CPz0=", "EUcrg5ZptGcUrUaIYzzhmg==" });

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "EXSPOMngdCFvitL17F0ucUY+4Jc=", "NU9tKlNNNddsdSpVRSsPtQ==" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "6tFfUO736gJr3IAki0bS4OQBY4A=", "6g9qOnllqyvXiKYbzMFrAQ==" });

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "sHOCM/vwno+xOmo07G0S+ZPkZGs=", "S/Cp76a0Wjn4KutxVysvdg==" });
        }
    }
}
