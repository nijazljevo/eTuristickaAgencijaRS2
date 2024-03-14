using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace eTuristickaAgencija.Service.Migrations
{
    /// <inheritdoc />
    public partial class dataseed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Agencija",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Adresa = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    Telefon = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Agencija", x => x.ID);
                });

            migrationBuilder.CreateTable(
                name: "Kontinent",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Kontinent", x => x.ID);
                });

            migrationBuilder.CreateTable(
                name: "Uloga",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Uloga", x => x.ID);
                });

            migrationBuilder.CreateTable(
                name: "Drzava",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    KontinentID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Drzava", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Kontinent_Drzava",
                        column: x => x.KontinentID,
                        principalTable: "Kontinent",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateTable(
                name: "Korisnik",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Prezime = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    KorisnikoIme = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    LozinkaHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LozinkaSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    Email = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    UlogaID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Korisnik", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Korisnik_Uloga",
                        column: x => x.UlogaID,
                        principalTable: "Uloga",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateTable(
                name: "Grad",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    DrzavaID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Grad", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Grad_Drzava",
                        column: x => x.DrzavaID,
                        principalTable: "Drzava",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateTable(
                name: "Clan",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikID = table.Column<int>(type: "int", nullable: true),
                    DatumRegistracije = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Clan", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Clan_korisnik",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateTable(
                name: "Uplate",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Iznos = table.Column<decimal>(type: "decimal(10,2)", nullable: true),
                    KorisnikId = table.Column<int>(type: "int", nullable: true),
                    DatumTransakcije = table.Column<DateTime>(type: "datetime", nullable: true),
                    BrojTransakcije = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Uplate__3214EC0785DC839F", x => x.Id);
                    table.ForeignKey(
                        name: "FK__Uplate__Korisnik__6FE99F9F",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateTable(
                name: "Uposlenik",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikID = table.Column<int>(type: "int", nullable: true),
                    DatumZaposlenja = table.Column<DateTime>(type: "datetime", nullable: true),
                    Aktivan = table.Column<bool>(type: "bit", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Uposlenik", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Uposlenik_korisnik",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateTable(
                name: "Destinacija",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    GradID = table.Column<int>(type: "int", nullable: true),
                    StateMachine = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Destinacija", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Grad_Destinacija",
                        column: x => x.GradID,
                        principalTable: "Grad",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateTable(
                name: "Hotel",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    GradID = table.Column<int>(type: "int", nullable: true),
                    BrojZvjezdica = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Hotel", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Grad1",
                        column: x => x.GradID,
                        principalTable: "Grad",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateTable(
                name: "Ocjena",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    OcjenaUsluge = table.Column<int>(type: "int", nullable: false),
                    Komentar = table.Column<string>(type: "text", nullable: true),
                    DestinacijaID = table.Column<int>(type: "int", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Ocjena", x => x.ID);
                    table.ForeignKey(
                        name: "fk_Destinacija",
                        column: x => x.DestinacijaID,
                        principalTable: "Destinacija",
                        principalColumn: "ID");
                    table.ForeignKey(
                        name: "fk_Korisnik",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateTable(
                name: "Rezervacija",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Cijena = table.Column<decimal>(type: "decimal(8,2)", nullable: false),
                    HotelID = table.Column<int>(type: "int", nullable: true),
                    Otkazana = table.Column<bool>(type: "bit", nullable: true),
                    DatumRezervacije = table.Column<DateTime>(type: "datetime", nullable: false),
                    KorisnikID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Rezervacija", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Rezervacija_Hotel",
                        column: x => x.HotelID,
                        principalTable: "Hotel",
                        principalColumn: "ID");
                    table.ForeignKey(
                        name: "FK_Rezervacija_Korisnik",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateTable(
                name: "Termin",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DestinacijaID = table.Column<int>(type: "int", nullable: true),
                    Cijena = table.Column<decimal>(type: "decimal(8,2)", nullable: false),
                    Popust = table.Column<float>(type: "real", nullable: true),
                    HotelID = table.Column<int>(type: "int", nullable: true),
                    CijenaPopust = table.Column<decimal>(type: "decimal(8,2)", nullable: true),
                    AktivanTermin = table.Column<bool>(type: "bit", nullable: true),
                    DatumPolaska = table.Column<DateTime>(type: "datetime", nullable: false),
                    DatumDolaska = table.Column<DateTime>(type: "datetime", nullable: false),
                    GradID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Termin", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Angazman_Hotel",
                        column: x => x.HotelID,
                        principalTable: "Hotel",
                        principalColumn: "ID");
                    table.ForeignKey(
                        name: "FK_Termin_Destinacija",
                        column: x => x.DestinacijaID,
                        principalTable: "Destinacija",
                        principalColumn: "ID");
                    table.ForeignKey(
                        name: "FK_Termin_Grad",
                        column: x => x.GradID,
                        principalTable: "Grad",
                        principalColumn: "ID");
                });

            migrationBuilder.CreateTable(
                name: "Karta",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TerminID = table.Column<int>(type: "int", nullable: true),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime", nullable: false),
                    Ponistena = table.Column<bool>(type: "bit", nullable: false),
                    KorisnikID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Karta", x => x.ID);
                    table.ForeignKey(
                        name: "FK_Karta_Termin",
                        column: x => x.TerminID,
                        principalTable: "Termin",
                        principalColumn: "ID");
                    table.ForeignKey(
                        name: "fk_Korisnik_Karta",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnik",
                        principalColumn: "ID");
                });

            migrationBuilder.InsertData(
                table: "Agencija",
                columns: new[] { "ID", "Adresa", "Email", "Telefon" },
                values: new object[] { 1, "Trg Ivana Krndelja 35, 88000 Mostar", "agencija@gmail.com", "061-235-886" });

            migrationBuilder.InsertData(
                table: "Kontinent",
                columns: new[] { "ID", "Naziv" },
                values: new object[,]
                {
                    { 1, "Evropa" },
                    { 2, "Azija" }
                });

            migrationBuilder.InsertData(
                table: "Uloga",
                columns: new[] { "ID", "Naziv" },
                values: new object[,]
                {
                    { 1, "Admin" },
                    { 2, "Turist" }
                });

            migrationBuilder.InsertData(
                table: "Drzava",
                columns: new[] { "ID", "KontinentID", "Naziv" },
                values: new object[,]
                {
                    { 1, 1, "Turska" },
                    { 2, 2, "Malezija" }
                });

            migrationBuilder.InsertData(
                table: "Korisnik",
                columns: new[] { "ID", "Email", "Ime", "KorisnikoIme", "LozinkaHash", "LozinkaSalt", "Prezime", "Slika", "UlogaID" },
                values: new object[,]
                {
                    { 1, "nijaz@gmail.com", "Nijaz", "admin", "MSGjpAW8IykbbTyw5Y6lA0PP9H8=", "a8eFAPndUYNa9N4OKBzvaQ==", "Ljevo", null, 1 },
                    { 2, "amna@gmail.com", "Amna", "mobile", "clRZxhF9jPoDvFxpfZQHisUL0/s=", "Lu7sAE3kAOmL7eU/Szkq5A==", "Spahalic", null, 2 }
                });

            migrationBuilder.InsertData(
                table: "Clan",
                columns: new[] { "ID", "DatumRegistracije", "KorisnikID" },
                values: new object[] { 1, new DateTime(2021, 7, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), 2 });

            migrationBuilder.InsertData(
                table: "Grad",
                columns: new[] { "ID", "DrzavaID", "Naziv" },
                values: new object[,]
                {
                    { 1, 1, "Istanbul" },
                    { 2, 2, "Kuala Lumpur" }
                });

            migrationBuilder.InsertData(
                table: "Uplate",
                columns: new[] { "Id", "BrojTransakcije", "DatumTransakcije", "Iznos", "KorisnikId" },
                values: new object[] { 1, null, null, 500m, 2 });

            migrationBuilder.InsertData(
                table: "Uposlenik",
                columns: new[] { "ID", "Aktivan", "DatumZaposlenja", "KorisnikID" },
                values: new object[] { 1, true, new DateTime(2020, 9, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1 });

            migrationBuilder.InsertData(
                table: "Destinacija",
                columns: new[] { "ID", "GradID", "Naziv", "Slika", "StateMachine" },
                values: new object[,]
                {
                    { 1, 2, "Putovanje u Maleziju", null, null },
                    { 2, 1, "Putovanje u Istanbul", null, null },
                    { 3, 1, "Putovanje u Istanbul2", null, null },
                    { 4, 2, "Putovanje u Maleziju2", null, null }
                });

            migrationBuilder.InsertData(
                table: "Hotel",
                columns: new[] { "ID", "BrojZvjezdica", "GradID", "Naziv", "Slika" },
                values: new object[,]
                {
                    { 1, 5, 2, "Levent", null },
                    { 2, 4, 1, "Hotel Malezija", null }
                });

            migrationBuilder.InsertData(
                table: "Ocjena",
                columns: new[] { "ID", "DestinacijaID", "Komentar", "KorisnikID", "OcjenaUsluge" },
                values: new object[] { 1, 1, "Odlicno", 2, 5 });

            migrationBuilder.InsertData(
                table: "Rezervacija",
                columns: new[] { "ID", "Cijena", "DatumRezervacije", "HotelID", "KorisnikID", "Otkazana" },
                values: new object[] { 1, 300m, new DateTime(2020, 9, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, 2, false });

            migrationBuilder.InsertData(
                table: "Termin",
                columns: new[] { "ID", "AktivanTermin", "Cijena", "CijenaPopust", "DatumDolaska", "DatumPolaska", "DestinacijaID", "GradID", "HotelID", "Popust" },
                values: new object[,]
                {
                    { 1, true, 900m, 0m, new DateTime(2021, 8, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2021, 8, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, 2, 1, 0f },
                    { 2, true, 700m, 0m, new DateTime(2021, 9, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2021, 9, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, 2, 1, 0f },
                    { 3, true, 1100m, 0m, new DateTime(2022, 1, 27, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2022, 1, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 2, 1, 0f },
                    { 4, true, 1300m, 0m, new DateTime(2021, 8, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2021, 7, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 2, 1, 0f },
                    { 5, true, 1300m, 0m, new DateTime(2022, 4, 22, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2022, 3, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, 1, 2, 0f },
                    { 6, true, 1200m, 0m, new DateTime(2021, 7, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2021, 6, 21, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, 1, 2, 0f },
                    { 7, true, 1500m, 0m, new DateTime(2021, 8, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2021, 7, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), 4, 1, 2, 0f }
                });

            migrationBuilder.InsertData(
                table: "Karta",
                columns: new[] { "ID", "DatumKreiranja", "KorisnikID", "Ponistena", "TerminID" },
                values: new object[] { 1, new DateTime(2020, 9, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, false, 1 });

            migrationBuilder.CreateIndex(
                name: "IX_Clan_KorisnikID",
                table: "Clan",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Destinacija_GradID",
                table: "Destinacija",
                column: "GradID");

            migrationBuilder.CreateIndex(
                name: "IX_Drzava_KontinentID",
                table: "Drzava",
                column: "KontinentID");

            migrationBuilder.CreateIndex(
                name: "IX_Grad_DrzavaID",
                table: "Grad",
                column: "DrzavaID");

            migrationBuilder.CreateIndex(
                name: "IX_Hotel_GradID",
                table: "Hotel",
                column: "GradID");

            migrationBuilder.CreateIndex(
                name: "IX_Karta_KorisnikID",
                table: "Karta",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Karta_TerminID",
                table: "Karta",
                column: "TerminID");

            migrationBuilder.CreateIndex(
                name: "IX_Korisnik_UlogaID",
                table: "Korisnik",
                column: "UlogaID");

            migrationBuilder.CreateIndex(
                name: "IX_Ocjena_DestinacijaID",
                table: "Ocjena",
                column: "DestinacijaID");

            migrationBuilder.CreateIndex(
                name: "IX_Ocjena_KorisnikID",
                table: "Ocjena",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Rezervacija_HotelID",
                table: "Rezervacija",
                column: "HotelID");

            migrationBuilder.CreateIndex(
                name: "IX_Rezervacija_KorisnikID",
                table: "Rezervacija",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Termin_DestinacijaID",
                table: "Termin",
                column: "DestinacijaID");

            migrationBuilder.CreateIndex(
                name: "IX_Termin_GradID",
                table: "Termin",
                column: "GradID");

            migrationBuilder.CreateIndex(
                name: "IX_Termin_HotelID",
                table: "Termin",
                column: "HotelID");

            migrationBuilder.CreateIndex(
                name: "IX_Uplate_KorisnikId",
                table: "Uplate",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Uposlenik_KorisnikID",
                table: "Uposlenik",
                column: "KorisnikID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Agencija");

            migrationBuilder.DropTable(
                name: "Clan");

            migrationBuilder.DropTable(
                name: "Karta");

            migrationBuilder.DropTable(
                name: "Ocjena");

            migrationBuilder.DropTable(
                name: "Rezervacija");

            migrationBuilder.DropTable(
                name: "Uplate");

            migrationBuilder.DropTable(
                name: "Uposlenik");

            migrationBuilder.DropTable(
                name: "Termin");

            migrationBuilder.DropTable(
                name: "Korisnik");

            migrationBuilder.DropTable(
                name: "Hotel");

            migrationBuilder.DropTable(
                name: "Destinacija");

            migrationBuilder.DropTable(
                name: "Uloga");

            migrationBuilder.DropTable(
                name: "Grad");

            migrationBuilder.DropTable(
                name: "Drzava");

            migrationBuilder.DropTable(
                name: "Kontinent");
        }
    }
}
