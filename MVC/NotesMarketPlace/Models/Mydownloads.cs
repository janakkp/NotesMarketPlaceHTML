using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NotesMarketPlace.Models
{
    public class Mydownloads
    {
        public Download downloadnotelist { get; set; }

        public User userlist { get; set; }

        public Paid paidlist { get; set; }

    }
}