using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NotesMarketPlace.Models
{
    public class Dashboard
    {
        public SellerNote sellernotelist { get; set; }

        public ReferenceData referencelist { get; set; }

        public NoteCategory notecategory { get; set; }

        public Paid paidlist { get; set;}

  
    }
}