﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eTuristickaAgencija.Models.Request
{
    public class GradoviUpdateRequest
    {
        
        public string Naziv { get; set; }
    
        public int DrzavaId { get; set; }
    }
}
