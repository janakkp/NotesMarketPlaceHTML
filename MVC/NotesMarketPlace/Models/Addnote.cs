using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;


namespace NotesMarketPlace.Models
{
    public class Addnote
    {
        public string Button { get; set; }

        [MinLength(4)]
        [RegularExpression(@"^[a-zA-Z""'\s-]*$", ErrorMessage = "MinLength is 4")]
        [Required(ErrorMessage = "Please enter the Title")]
        public string Title { get; set; }


        [Required(ErrorMessage = "Please select the category")]
        public int Category { get; set; }


        public int Type { get; set; }

        public Nullable<int> NumberOfPages { get; set; }


        [MinLength(20)]
        [Required(ErrorMessage = "Please enter Description")]
        public string Description { get; set; }

        public string UniversityName { get; set; }


        [Required(ErrorMessage = "Please select the country")]
        public int Country { get; set; }
        
        public string Course { get; set; }
        
        public string CourseCode { get; set; }
        
        public string Professor { get; set; }
        
        [Required(ErrorMessage = "please select the field")]
        public int IsPaid { get; set; }
        
        
        [Required(ErrorMessage = "please enter selling price")]
        public Nullable<decimal> SellingPrice { get; set; }



        public HttpPostedFileBase DisplayPictureFile { get; set; }



        [Required(ErrorMessage = "Please upload the document")]
        public HttpPostedFileBase FileName { get; set; }




        public HttpPostedFileBase NotesPreviewFile { get; set; }


    }
}