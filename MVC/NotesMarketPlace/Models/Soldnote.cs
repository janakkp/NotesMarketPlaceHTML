﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NotesMarketPlace.Models
{
    public class Soldnote
    {
        public Download downloadnotelist { get; set; }

        public User userlist { get; set; }

        public Paid paidlist { get; set; }

        public SellerNotesAttachement attachmentlist { get; set; }

    }
}