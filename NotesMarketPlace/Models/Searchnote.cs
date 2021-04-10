using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NotesMarketPlace.Models
{
    public class Searchnote
    {
        //Book
        public int noteid { set; get; }
        public string title { set; get; }
        public string university { set; get; }
        public Nullable<int> noofpage { set; get; }
        public Nullable<int> spamreport { set; get; }
        public Nullable<int> bookrating { set; get; }
        public Nullable<int> totalrating { set; get; }
        public string country { set; get; }
        public string type { set; get; }
        public string category { set; get; }
        public Nullable<System.DateTime> publishdate{set;get;}
        public Nullable<int> countryid { set; get; }
        public Nullable<int> typeid { set; get; }
        public int categoryid { set; get; }
        public string noteimg { set; get; }
        public string Course { get; set; }
    }
}