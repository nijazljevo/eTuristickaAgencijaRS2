using eTuristickaAgencija.Models.Request;
using eTuristickaAgencija.Service;
using eTuristickaAgencija.Service.Database;
using Microsoft.EntityFrameworkCore;
using eTuristickaAgencija.Models;
using Stripe;
using Microsoft.AspNetCore.Authentication;
using eTuriatickaAgencija;
using eTuriatickaAgencija.Filters;
using Microsoft.OpenApi.Models;
using eTuristickaAgencija.Service.DestinacijeStateMachine;
using RabbitMQ.Client;
using eTuristickaAgencija.Service.RabbitMQ;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<IKorisniciService, KorisniciService>();
builder.Services.AddTransient<IAgencijaService, AgencijaService>();
builder.Services.AddTransient<IClanService, ClanoviService>();
builder.Services.AddTransient<IDestinacijaService, DestinacijeService>();
builder.Services.AddTransient<IDrzavaService, DrzaveService>();
builder.Services.AddTransient<IGradService, GradoviService>();
builder.Services.AddTransient<IHotelService, HoteliService>();
builder.Services.AddTransient<IKartaService, KarteService>();
builder.Services.AddTransient<IKontinentService, KontinentiService>();
builder.Services.AddTransient<IOcjenaService, OcjeneService>();
builder.Services.AddTransient<IRezervacijaService, RezervacijaService>();
builder.Services.AddTransient<ITerminService, TerminiService>();
builder.Services.AddTransient<IUposlenikService, UposlenikService>();
builder.Services.AddTransient<IUlogeService, UlogeService>();
builder.Services.AddTransient<IUplataService, UplataService>();

builder.Services.AddTransient<BaseState>();
builder.Services.AddTransient<InitialDestinationState>();
builder.Services.AddTransient<DraftDestinationState>();
builder.Services.AddTransient<ActiveDestinationState>();
builder.Services.AddTransient<IRabbitMQProducer, RabbitMQProducer>();

builder.Services.AddAutoMapper(typeof(IKorisniciService));

builder.Services.AddControllers(x =>
{
    x.Filters.Add<ErrorFilter>();
});
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
            },
            new string[]{}
    } });

});


var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<TuristickaAgencijaContext>(options =>
options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(IKorisniciService));
builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<TuristickaAgencijaContext>();
    //dataContext.Database.EnsureCreated();

    var conn = dataContext.Database.GetConnectionString();

    dataContext.Database.Migrate();


}

app.Run();
