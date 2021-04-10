using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace NotesMarketPlace.Models
{
    public class Adminmanagesystemconfiguration
    {
        [RegularExpression(@"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$", ErrorMessage = "Enter valid emailid.")]
        [DataType(DataType.EmailAddress)]
        public string email { get; set; }

        [DataType(DataType.PhoneNumber)]
        [Required]
        public string phone { get; set; }

        [DataType(DataType.EmailAddress)]
        public string  emails{ get; set; }

        public string facebook { get; set; }

        public string linkedin { get; set; }

        public string twitter { get; set; }

        public HttpPostedFileBase  defaultnoteimg { get; set; }

        public HttpPostedFileBase defaultprofileimg { get; set; }

    }
}