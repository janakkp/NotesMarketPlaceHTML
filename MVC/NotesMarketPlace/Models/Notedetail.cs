using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NotesMarketPlace.Models
{
    public class Notedetail
    {
        public SellerNote sellernotelist { get; set; }

        public User userlist { get; set; }

        public UserProfile userprofilelist { get; set; }

        public NoteCategory categorylist { get; set; }

        public NoteType typelist { get; set; }

        public Country countrylist { get; set; }

        public SellerNotesReview reviewlist { get; set; }

    }
}