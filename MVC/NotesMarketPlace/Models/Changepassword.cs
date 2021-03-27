using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace NotesMarketPlace.Models
{
    public class Changepassword
    {
        [DataType(DataType.Password)]
        [Required(ErrorMessage = "Please enter your password.")]
        public string OldPassword { get; set; }

        [DataType(DataType.Password)]
        [RegularExpression(@"^[0-9a-zA-Z!@#$%^&*0-9]{8,}$", ErrorMessage = "Enter valid Password")]
        [Required(ErrorMessage = "Please enter your new password.")]
        public string NewPassword { get; set; }

        [DataType(DataType.Password)]
        [Compare("NewPassword")]
        [Required(ErrorMessage = "Please enter confirm password.")]
        public string ConfirmPassword { get; set; }



    }
}