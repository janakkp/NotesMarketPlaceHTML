using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace NotesMarketPlace.Models
{
    public class ForgotPassword
    {
        [DataType(DataType.EmailAddress, ErrorMessage = "E-mail is not valid")]
        [Required(ErrorMessage = "Email address name required")]
        public string EmailID { get; set; }

    }
}