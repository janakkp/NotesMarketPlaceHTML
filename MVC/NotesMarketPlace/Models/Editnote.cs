using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace NotesMarketPlace.Models
{
    public class Editnote
    {
        public int noteid { get; set; }
        public string Button { get; set; }

        [Required(ErrorMessage = "This field is required.")]
        public string Title { get; set; }
        public Nullable<int> Category { get; set; }
        public Nullable<int> Type { get; set; }
        public Nullable<int> NumberOfPages { get; set; }
        public string Description { get; set; }
        public string UniversityName { get; set; }
        public Nullable<int> Country { get; set; }
        public string Course { get; set; }
        public string CourseCode { get; set; }
        public string Professor { get; set; }
        public Nullable<int> IsPaid { get; set; }
        public Nullable<decimal> SellingPrice { get; set; }
        public HttpPostedFileBase DisplayPictureFile { get; set; }
        public HttpPostedFileBase FileName { get; set; }
        public HttpPostedFileBase NotesPreviewFile { get; set; }

    }
}