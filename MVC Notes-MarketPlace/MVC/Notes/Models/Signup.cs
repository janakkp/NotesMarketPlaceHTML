using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace Notes.Models
{
    public class Signup
    {
        [MinLength(2)]
        [RegularExpression(@"^[a-zA-Z""'\s-]*$", ErrorMessage = "MinLength is 3")]
        [Required]
        public string FirstName { get; set; }


        [MinLength(4)]
        [RegularExpression(@"^[a-zA-Z""'\s-]*$", ErrorMessage = "MinLength is 3")]
        [Required]
        public string LastName { get; set; }

        [RegularExpression(@"^[a-zA-Z0-9+_.-]+@[a-zA-Z.-]+$", ErrorMessage = "Enter valid emailid.")]
        [DataType(DataType.EmailAddress)]
        [Required]
        public string EmailID { get; set; }


        [DataType(DataType.Password)]
        [RegularExpression(@"^[0-9a-zA-Z!@#$%^&*0-9]{8,}$", ErrorMessage = "Enter valid password.")]
        [Required]
        public string Password { get; set; }

        [DisplayName("Confirm Password")]
        [DataType(DataType.Password)]
        [Compare("Password")]
        public string ConfirmPassword { get; set; }
    }
}