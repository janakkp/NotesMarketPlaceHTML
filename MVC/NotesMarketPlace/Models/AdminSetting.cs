using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NotesMarketPlace.Models
{
    public class AdminSetting
    {
        //Type, Category
        public int id { set; get; }
        public string name { set; get; }
        public string description { set; get; }
        public System.DateTime addeddate { set; get; }
        public string addedby { set; get; }
        public string active { set; get; }

        //Country
        public string countrycode { set; get; }


    }
}