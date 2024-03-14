using eTuristickaAgencija.Models;
using eTuristickaAgencija.Models.Request;
using eTuristickaAgencija.Models.Search_Objects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eTuristickaAgencija.Service
{
    public interface IGradService : ICRUDService<Grad,GradSearchObject, GradoviInsertRequest,GradoviUpdateRequest>
    {
        
    }
}
