using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace eTuristickaAgencija.Service.Database;

public partial class TuristickaAgencijaContext : DbContext
{
    public TuristickaAgencijaContext()
    {
    }

    public TuristickaAgencijaContext(DbContextOptions<TuristickaAgencijaContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Agencija> Agencijas { get; set; }

    public virtual DbSet<Clan> Clans { get; set; }

    public virtual DbSet<Destinacija> Destinacijas { get; set; }

    public virtual DbSet<Drzava> Drzavas { get; set; }

    public virtual DbSet<Grad> Grads { get; set; }

    public virtual DbSet<Hotel> Hotels { get; set; }

    public virtual DbSet<Kartum> Karta { get; set; }

    public virtual DbSet<Kontinent> Kontinents { get; set; }

    public virtual DbSet<Korisnik> Korisniks { get; set; }

    public virtual DbSet<Ocjena> Ocjenas { get; set; }

    public virtual DbSet<Rezervacija> Rezervacijas { get; set; }

    public virtual DbSet<Termin> Termins { get; set; }

    public virtual DbSet<Uloga> Ulogas { get; set; }

    public virtual DbSet<Uplate> Uplates { get; set; }

    public virtual DbSet<Uposlenik> Uposleniks { get; set; }

 //   protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
//#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
  //      => optionsBuilder.UseSqlServer("Data Source=localhost, 1433;Initial Catalog=TuristickaAgencija; user=sa; Password=ASas.,12; TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Agencija>(entity =>
        {
            entity.ToTable("Agencija");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Adresa).HasMaxLength(50);
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.Telefon).HasMaxLength(50);
        });

        modelBuilder.Entity<Clan>(entity =>
        {
            entity.ToTable("Clan");

            entity.HasIndex(e => e.KorisnikId, "IX_Clan_KorisnikID");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.DatumRegistracije).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Clans)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK_Clan_korisnik");
        });

        modelBuilder.Entity<Destinacija>(entity =>
        {
            entity.ToTable("Destinacija");

            entity.HasIndex(e => e.GradId, "IX_Destinacija_GradID");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.GradId).HasColumnName("GradID");
            entity.Property(e => e.Naziv).HasMaxLength(50);

            entity.HasOne(d => d.Grad).WithMany(p => p.Destinacijas)
                .HasForeignKey(d => d.GradId)
                .HasConstraintName("FK_Grad_Destinacija");
        });

        modelBuilder.Entity<Drzava>(entity =>
        {
            entity.ToTable("Drzava");

            entity.HasIndex(e => e.KontinentId, "IX_Drzava_KontinentID");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.KontinentId).HasColumnName("KontinentID");
            entity.Property(e => e.Naziv).HasMaxLength(50);

            entity.HasOne(d => d.Kontinent).WithMany(p => p.Drzavas)
                .HasForeignKey(d => d.KontinentId)
                .HasConstraintName("FK_Kontinent_Drzava");
        });

        modelBuilder.Entity<Grad>(entity =>
        {
            entity.ToTable("Grad");

            entity.HasIndex(e => e.DrzavaId, "IX_Grad_DrzavaID");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.DrzavaId).HasColumnName("DrzavaID");
            entity.Property(e => e.Naziv).HasMaxLength(50);

            entity.HasOne(d => d.Drzava).WithMany(p => p.Grads)
                .HasForeignKey(d => d.DrzavaId)
                .HasConstraintName("FK_Grad_Drzava");
        });

        modelBuilder.Entity<Hotel>(entity =>
        {
            entity.ToTable("Hotel");

            entity.HasIndex(e => e.GradId, "IX_Hotel_GradID");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.GradId).HasColumnName("GradID");
            entity.Property(e => e.Naziv).HasMaxLength(50);

            entity.HasOne(d => d.Grad).WithMany(p => p.Hotels)
                .HasForeignKey(d => d.GradId)
                .HasConstraintName("FK_Grad1");
        });

        modelBuilder.Entity<Kartum>(entity =>
        {
            entity.HasIndex(e => e.KorisnikId, "IX_Karta_KorisnikID");

            entity.HasIndex(e => e.TerminId, "IX_Karta_TerminID");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.TerminId).HasColumnName("TerminID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Karta)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("fk_Korisnik_Karta");

            entity.HasOne(d => d.Termin).WithMany(p => p.Karta)
                .HasForeignKey(d => d.TerminId)
                .HasConstraintName("FK_Karta_Termin");
        });

        modelBuilder.Entity<Kontinent>(entity =>
        {
            entity.ToTable("Kontinent");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Naziv).HasMaxLength(50);
        });

        modelBuilder.Entity<Korisnik>(entity =>
        {
            entity.ToTable("Korisnik");

            entity.HasIndex(e => e.UlogaId, "IX_Korisnik_UlogaID");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.Ime).HasMaxLength(50);
            entity.Property(e => e.KorisnikoIme).HasMaxLength(50);
            entity.Property(e => e.Prezime).HasMaxLength(50);
            entity.Property(e => e.UlogaId).HasColumnName("UlogaID");

            entity.HasOne(d => d.Uloga).WithMany(p => p.Korisniks)
                .HasForeignKey(d => d.UlogaId)
                .HasConstraintName("FK_Korisnik_Uloga");
        });

        modelBuilder.Entity<Ocjena>(entity =>
        {
            entity.ToTable("Ocjena");

            entity.HasIndex(e => e.DestinacijaId, "IX_Ocjena_DestinacijaID");

            entity.HasIndex(e => e.KorisnikId, "IX_Ocjena_KorisnikID");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.DestinacijaId).HasColumnName("DestinacijaID");
            entity.Property(e => e.Komentar).HasColumnType("text");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

            entity.HasOne(d => d.Destinacija).WithMany(p => p.Ocjenas)
                .HasForeignKey(d => d.DestinacijaId)
                .HasConstraintName("fk_Destinacija");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Ocjenas)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("fk_Korisnik");
        });

        modelBuilder.Entity<Rezervacija>(entity =>
        {
            entity.ToTable("Rezervacija");

            entity.HasIndex(e => e.HotelId, "IX_Rezervacija_HotelID");

            entity.HasIndex(e => e.KorisnikId, "IX_Rezervacija_KorisnikID");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Cijena).HasColumnType("decimal(8, 2)");
            entity.Property(e => e.DatumRezervacije).HasColumnType("datetime");
            entity.Property(e => e.HotelId).HasColumnName("HotelID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

            entity.HasOne(d => d.Hotel).WithMany(p => p.Rezervacijas)
                .HasForeignKey(d => d.HotelId)
                .HasConstraintName("FK_Rezervacija_Hotel");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Rezervacijas)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK_Rezervacija_Korisnik");
        });

        modelBuilder.Entity<Termin>(entity =>
        {
            entity.ToTable("Termin");

            entity.HasIndex(e => e.DestinacijaId, "IX_Termin_DestinacijaID");

            entity.HasIndex(e => e.GradId, "IX_Termin_GradID");

            entity.HasIndex(e => e.HotelId, "IX_Termin_HotelID");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Cijena).HasColumnType("decimal(8, 2)");
            entity.Property(e => e.CijenaPopust).HasColumnType("decimal(8, 2)");
            entity.Property(e => e.DatumDolaska).HasColumnType("datetime");
            entity.Property(e => e.DatumPolaska).HasColumnType("datetime");
            entity.Property(e => e.DestinacijaId).HasColumnName("DestinacijaID");
            entity.Property(e => e.GradId).HasColumnName("GradID");
            entity.Property(e => e.HotelId).HasColumnName("HotelID");

            entity.HasOne(d => d.Destinacija).WithMany(p => p.Termins)
                .HasForeignKey(d => d.DestinacijaId)
                .HasConstraintName("FK_Termin_Destinacija");

            entity.HasOne(d => d.Grad).WithMany(p => p.Termins)
                .HasForeignKey(d => d.GradId)
                .HasConstraintName("FK_Termin_Grad");

            entity.HasOne(d => d.Hotel).WithMany(p => p.Termins)
                .HasForeignKey(d => d.HotelId)
                .HasConstraintName("FK_Angazman_Hotel");
        });

        modelBuilder.Entity<Uloga>(entity =>
        {
            entity.ToTable("Uloga");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Naziv).HasMaxLength(50);
        });

        modelBuilder.Entity<Uplate>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Uplate__3214EC0785DC839F");

            entity.ToTable("Uplate");

            entity.Property(e => e.DatumTransakcije).HasColumnType("datetime");
            entity.Property(e => e.Iznos).HasColumnType("decimal(10, 2)");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Uplates)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Uplate__Korisnik__6FE99F9F");
        });

        modelBuilder.Entity<Uposlenik>(entity =>
        {
            entity.ToTable("Uposlenik");

            entity.HasIndex(e => e.KorisnikId, "IX_Uposlenik_KorisnikID");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.DatumZaposlenja).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Uposleniks)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK_Uposlenik_korisnik");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
