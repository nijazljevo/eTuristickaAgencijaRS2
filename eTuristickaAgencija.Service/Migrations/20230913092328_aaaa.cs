using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eTuristickaAgencija.Service.Migrations
{
    /// <inheritdoc />
    public partial class aaaa : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
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
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "qv2vZ8c9cIzqC7N/qL4o4BKAwiACdmjHay1V26EMDBI=", "mTfIXiIP8ketWx+Bi/jCCA==" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "M8HHhjL7+QyAdYiIzEHJtbdThPkbNuaiCL/bTIn5oRw=", "f2F5paHVQsxNZGes9VUYtQ==" });

            migrationBuilder.UpdateData(
                table: "Korisnik",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "7oBzsdmlDS7+wzvBNnRdyEBwKkMo0r+n9uX8Eg84ETI=", "zkw/DSpf+xXzxboIODmSig==" });
        }
    }
}
