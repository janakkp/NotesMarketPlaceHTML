using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace Notes.Models
{
    public class Addnote
    {
        public string Button { get; set; }

        [MinLength(2)]
        [RegularExpression(@"^[a-zA-Z0-9""'\s-]*$", ErrorMessage = "MinLength is 4")]
        [Required(ErrorMessage = "This field is required.")]
        public string Title { get; set; }


        [Required(ErrorMessage = "This field is required.")]
        public int Category { get; set; }


        [Required(ErrorMessage = "This field is required.")]
        public int Type { get; set; }

        public Nullable<int> NumberOfPages { get; set; }


        [MinLength(20)]
        [Required(ErrorMessage = "This field is required.")]
        public string Description { get; set; }

        public string UniversityName { get; set; }


        [Required(ErrorMessage = "This field is required.")]
        public int Country { get; set; }

        public string Course { get; set; }

        public string CourseCode { get; set; }

        public string Professor { get; set; }

        [Required(ErrorMessage = "This field is required.")]
        public int IsPaid { get; set; }

        public Nullable<decimal> SellingPrice { get; set; }


        public HttpPostedFileBase DisplayPictureFile { get; set; }


        [Required(ErrorMessage = "This field is required.")]
        public HttpPostedFileBase FileName { get; set; }

        
        public HttpPostedFileBase NotesPreviewFile { get; set; }

    }
}