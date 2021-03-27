using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NotesMarketPlace.Models
{
    public class Searchnote
    {
        public SellerNote sellernotelist { get; set; }
        public SellerNotesReview reviewlist { get; set; }
        public SellerNotesReportedIssue reportlist { get; set; }

        public int Category { get; set; }

        public int Type { get; set; }

        public string UniversityName { get; set; }
        public string Course { get; set; }
        public int Country { get; set; }
        public int Rating { get; set; }

        public string Searching { get; set; }
    }
}