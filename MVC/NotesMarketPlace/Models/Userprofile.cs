using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace NotesMarketPlace.Models
{
    public class Userprofile
    {
 
        [Required(ErrorMessage = "This field is required.")]
        public string FirstName { get; set; }

        [Required(ErrorMessage = "This field is required.")]
        public string LastName { get; set; }
        
        public Nullable<System.DateTime> DOB { get; set; }
        
        public Nullable<int> Gender { get; set; }

        [Required(ErrorMessage = "This field is required.")]
        public string SecondaryEmailAddress { get; set; }
        
        [Required(ErrorMessage = "This field is required.")]
        public int PhoneNumberCountryCode { get; set; }

        [Required(ErrorMessage = "This field is required.")]
        public string PhoneNumber { get; set; }
        
        public string ProfilePicture { get; set; }
        
        [Required(ErrorMessage = "This field is required.")]
        public string AddressLine1 { get; set; }
        
        [Required(ErrorMessage = "This field is required.")]
        public string AddressLine2 { get; set; }
        
        [Required(ErrorMessage = "This field is required.")]
        public string City { get; set; }
        
        [Required(ErrorMessage = "This field is required.")]
        public string State { get; set; }
        
        [Required(ErrorMessage = "This field is required.")]
        public string ZipCode { get; set; }
        
        public string Country { get; set; }
        
        public string University { get; set; }
        
        public string College { get; set; }
        
        public HttpPostedFileBase UserProfilePic { get; set; }

    }
}