using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace NotesMarketPlace.Models
{
    public class Login
    {
        [DataType(DataType.EmailAddress)]
        [RegularExpression(@"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$", ErrorMessage = "E-mail is not valid")]
        [Required]
        public string EmailID { get; set; }


        [DataType(DataType.Password)]
        [RegularExpression(@"^[0-9a-zA-Z!@#$%^&*0-9]{8,}$", ErrorMessage = "Enter valid Password")]
        [Required]
        public string Password { get; set; }

        public Boolean rememberme { get; set; }

    }
}