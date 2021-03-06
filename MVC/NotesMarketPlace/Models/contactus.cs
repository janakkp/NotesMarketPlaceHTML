﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace NotesMarketPlace.Models
{
    public class contactus
    {

        [MinLength(4)]
        [Required(ErrorMessage = "Please enter the Your Name")]
        public string Name { get; set; }

        [RegularExpression(@"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")]
        [MinLength(3)]
        [Required(ErrorMessage = "Please enter the Your EmailId")]
        public string EmailID { get; set; }

        
        [MinLength(5)]
        [Required(ErrorMessage = "Field is required")]
        public string Subject { get; set; }


        [MinLength(10)]
        [Required(ErrorMessage = "Please enter your comment")]
        public string Comment { get; set; }
    }
}