using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace NotesMarketPlace.Models
{
    public class Adminmanageadministrator
    {
        public int id { set; get; }
        [MinLength(2)]
        [RegularExpression(@"^[a-zA-Z""'\s-]*$", ErrorMessage = "MinLength is 3")]
        [Required]
        public string firstname { set; get; }
        [MinLength(2)]
        [RegularExpression(@"^[a-zA-Z""'\s-]*$", ErrorMessage = "MinLength is 3")]
        [Required]
        public string lastname { set; get; }
        [DataType(DataType.EmailAddress)]
        [RegularExpression(@"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$", ErrorMessage = "E-mail is not valid")]
        [Required]
        public string email { set; get; }
        public string active { set; get; }

        [DataType(DataType.PhoneNumber)]
        public string phoneno { set; get; }
        public string phonecode { set; get; }
        public System.DateTime addeddate { set; get; }

    }
}