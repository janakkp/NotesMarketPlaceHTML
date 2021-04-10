using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NotesMarketPlace.Models
{
    public class AdminNotes
    {
        // DASHBOARD  
        public int noteid { get; set; }
        public string title { get; set; }
        public string category { get; set; }
        public string selltype { get; set; }
        public double price { get; set; }
        public string publisher { get; set; }
        public System.DateTime publisheddate { get; set; }
        public int noofdownload { get; set; }
        public double attachmentsize { get; set; }
        public int SelectedMonth { get; set; }

        // Notes Under Review
        public string seller { get; set; }

        public int sellerid { get; set; }

        public System.DateTime addeddate { get; set; }

        public string status { get; set; }

        //Published Notes
        public string approvedby { get; set; }

        //Downloaded Notes
        public string buyer { get; set; }

        public int buyerid { get; set; }
        public System.DateTime downloaddate { get; set; }


        //Rejected Notes
        public System.DateTime dateedited { get; set; }
        public string rejectedby { get; set; }
        public string remark { get; set; }

        //Members
        public int memberid { set; get; }
        public string firstname { set; get; }
        public string lastname { set; get; }
        public string email { set; get; }
        public System.DateTime joiningdate { get; set; }
        public int underreviewnote { set; get; }
        public int publishednote { set; get; }
        public int downloadednote { set; get; }
        public double totalexpense { set; get; }
        public double totalearning { set; get; }

        //SPAM REPORTS
        public int spamid { set; get; }
        public string reportedby { set; get; }
        public string notetitle { set; get; }

        //MEMBER DETAIL
        public System.DateTime publishdate { set; get; }

    }
}