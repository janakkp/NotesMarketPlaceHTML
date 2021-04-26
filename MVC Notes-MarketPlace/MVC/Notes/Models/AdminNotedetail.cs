using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Notes.Models
{
    public class AdminNotedetail
    {
        public int noteid { set; get; }
        public string notephoto { set; get; }
        public string title { set; get; }
        public string category { set; get; }
        public string discription { set; get; }
        public string institution { set; get; }
        public string country { set; get; }
        public string coursename { set; get; }
        public string coursecode { set; get; }
        public string professor { set; get; }
        public int noofpages { set; get; }
        public System.DateTime Approveddate { set; get; }
        public int inappropriate { set; get; }
        public int countrating { set; get; }
        public int averagerating { set; get; }
        public string notepreview { set; get; }


        //For reviewPart
        public int reviewid { set; get; }
        public string reviewername { set; get; }
        public string comment { set; get; }
        public int ratingstar { set; get; }
        public string reviewerphoto { set; get; }








    }
}