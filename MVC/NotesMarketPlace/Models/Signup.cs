using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace NotesMarketPlace.Models
{
    public class Signup
    {
        [MinLength(2)]
        [RegularExpression(@"^[a-zA-Z""'\s-]*$", ErrorMessage = "MinLength is 3")]
        [Required(ErrorMessage = "First name required")]
        public string FirstName { get; set; }


        [MinLength(4)]
        [RegularExpression(@"^[a-zA-Z""'\s-]*$", ErrorMessage = "MinLength is 3")]
        [Required(ErrorMessage = "Last name required")]
        public string LastName { get; set; }

        [RegularExpression(@"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")]
        [DataType(DataType.EmailAddress, ErrorMessage = "E-mail is not valid")]
        [Required(ErrorMessage = "Email address name required")]
        public string EmailID { get; set; }


        [DataType(DataType.Password)]
        [RegularExpression(@"^[0-9a-zA-Z!@#$%^&*0-9]{8,}$", ErrorMessage = "Enter valid Password")]
        [Required(ErrorMessage = "Password is required")]
        public string Password { get; set; }
        [DisplayName("Confirm Password")]
        [DataType(DataType.Password)]
        [Compare("Password")]
        public string ConfirmPassword { get; set; }
    }
}