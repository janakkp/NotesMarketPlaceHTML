using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NotesMarketPlace.Models
{
    public class Rejectednote
    {
        public SellerNote sellernotelist { get; set; }

        public NoteCategory categorylist { get; set; }

        public SellerNotesAttachement attachmentlist { get; set; }

    }
}