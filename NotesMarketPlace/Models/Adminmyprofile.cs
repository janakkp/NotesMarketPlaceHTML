using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace NotesMarketPlace.Models
{
    public class Adminmyprofile
    {
        [MinLength(2)]
        [RegularExpression(@"^[a-zA-Z""'\s-]*$", ErrorMessage = "MinLength is 4")]
        [Required(ErrorMessage = "This field is required.")]
        public string firstname { set; get; }

        [MinLength(2)]
        [RegularExpression(@"^[a-zA-Z""'\s-]*$", ErrorMessage = "MinLength is 4")]
        [Required(ErrorMessage = "This field is required.")]
        public string lastname { set; get; }

        [DataType(DataType.EmailAddress)]
        [RegularExpression(@"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$", ErrorMessage = "E-mail is not valid")]
        [Required]
        public string email { set; get; }
        public string secondaryemail { set; get; }

        [Required]
        public string phonecode { set; get; }
        
        [DataType(DataType.PhoneNumber)]
        [Required]
        public string phonenumber { set; get; }
        public HttpPostedFileBase UserProfilePic { get; set; }
    }
}