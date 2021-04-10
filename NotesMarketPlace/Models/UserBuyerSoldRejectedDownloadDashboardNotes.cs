using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NotesMarketPlace.Models
{
    public class UserBuyerSoldRejectedDownloadDashboardNotes
    {
        //Dashboard
        public int noteid { set; get; }
        public string title { set; get; }
        public string category { set; get; }
        public double price { set; get; }
        public string selltype { set; get; }
        public int statusid { set; get; }
        public string status { set; get; }
        public System.DateTime addeddate { set; get; }

        //SoldNotes
        public System.DateTime date { set; get; }

        //Rejected Notes
        public string remark { set; get; }

        //Buyerreuest
        public string email { set; get; }

        //Mydownload
        public string attachpath { get; set; }
    }
}