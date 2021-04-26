using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Notes.Models;
using System.Net.Mail;
using System.IO;
using System.Data;
using PagedList;
using System.Globalization;

namespace Notes.Controllers
{
    public class AdminController : Controller
    {
        static int usrid = 0;
        static int usrrole = 0;
        NotesEntities context = new NotesEntities();
        public ActionResult NoteSystem()
        {
            Session["email"] = context.SystemConfigurations.Where(x => x.Key == "email").Select(x => x.Value).FirstOrDefault();
            Session["facebook_url"] = context.SystemConfigurations.Where(x => x.Key == "facebook").Select(x => x.Value).FirstOrDefault();
            Session["Linkedin_url"] = context.SystemConfigurations.Where(x => x.Key == "linkedin").Select(x => x.Value).FirstOrDefault();
            Session["twitter_url"] = context.SystemConfigurations.Where(x => x.Key == "twitter").Select(x => x.Value).FirstOrDefault();
            Session["defaultnotepic"] = context.SystemConfigurations.Where(x => x.Key == "defaultnoteimage").Select(x => x.Value).FirstOrDefault();
            Session["defaultprofilepic"] = context.SystemConfigurations.Where(x => x.Key == "defaultprofileimage").Select(x => x.Value).FirstOrDefault();
            return View();
        }

        public ActionResult admin()
        {
            NoteSystem();
            usrid = Convert.ToInt32(Session["usrid"]);
            usrrole = Convert.ToInt32(Session["usrrole"]);
            return RedirectToAction("Dashboard");
        }
        // GET: Admin
        private void SendEmail(string receiver, string subject, string body)
        {
            using (MailMessage mailMessage = new MailMessage())
            {
                var sender = Session["email"].ToString();
                mailMessage.From = new MailAddress(sender, "janakpatel patel");
                mailMessage.Subject = subject;
                mailMessage.Body = body;
                mailMessage.IsBodyHtml = true;
                mailMessage.To.Add(new MailAddress(receiver));
                SmtpClient smtp = new SmtpClient();
                smtp.Host = "smtp.gmail.com";
                smtp.EnableSsl = true;
                System.Net.NetworkCredential NetworkCred = new System.Net.NetworkCredential();
                NetworkCred.UserName = sender;
                NetworkCred.Password = "Nmplace1";
                smtp.UseDefaultCredentials = true;
                smtp.Credentials = NetworkCred;
                smtp.Port = 587;
                smtp.Send(mailMessage);
            }
        }

        //Dashboard
        double sizeoffile(int? noteid)
        {
            string path = context.SellerNotesAttachements.Where(x => x.NoteID == noteid).Select(x => x.FileName).FirstOrDefault();
            string fullName = "C:\\Users\\Administrator\\source\\repos\\Notes\\UserFile\\FileName\\" + path;
            double size = fullName.Length;
            return size;
        }
        public ActionResult Dashboard(int? SelectedMonth, string sortOrder, string currentFilter, string searchString, int? page)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {

                    //For the Dashboard Header 
                    var dateCriteria = DateTime.Now.Date.AddDays(-7);
                    ViewBag.InReviewNotes = context.SellerNotes.Where(x => x.Status == 7 || x.Status == 8).Count();
                    ViewBag.DownloadedNotes = context.Downloads.Where(x => x.IsAttachmentDownloaded == true && x.AttachmentDownloadedDate >= dateCriteria).Count();
                    ViewBag.User = context.Users.Where(x => x.CreatedDate >= dateCriteria && x.RoleID.Equals(2)).Count();

                    //For the Table
                    List<SellerNote> sellernotelist = context.SellerNotes.Where(x => x.Status == 9).ToList();
                    List<User> userlist = context.Users.ToList();
                    var process = from s in sellernotelist
                                  select new AdminNotes
                                  {
                                      noteid = s.ID,
                                      title = s.Title,
                                      category = context.NoteCategories.Where(x => x.ID == s.Category).Select(x => x.Name).FirstOrDefault(),
                                      selltype = s.IsPaid == 1 ? "Paid" : "Free",
                                      price = Convert.ToDouble(s.SellingPrice),
                                      publisher = context.Users.Where(x => x.ID == s.ActionedBy).Select(x => x.FirstName).FirstOrDefault()
                                                + " " + context.Users.Where(x => x.ID == s.ActionedBy).Select(x => x.LastName).FirstOrDefault(),
                                      publisheddate = Convert.ToDateTime(s.PublishedDate),
                                      noofdownload = context.Downloads.Where(a => a.NoteID == s.ID && a.IsSellerHasAllowedDownload == true).Count(),
                                      attachmentsize = sizeoffile(s.ID)
                                  };

                    //For Month Dropdown
                    var CurrentMonth = DateTime.Now.Month;
                    var startmonth = CurrentMonth - 3;
                    ViewBag.Months = new SelectList(Enumerable.Range(startmonth, CurrentMonth).Select(x =>
                          new SelectListItem()
                          {
                              Text = CultureInfo.CurrentCulture.DateTimeFormat.AbbreviatedMonthNames[x - 1] + " (" + x + ")",
                              Value = x.ToString()
                          }), "Value", "Text");
                    ViewBag.SelectedMonth = SelectedMonth;
                    if (SelectedMonth == null)
                    {
                        process = process;
                    }
                    else
                    {
                        process = process.Where(s => s.publisheddate.Month == SelectedMonth);
                    }

                    //For Searching
                    if (searchString != null)
                    {
                        page = 1;
                    }
                    else
                    {
                        searchString = currentFilter;
                    }
                    ViewBag.CurrentFilter = searchString;
                    if (!String.IsNullOrEmpty(searchString))
                    {
                        process = process.Where(s => s.title.ToLower().Contains(searchString.ToLower())
                                                || s.category.ToLower().Contains(searchString.ToLower())
                                                || s.selltype.ToLower().Contains(searchString.ToLower())
                                                || s.price.ToString().ToLower().Contains(searchString.ToLower())
                                                || s.publisher.ToLower().Contains(searchString.ToLower())
                                                || s.publisheddate.ToString().ToLower().Contains(searchString.ToLower())
                                                || s.noofdownload.ToString().ToLower().Contains(searchString.ToLower())
                                                );
                    }

                    //For Sorting
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.title = sortOrder == "title" ? "title_desc" : "title";
                    ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
                    ViewBag.attachmentsize = sortOrder == "attachmentsize" ? "attachmentsize_desc" : "attachmentsize";
                    ViewBag.selltype = sortOrder == "selltype" ? "selltype_desc" : "selltype";
                    ViewBag.price = sortOrder == "price" ? "price_desc" : "price";
                    ViewBag.publisher = sortOrder == "publisher" ? "publisher_desc" : "publisher";
                    ViewBag.publisheddate = sortOrder == "publisheddate" ? "publisheddate_desc" : "publisheddate";
                    ViewBag.noofdown = sortOrder == "noofdown" ? "noofdown_desc" : "noofdown";
                    switch (sortOrder)
                    {

                        case "title":
                            process = process.OrderBy(s => s.title);
                            break;
                        case "title_desc":
                            process = process.OrderByDescending(s => s.title);
                            break;
                        case "category":
                            process = process.OrderBy(s => s.category);
                            break;
                        case "category_desc":
                            process = process.OrderByDescending(s => s.category);
                            break;
                        case "attachmentsize":
                            process = process.OrderBy(s => s.attachmentsize);
                            break;
                        case "attachmentsize_desc":
                            process = process.OrderByDescending(s => s.attachmentsize);
                            break;
                        case "selltype":
                            process = process.OrderBy(s => s.selltype);
                            break;
                        case "selltype_desc":
                            process = process.OrderByDescending(s => s.selltype);
                            break;
                        case "price":
                            process = process.OrderBy(s => s.price);
                            break;
                        case "price_desc":
                            process = process.OrderByDescending(s => s.price);
                            break;
                        case "publisher":
                            process = process.OrderBy(s => s.publisher);
                            break;
                        case "publisher_desc":
                            process = process.OrderByDescending(s => s.publisher);
                            break;
                        case "publisheddate":
                            process = process.OrderBy(s => s.publisheddate);
                            break;
                        case "publisheddate_desc":
                            process = process.OrderByDescending(s => s.publisheddate);
                            break;
                        case "noofdown":
                            process = process.OrderBy(s => s.noofdownload);
                            break;
                        case "noofdown_desc":
                            process = process.OrderByDescending(s => s.noofdownload);
                            break;
                        default:  // Name ascending 
                            process = process.OrderByDescending(s => s.noofdownload);
                            break;
                    }

                    //For Pagination
                    int pageSize = 10;
                    int pageNumber = (page ?? 1);
                    return View(process.ToPagedList(pageNumber, pageSize));
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult Unpublish(int? id, string remark)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    var data = context.SellerNotes.Where(x => x.ID == id).FirstOrDefault();
                    data.Status = 11;
                    data.AdminRemark = remark;
                    data.ActionedBy = usrid;
                    data.ModifiedDate = DateTime.Now;
                    data.ModifiedBy = usrid;
                    context.SaveChanges();
                    string body = string.Empty;
                    string subject = "Sorry! We need to remove your notes from our portal";
                    string seller = context.Users.Where(x => x.ID == data.SellerID).Select(x => x.EmailID).FirstOrDefault();
                    string sellername = context.Users.Where(x => x.ID == data.SellerID).Select(x => x.FirstName).FirstOrDefault() + " " +
                        context.Users.Where(x => x.ID == data.SellerID).Select(x => x.LastName).FirstOrDefault();

                    using (StreamReader reader = new StreamReader(Server.MapPath("~/email/rejectnote.html")))
                    {
                        body = reader.ReadToEnd();
                    }
                    body = body.Replace("[Seller]", sellername);
                    body = body.Replace("[NoteTitle]", data.Title);
                    body = body.Replace("[Remarks]", remark);
                    SendEmail(seller, subject, body);
                    return RedirectToAction("Dashboard");
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
                {
                    return RedirectToAction("Login", "User");
                }
        }


        //For Download the Note
        public ActionResult Download(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    string path = context.SellerNotesAttachements.Where(x => x.NoteID == id).Select(x => x.FileName).FirstOrDefault();
                    string fullName = "C:\\Users\\Admin\\source\\repos\\Notes\\UserFile\\FileName\\" + path;
                    byte[] fileBytes = GetFile(fullName);
                    return File(
                      fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, path);
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        byte[] GetFile(string s)
        {
            System.IO.FileStream fs = System.IO.File.OpenRead(s);
            byte[] data = new byte[fs.Length];
            int br = fs.Read(data, 0, data.Length);
            if (br != fs.Length)
                throw new System.IO.IOException(s);
            return data;
        }


        // Notes Under Review
        public ActionResult NotesUnderReview(int? selectedseller, string sortOrder, string currentFilter, string searchString, int? page)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    // For the table
                    List<SellerNote> sellernotelist = context.SellerNotes.Where(x => x.Status == 7 || x.Status == 8).ToList();
                    List<User> userlist = context.Users.ToList();
                    var process = from s in sellernotelist
                                  join u in userlist on s.SellerID equals u.ID into table1
                                  from u in table1.DefaultIfEmpty()
                                  select new AdminNotes
                                  {
                                      sellerid = u.ID,
                                      noteid = s.ID,
                                      title = s.Title,
                                      category = context.NoteCategories.Where(x => x.ID == s.Category).Select(x => x.Name).FirstOrDefault(),
                                      seller = u.FirstName + " " + u.LastName,
                                      addeddate = Convert.ToDateTime(s.PublishedDate),
                                      status = context.ReferenceDatas.Where(x => x.ID == s.Status).Select(x => x.DataValue).FirstOrDefault()
                                  };

                    //For Seller Dropdown
                    var userdropdown = process.ToList().GroupBy(x => x.sellerid).Select(group => group.First());
                    SelectList list = new SelectList(userdropdown, "sellerid", "seller");
                    ViewBag.userdropdown = list;
                    ViewBag.selectedseller = selectedseller;
                    if (selectedseller == null)
                    {
                        process = process;
                    }
                    else
                    {
                        process = process.Where(c => c.sellerid == selectedseller);
                    }

                    //For Searching
                    if (searchString != null)
                    {
                        page = 1;
                    }
                    else
                    {
                        searchString = currentFilter;
                    }
                    ViewBag.CurrentFilter = searchString;
                    if (!String.IsNullOrEmpty(searchString))
                    {
                        process = process.Where(s => s.title.ToLower().Contains(searchString.ToLower())
                                                || s.category.ToLower().Contains(searchString.ToLower())
                                                || s.title.ToLower().Contains(searchString.ToLower())
                                                || s.seller.ToLower().Contains(searchString.ToLower())
                                                || s.addeddate.ToString().ToLower().Contains(searchString.ToLower())
                                                || s.status.ToLower().Contains(searchString.ToLower())
                                                );
                    }

                    //For Sorting
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.title = sortOrder == "title" ? "title_desc" : "title";
                    ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
                    ViewBag.seller = sortOrder == "seller" ? "seller_desc" : "seller";
                    ViewBag.addeddate = sortOrder == "addeddate" ? "addeddate_desc" : "addeddate";
                    ViewBag.status = sortOrder == "status" ? "status_desc" : "status";
                    switch (sortOrder)
                    {
                        case "title":
                            process = process.OrderBy(s => s.title);
                            break;
                        case "title_desc":
                            process = process.OrderByDescending(s => s.title);
                            break;
                        case "category":
                            process = process.OrderBy(s => s.category);
                            break;
                        case "category_desc":
                            process = process.OrderByDescending(s => s.category);
                            break;
                        case "status":
                            process = process.OrderBy(s => s.status);
                            break;
                        case "status_desc":
                            process = process.OrderByDescending(s => s.status);
                            break;
                        case "seller":
                            process = process.OrderBy(s => s.seller);
                            break;
                        case "seller_desc":
                            process = process.OrderByDescending(s => s.seller);
                            break;
                        case "addeddate":
                            process = process.OrderBy(s => s.addeddate);
                            break;
                        case "addeddate_desc":
                            process = process.OrderByDescending(s => s.addeddate);
                            break;
                        default:  // Name ascending 
                            process = process.OrderBy(s => s.addeddate);
                            break;
                    }

                    //For Paging
                    int pageSize = 10;
                    int pageNumber = (page ?? 1);
                    return View(process.ToPagedList(pageNumber, pageSize));
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult approve(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    var data = context.SellerNotes.Where(x => x.ID == id).FirstOrDefault();
                    data.Status = 9;
                    data.ActionedBy = usrid;
                    data.PublishedDate = DateTime.Now;
                    context.SaveChanges();
                    return RedirectToAction("NotesUnderReview");

                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult inreview(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    var data = context.SellerNotes.Where(x => x.ID == id).FirstOrDefault();
                    data.Status = 8;
                    data.ActionedBy = usrid;
                    context.SaveChanges();
                    return RedirectToAction("NotesUnderReview");
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult reject(int? id, string remark)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    var data = context.SellerNotes.Where(x => x.ID == id).FirstOrDefault();
                    data.Status = 10;
                    data.AdminRemark = remark;
                    data.ActionedBy = usrid;
                    context.SaveChanges();
                    return RedirectToAction("NotesUnderReview");
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }


        // Published Notes
        public ActionResult Published_Unpublish(int? id, string remark)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    var data = context.SellerNotes.Where(x => x.ID == id).FirstOrDefault();
                    data.Status = 11;
                    data.AdminRemark = remark;
                    data.ActionedBy = usrid;
                    data.ModifiedDate = DateTime.Now;
                    context.SaveChanges();
                    string body = string.Empty;
                    string subject = "Sorry! We need to remove your notes from our portal";
                    string seller = context.Users.Where(x => x.ID == data.SellerID).Select(x => x.EmailID).FirstOrDefault();
                    string sellername = context.Users.Where(x => x.ID == data.SellerID).Select(x => x.FirstName).FirstOrDefault() + " " +
                        context.Users.Where(x => x.ID == data.SellerID).Select(x => x.LastName).FirstOrDefault();

                    using (StreamReader reader = new StreamReader(Server.MapPath("~/email/rejectnote.html")))
                    {
                        body = reader.ReadToEnd();
                    }
                    body = body.Replace("[Seller]", sellername);
                    body = body.Replace("[NoteTitle]", data.Title);
                    body = body.Replace("[Remarks]", remark);
                    SendEmail(seller, subject, body);
                    return RedirectToAction("PublishedNote");
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult PublishedNote(int? selectedseller, string sortOrder, string currentFilter, string searchString, int? page)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    //For the table
                    List<SellerNote> sellernotelist = context.SellerNotes.Where(x => x.Status == 9).ToList();
                    List<User> userlist = context.Users.ToList();
                    var process = from s in sellernotelist
                                  join u in userlist on s.SellerID equals u.ID into table3
                                  from u in table3.DefaultIfEmpty()
                                  select new AdminNotes
                                  {
                                      noteid = s.ID,
                                      title = s.Title,
                                      category = context.NoteCategories.Where(x => x.ID == s.Category).Select(x => x.Name).FirstOrDefault(),
                                      selltype = s.IsPaid == 1 ? "Paid" : "Free",
                                      price = Convert.ToDouble(s.SellingPrice),
                                      sellerid = s.SellerID,
                                      seller = u.FirstName + " " + u.LastName,
                                      publisheddate = Convert.ToDateTime(s.PublishedDate),
                                      noofdownload = context.Downloads.Where(a => a.NoteID == s.ID && a.IsSellerHasAllowedDownload == true).Count(),
                                      approvedby = context.Users.Where(x => x.ID == s.ActionedBy).Select(x => x.FirstName).FirstOrDefault()
                                                + " " + context.Users.Where(x => x.ID == s.ActionedBy).Select(x => x.LastName).FirstOrDefault()
                                  };

                    //For seller Dropdown
                    var userdropdown = process.ToList().GroupBy(x => x.sellerid).Select(group => group.First());
                    SelectList list = new SelectList(userdropdown, "sellerid", "seller");
                    ViewBag.userdropdown = list;
                    ViewBag.selectedseller = selectedseller;
                    if (selectedseller == null)
                    {
                        process = process;
                    }
                    else
                    {
                        process = process.Where(c => c.sellerid == selectedseller);
                    }

                    //For Searching
                    if (searchString != null)
                    {
                        page = 1;
                    }
                    else
                    {
                        searchString = currentFilter;
                    }
                    ViewBag.CurrentFilter = searchString;
                    if (!String.IsNullOrEmpty(searchString))
                    {
                        process = process.Where(s => s.title.ToLower().Contains(searchString.ToLower())
                                                || s.title.ToLower().Contains(searchString.ToLower())
                                                || s.category.ToLower().Contains(searchString.ToLower())
                                                || s.seller.ToLower().Contains(searchString.ToLower())
                                                || s.selltype.ToLower().Contains(searchString.ToLower())
                                                || s.price.ToString().ToLower().Contains(searchString.ToLower())
                                                || s.publisheddate.ToString().ToLower().Contains(searchString.ToLower())
                                                || s.noofdownload.ToString().ToLower().Contains(searchString.ToLower())
                                                || s.approvedby.ToLower().Contains(searchString.ToLower())
                                                );
                    }

                    //For Sorting
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.title = String.IsNullOrEmpty(sortOrder) ? "title_desc" : "";
                    ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
                    ViewBag.selltype = sortOrder == "selltype" ? "selltype_desc" : "selltype";
                    ViewBag.price = sortOrder == "price" ? "price_desc" : "price";
                    ViewBag.seller = sortOrder == "seller" ? "seller_desc" : "seller";
                    ViewBag.publisheddate = sortOrder == "publisheddate" ? "publisheddate_desc" : "publisheddate";
                    ViewBag.approveby = sortOrder == "approveby" ? "approveby_desc" : "approveby";
                    ViewBag.noofdown = sortOrder == "noofdown" ? "noofdown_desc" : "noofdown";
                    switch (sortOrder)
                    {
                        case "title":
                            process = process.OrderBy(s => s.title);
                            break;
                        case "title_desc":
                            process = process.OrderByDescending(s => s.title);
                            break;
                        case "category":
                            process = process.OrderBy(s => s.category);
                            break;
                        case "category_desc":
                            process = process.OrderByDescending(s => s.category);
                            break;
                        case "selltype":
                            process = process.OrderBy(s => s.selltype);
                            break;
                        case "selltype_desc":
                            process = process.OrderByDescending(s => s.selltype);
                            break;
                        case "price":
                            process = process.OrderBy(s => s.price);
                            break;
                        case "price_desc":
                            process = process.OrderByDescending(s => s.price);
                            break;
                        case "seller":
                            process = process.OrderBy(s => s.seller);
                            break;
                        case "seller_desc":
                            process = process.OrderByDescending(s => s.seller);
                            break;
                        case "publisheddate":
                            process = process.OrderBy(s => s.publisheddate);
                            break;
                        case "publisheddate_desc":
                            process = process.OrderByDescending(s => s.publisheddate);
                            break;
                        case "approveby":
                            process = process.OrderBy(s => s.approvedby);
                            break;
                        case "approveby_desc":
                            process = process.OrderByDescending(s => s.approvedby);
                            break;
                        case "noofdown":
                            process = process.OrderBy(s => s.noofdownload);
                            break;
                        case "noofdown_desc":
                            process = process.OrderByDescending(s => s.noofdownload);
                            break;
                        default:  // Name ascending 
                            process = process.OrderBy(s => s.publisheddate);
                            break;
                    }

                    //For Paging
                    int pageSize = 10;
                    int pageNumber = (page ?? 1);
                    return View(process.ToPagedList(pageNumber, pageSize));
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }


        //Downloaded Notes
        public ActionResult DownloadedNotes(int? selectedseller, int? selectedbuyer, int? selectednote, string sortOrder, string currentFilter, string searchString, int? page)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    //For Process
                    List<Download> downloadlist = context.Downloads.Where(x => x.IsSellerHasAllowedDownload == true).ToList();
                    var process = from d in downloadlist
                                  select new AdminNotes
                                  {
                                      noteid = d.NoteID,
                                      title = d.NoteTitle,
                                      category = d.NoteCategory,
                                      selltype = d.IsPaid == 1 ? "Paid" : "Free",
                                      price = Convert.ToDouble(d.PurchasedPrice),
                                      buyer = context.Users.Where(x => x.ID == d.Downloader).Select(x => x.FirstName).FirstOrDefault()
                                                + " " + context.Users.Where(x => x.ID == d.Downloader).Select(x => x.LastName).FirstOrDefault(),
                                      buyerid = d.Downloader,
                                      seller = context.Users.Where(x => x.ID == d.Seller).Select(x => x.FirstName).FirstOrDefault()
                                                + " " + context.Users.Where(x => x.ID == d.Seller).Select(x => x.LastName).FirstOrDefault(),
                                      sellerid = d.Seller,
                                      downloaddate = Convert.ToDateTime(d.AttachmentDownloadedDate)
                                  };

                    //For Buyer Dropdown
                    var buyerdropdown = process.ToList().GroupBy(x => x.buyer).Select(group => group.First());
                    SelectList list1 = new SelectList(buyerdropdown, "buyerid", "buyer");
                    ViewBag.buyerdropdown = list1;
                    ViewBag.selectedbuyer = selectedbuyer;
                    if (selectedbuyer == null)
                    {
                        process = process;
                    }
                    else
                    {
                        process = process.Where(c => c.buyerid == selectedbuyer);
                    }

                    //For Seller Dropdown
                    var sellerdropdown = process.ToList().GroupBy(x => x.seller).Select(group => group.First());
                    SelectList list = new SelectList(sellerdropdown, "sellerid", "seller");
                    ViewBag.sellerdropdown = list;
                    ViewBag.selectedseller = selectedseller;
                    if (selectedseller == null)
                    {
                        process = process;
                    }
                    else
                    {
                        process = process.Where(c => c.sellerid == selectedseller);
                    }

                    //For Note Dropdown
                    var notedropdown = process.ToList().GroupBy(x => x.title).Select(group => group.First());
                    SelectList list2 = new SelectList(notedropdown, "noteid", "title");
                    ViewBag.notedropdown = list2;
                    ViewBag.selectednote = selectednote;
                    if (selectednote == null)
                    {
                        process = process;
                    }
                    else
                    {
                        process = process.Where(c => c.noteid == selectednote);
                    }

                    //For Searching
                    if (searchString != null)
                    {
                        page = 1;
                    }
                    else
                    {
                        searchString = currentFilter;
                    }
                    ViewBag.CurrentFilter = searchString;
                    if (!String.IsNullOrEmpty(searchString))
                    {
                        process = process.Where(s => s.title.ToLower().Contains(searchString.ToLower())
                                                || s.category.ToLower().Contains(searchString.ToLower())
                                                || s.seller.ToLower().Contains(searchString.ToLower())
                                                || s.selltype.ToLower().Contains(searchString.ToLower())
                                                || s.price.ToString().ToLower().Contains(searchString.ToLower())
                                                || s.buyer.ToLower().Contains(searchString.ToLower())
                                                || s.downloaddate.ToString().ToLower().Contains(searchString.ToLower())
                                               );
                    }

                    //For Sorting
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.title = sortOrder == "title" ? "title_desc" : "title";
                    ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
                    ViewBag.seller = sortOrder == "seller" ? "seller_desc" : "seller";
                    ViewBag.buyer = sortOrder == "buyer" ? "buyer_desc" : "buyer";
                    ViewBag.downloaddate = sortOrder == "downloaddate" ? "downloaddate_desc" : "downloaddate";
                    ViewBag.selltype = sortOrder == "selltype" ? "selltype_desc" : "selltype";
                    ViewBag.price = sortOrder == "price" ? "price_desc" : "price";
                    switch (sortOrder)
                    {
                        case "title":
                            process = process.OrderBy(s => s.title);
                            break;
                        case "title_desc":
                            process = process.OrderByDescending(s => s.title);
                            break;
                        case "category":
                            process = process.OrderBy(s => s.category);
                            break;
                        case "category_desc":
                            process = process.OrderByDescending(s => s.category);
                            break;
                        case "selltype":
                            process = process.OrderBy(s => s.selltype);
                            break;
                        case "selltype_desc":
                            process = process.OrderByDescending(s => s.selltype);
                            break;
                        case "price":
                            process = process.OrderBy(s => s.price);
                            break;
                        case "price_desc":
                            process = process.OrderByDescending(s => s.price);
                            break;
                        case "seller":
                            process = process.OrderBy(s => s.seller);
                            break;
                        case "seller_desc":
                            process = process.OrderByDescending(s => s.seller);
                            break;
                        case "downloaddate":
                            process = process.OrderBy(s => s.downloaddate);
                            break;
                        case "downloaddate_desc":
                            process = process.OrderByDescending(s => s.downloaddate);
                            break;
                        case "buyer":
                            process = process.OrderBy(s => s.buyer);
                            break;
                        case "buyer_desc":
                            process = process.OrderByDescending(s => s.buyer);
                            break;
                        default:  // Name ascending 
                            process = process.OrderByDescending(s => s.downloaddate);
                            break;
                    }

                    // For Paging
                    int pageSize = 10;
                    int pageNumber = (page ?? 1);
                    return View(process.ToPagedList(pageNumber, pageSize));
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }


        //Rejected Notes
        public ActionResult RejectedNotes(int? selectedseller, string sortOrder, string currentFilter, string searchString, int? page)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    //For the table
                    List<SellerNote> sellernotelist = context.SellerNotes.Where(x => x.Status == 10).ToList();
                    var process = from s in sellernotelist
                                  select new AdminNotes
                                  {
                                      noteid = s.ID,
                                      title = s.Title,
                                      category = context.NoteCategories.Where(x => x.ID == s.Category).Select(x => x.Name).FirstOrDefault(),
                                      seller = context.Users.Where(x => x.ID == s.SellerID).Select(x => x.FirstName).FirstOrDefault()
                                                + " " + context.Users.Where(x => x.ID == s.SellerID).Select(x => x.LastName).FirstOrDefault(),
                                      sellerid = s.SellerID,
                                      rejectedby = context.Users.Where(x => x.ID == s.ActionedBy).Select(x => x.FirstName).FirstOrDefault()
                                                + " " + context.Users.Where(x => x.ID == s.ActionedBy).Select(x => x.LastName).FirstOrDefault(),
                                      dateedited = Convert.ToDateTime(s.ModifiedDate),
                                      remark = s.AdminRemark

                                  };

                    // For Seller Dropdown
                    var sellerdropdown = process.ToList().GroupBy(x => x.sellerid).Select(group => group.First());
                    SelectList list = new SelectList(sellerdropdown, "sellerid", "seller");
                    ViewBag.sellerdropdown = list;
                    ViewBag.selectedseller = selectedseller;
                    if (selectedseller == null)
                    {
                        process = process;
                    }
                    else
                    {
                        process = process.Where(c => c.sellerid == selectedseller);
                    }

                    // For Searching
                    if (searchString != null)
                    {
                        page = 1;
                    }
                    else
                    {
                        searchString = currentFilter;
                    }
                    ViewBag.CurrentFilter = searchString;
                    if (!String.IsNullOrEmpty(searchString))
                    {
                        process = process.Where(s => s.title.ToLower().Contains(searchString.ToLower())
                                                || s.category.ToLower().Contains(searchString.ToLower())
                                                || s.seller.ToLower().Contains(searchString.ToLower())
                                                || s.rejectedby.ToLower().Contains(searchString.ToLower())
                                                || s.dateedited.ToString().ToLower().Contains(searchString.ToLower())
                                                || s.remark.ToString().ToLower().Contains(searchString.ToLower())
                                                );
                    }

                    // For Sortor
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.title = String.IsNullOrEmpty(sortOrder) ? "title_desc" : "title";
                    ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
                    ViewBag.seller = sortOrder == "seller" ? "seller_desc" : "seller";
                    ViewBag.dateedited = sortOrder == "dateedited" ? "dateedited_desc" : "dateedited";
                    ViewBag.rejectedby = sortOrder == "rejectedby" ? "rejectedby_desc" : "rejectedby";
                    ViewBag.remark = sortOrder == "remark" ? "remark_desc" : "remark";
                    switch (sortOrder)
                    {
                        case "title":
                            process = process.OrderBy(s => s.title);
                            break;
                        case "title_desc":
                            process = process.OrderByDescending(s => s.title);
                            break;
                        case "category":
                            process = process.OrderBy(s => s.category);
                            break;
                        case "category_desc":
                            process = process.OrderByDescending(s => s.category);
                            break;
                        case "dateedited":
                            process = process.OrderBy(s => s.dateedited);
                            break;
                        case "dateedited_desc":
                            process = process.OrderByDescending(s => s.dateedited);
                            break;
                        case "seller":
                            process = process.OrderBy(s => s.seller);
                            break;
                        case "seller_desc":
                            process = process.OrderByDescending(s => s.seller);
                            break;
                        case "rejectedby":
                            process = process.OrderBy(s => s.rejectedby);
                            break;
                        case "rejectedby_desc":
                            process = process.OrderByDescending(s => s.rejectedby);
                            break;
                        case "remark":
                            process = process.OrderBy(s => s.remark);
                            break;
                        case "remark_desc":
                            process = process.OrderByDescending(s => s.remark);
                            break;
                        default:  // Name ascending 
                            process = process.OrderByDescending(s => s.dateedited);
                            break;
                    }

                    //For Paging
                    int pageSize = 10;
                    int pageNumber = (page ?? 1);
                    return View(process.ToPagedList(pageNumber, pageSize));
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult reject_approve(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {

                    var data = context.SellerNotes.Where(x => x.ID == id).FirstOrDefault();
                    data.Status = 9;
                    data.ActionedBy = usrid;
                    data.ModifiedDate = DateTime.Now;
                    context.SaveChanges();
                    return RedirectToAction("RejectedNotes");
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }


        // Members
        public ActionResult Members(string sortOrder, string currentFilter, string searchString, int? page)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {

                    //For Table
                    List<User> userlist = context.Users.Where(x => x.IsActive == true && x.RoleID.Equals(1) == true).ToList();
                    var process = from s in userlist
                                  select new AdminNotes
                                  {
                                      memberid = s.ID,
                                      firstname = s.FirstName,
                                      lastname = s.LastName,
                                      email = s.EmailID,
                                      joiningdate = Convert.ToDateTime(s.CreatedDate),
                                      underreviewnote = context.SellerNotes.Where(x => x.SellerID == s.ID).Where(x => x.Status == 7 || x.Status == 8).Count(),
                                      publishednote = context.SellerNotes.Where(x => x.SellerID == s.ID && x.Status == 9).Count(),
                                      downloadednote = context.Downloads.Where(x => x.Downloader == s.ID && x.IsSellerHasAllowedDownload == true).Count(),
                                      totalearning = Convert.ToDouble(context.Downloads.Where(x => x.Seller == s.ID && x.IsSellerHasAllowedDownload == true).Sum(x => x.PurchasedPrice)),
                                      totalexpense = Convert.ToDouble(context.Downloads.Where(x => x.Downloader == s.ID && x.IsSellerHasAllowedDownload == true).Sum(x => x.PurchasedPrice))
                                  };
                    //For Searching
                    if (searchString != null)
                    {
                        page = 1;
                    }
                    else
                    {
                        searchString = currentFilter;
                    }
                    ViewBag.CurrentFilter = searchString;
                    if (!String.IsNullOrEmpty(searchString))
                    {
                        process = process.Where(s => s.firstname.ToLower().Contains(searchString.ToLower()) ||
                                                     s.lastname.ToLower().Contains(searchString.ToLower()) ||
                                                     s.email.ToLower().Contains(searchString.ToLower()) ||
                                                     s.joiningdate.ToString().ToLower().Contains(searchString.ToLower()) ||
                                                     s.totalearning.ToString().ToLower().Contains(searchString.ToLower()) ||
                                                     s.totalexpense.ToString().ToLower().Contains(searchString.ToLower())
                                                     );
                    }
                    //For Sorting
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.fname = String.IsNullOrEmpty(sortOrder) ? "fname_desc" : "";
                    ViewBag.lname = sortOrder == "lname" ? "lname_desc" : "lname";
                    ViewBag.email = sortOrder == "email" ? "email_desc" : "email";
                    ViewBag.joiningdate = sortOrder == "joiningdate" ? "joiningdate_desc" : "joiningdate";
                    ViewBag.underreviewnote = sortOrder == "underreviewnote" ? "underreviewnote_desc" : "underreviewnote";
                    ViewBag.publishednote = sortOrder == "publishednote" ? "publishednote_desc" : "publishednote";
                    ViewBag.downloadednote = sortOrder == "downloadednote" ? "downloadednote_desc" : "downloadednote";
                    ViewBag.totalearning = sortOrder == "totalearning" ? "totalearning_desc" : "totalearning";
                    ViewBag.totalexpence = sortOrder == "totalexpence" ? "totalexpence_desc" : "totalexpence";
                    switch (sortOrder)
                    {
                        case "fname_desc":
                            process = process.OrderByDescending(s => s.firstname);
                            break;
                        case "lname":
                            process = process.OrderBy(s => s.lastname);
                            break;
                        case "lname_desc":
                            process = process.OrderByDescending(s => s.lastname);
                            break;
                        case "email":
                            process = process.OrderBy(s => s.email);
                            break;
                        case "email_desc":
                            process = process.OrderByDescending(s => s.email);
                            break;
                        case "joiningdate":
                            process = process.OrderBy(s => s.joiningdate);
                            break;
                        case "joiningdate_desc":
                            process = process.OrderByDescending(s => s.joiningdate);
                            break;
                        case "underreviewnote":
                            process = process.OrderBy(s => s.underreviewnote);
                            break;
                        case "underreviewnote_desc":
                            process = process.OrderByDescending(s => s.underreviewnote);
                            break;
                        case "publishednote":
                            process = process.OrderBy(s => s.publishednote);
                            break;
                        case "publishednote_desc":
                            process = process.OrderByDescending(s => s.publishednote);
                            break;
                        case "totalearning":
                            process = process.OrderBy(s => s.totalearning);
                            break;
                        case "totalearning_desc":
                            process = process.OrderByDescending(s => s.totalearning);
                            break;
                        case "totalexpence":
                            process = process.OrderBy(s => s.totalexpense);
                            break;
                        case "totalexpence_desc":
                            process = process.OrderByDescending(s => s.totalexpense);
                            break;
                        case "downloadednote":
                            process = process.OrderBy(s => s.downloadednote);
                            break;
                        case "downloadednote_desc":
                            process = process.OrderByDescending(s => s.downloadednote);
                            break;
                        default:  // Name ascending 
                            process = process.OrderByDescending(s => s.joiningdate);
                            break;
                    }
                    // For Paging
                    int pageSize = 10;
                    int pageNumber = (page ?? 1);
                    return View(process.ToPagedList(pageNumber, pageSize));
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult deactivate(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    var user = context.Users.Where(x => x.ID == id).FirstOrDefault();
                    user.IsActive = false;
                    context.SaveChanges();

                    var notes = context.SellerNotes.Where(x => x.SellerID == id).ToList();
                    foreach (var item in notes)
                    {
                        item.Status = 11;
                        context.SaveChanges();
                    }
                    return RedirectToAction("Members");
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }


        // MemberDetail
        public ActionResult memberdetail(string sortOrder, int? page, int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    ViewBag.usrid = id;
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.title = String.IsNullOrEmpty(sortOrder) ? "title_desc" : "";
                    ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
                    ViewBag.status = sortOrder == "status" ? "status_desc" : "status";
                    ViewBag.totalearning = sortOrder == "totalearning" ? "totalearning_desc" : "totalearning";
                    ViewBag.dateadded = sortOrder == "dateadded" ? "dateadded_desc" : "dateadded";
                    ViewBag.publisheddate = sortOrder == "publisheddate" ? "publisheddate_desc" : "publisheddate";


                    ViewBag.memberdetail1 = context.Users.Where(x => x.ID == id).FirstOrDefault();
                    ViewBag.memberdetail2 = context.UserProfiles.Where(x => x.UserID == id).FirstOrDefault();
                    List<SellerNote> sellernotelist = context.SellerNotes.Where(x => x.SellerID == id).ToList();
                    List<Download> downloadlist = context.Downloads.ToList();
                    var process = from s in sellernotelist
                                  select new AdminNotes
                                  {
                                      noteid = s.ID,
                                      title = s.Title,
                                      category = context.NoteCategories.Where(x => x.ID == s.Category).Select(x => x.Name).FirstOrDefault(),
                                      status = context.ReferenceDatas.Where(x => x.ID == s.Status).Select(x => x.DataValue).FirstOrDefault(),
                                      downloadednote = context.Downloads.Where(x => x.NoteID == s.ID && x.IsSellerHasAllowedDownload == true).Count(),
                                      totalearning = Convert.ToDouble(context.Downloads.Where(x => x.NoteID == s.ID).Sum(x => x.PurchasedPrice)),
                                      addeddate = Convert.ToDateTime(s.CreatedDate),
                                      publishdate = Convert.ToDateTime(s.PublishedDate)
                                  };

                    switch (sortOrder)
                    {
                        case "title_desc":
                            process = process.OrderByDescending(s => s.title);
                            break;
                        case "category":
                            process = process.OrderBy(s => s.category);
                            break;
                        case "category_desc":
                            process = process.OrderByDescending(s => s.category);
                            break;
                        case "status":
                            process = process.OrderBy(s => s.status);
                            break;
                        case "status_desc":
                            process = process.OrderByDescending(s => s.status);
                            break;
                        case "totalearning":
                            process = process.OrderBy(s => s.totalearning);
                            break;
                        case "totalearning_desc":
                            process = process.OrderByDescending(s => s.totalearning);
                            break;
                        case "dateadded":
                            process = process.OrderBy(s => s.addeddate);
                            break;
                        case "dateadded_desc":
                            process = process.OrderByDescending(s => s.addeddate);
                            break;
                        case "publisheddate":
                            process = process.OrderBy(s => s.publishdate);
                            break;
                        case "publisheddate_desc":
                            process = process.OrderByDescending(s => s.publishdate);
                            break;
                        default:  // Name ascending 
                            process = process.OrderBy(s => s.addeddate);
                            break;
                    }
                    int pageSize = 5;
                    int pageNumber = (page ?? 1);
                    return View(process.ToPagedList(pageNumber, pageSize));
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }


        //Spam report
        public ActionResult spamreport(string sortOrder, string currentFilter, string searchString, int? page)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    //FOR PROCESS
                    List<SellerNotesReportedIssue> reportedlist = context.SellerNotesReportedIssues.ToList();
                    var process = from r in reportedlist
                                  select new AdminNotes
                                  {
                                      spamid = r.ID,
                                      noteid = r.NoteID,
                                      reportedby = context.Users.Where(x => x.ID == r.ReportedByID).Select(x => x.FirstName).FirstOrDefault() + " " + context.Users.Where(x => x.ID == r.ReportedByID).Select(x => x.LastName).FirstOrDefault(),
                                      notetitle = context.Downloads.Where(x => x.NoteID == r.NoteID).Select(x => x.NoteTitle).FirstOrDefault(),
                                      category = context.Downloads.Where(x => x.NoteID == r.NoteID).Select(x => x.NoteCategory).FirstOrDefault(),
                                      dateedited = Convert.ToDateTime(r.ModifiedDate),
                                      remark = r.Remarks
                                  };

                    //FOR SEARCHING
                    if (searchString != null)
                    {
                        page = 1;
                    }
                    else
                    {
                        searchString = currentFilter;
                    }
                    ViewBag.CurrentFilter = searchString;

                    if (!String.IsNullOrEmpty(searchString))
                    {
                        process = process.Where(s => s.reportedby.ToLower().Contains(searchString.ToLower()) ||
                                                     s.notetitle.ToLower().Contains(searchString.ToLower()) ||
                                                     s.reportedby.ToLower().Contains(searchString.ToLower()) ||
                                                     s.category.ToLower().Contains(searchString.ToLower()) ||
                                                     s.dateedited.ToString().ToLower().Contains(searchString.ToLower()) ||
                                                     s.remark.ToLower().Contains(searchString.ToLower())
                                                     );
                    }

                    //FOR SORTING
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.reportedby = String.IsNullOrEmpty(sortOrder) ? "reportedby" : "";
                    ViewBag.notetitle = sortOrder == "notetitle" ? "notetitle_desc" : "notetitle";
                    ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
                    ViewBag.dateedited = sortOrder == "dateedited" ? "dateedited_desc" : "dateedited";
                    ViewBag.remark = sortOrder == "remark" ? "remark_desc" : "remark";
                    switch (sortOrder)
                    {
                        case "reportedby":
                            process = process.OrderByDescending(s => s.reportedby);
                            break;
                        case "notetitle":
                            process = process.OrderBy(s => s.notetitle);
                            break;
                        case "notetitle_desc":
                            process = process.OrderByDescending(s => s.notetitle);
                            break;
                        case "category":
                            process = process.OrderBy(s => s.category);
                            break;
                        case "category_desc":
                            process = process.OrderByDescending(s => s.category);
                            break;
                        case "dateedited":
                            process = process.OrderBy(s => s.dateedited);
                            break;
                        case "dateedited_desc":
                            process = process.OrderByDescending(s => s.dateedited);
                            break;
                        case "remark":
                            process = process.OrderBy(s => s.remark);
                            break;
                        case "remark_desc":
                            process = process.OrderByDescending(s => s.remark);
                            break;
                        default:
                            process = process.OrderByDescending(s => s.dateedited);
                            break;
                    }

                    //FOR PAGING
                    int pageSize = 10;
                    int pageNumber = (page ?? 1);
                    return View(process.ToPagedList(pageNumber, pageSize));
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult spam_delete(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    SellerNotesReportedIssue issue = context.SellerNotesReportedIssues.Where(x => x.ID == id).FirstOrDefault();
                    context.SellerNotesReportedIssues.Remove(issue);
                    context.SaveChanges();
                    return RedirectToAction("Spamreport");
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }


        //Manage Category, Add category, edit category
        public ActionResult ManageCategory(string sortOrder, string currentFilter, string searchString, int? page)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    //For Table
                    List<NoteCategory> categorylist = context.NoteCategories.ToList();
                    var process = from c in categorylist
                                  select new AdminSetting
                                  {
                                      id = c.ID,
                                      name = c.Name,
                                      description = c.Description,
                                      addedby = context.Users.Where(x => x.ID == c.CreatedBy).Select(x => x.FirstName).FirstOrDefault() + " " +
                                                    context.Users.Where(x => x.ID == c.CreatedBy).Select(x => x.LastName).FirstOrDefault(),
                                      addeddate = Convert.ToDateTime(c.CreatedDate),
                                      active = c.IsActive == true ? "YES" : "NO"
                                  };

                    //For Searching
                    if (searchString != null)
                    {
                        page = 1;
                    }
                    else
                    {
                        searchString = currentFilter;
                    }
                    ViewBag.CurrentFilter = searchString;
                    if (!String.IsNullOrEmpty(searchString))
                    {
                        process = process.Where(s => s.name.ToLower().Contains(searchString.ToLower()) ||
                                                     s.description.ToLower().Contains(searchString.ToLower()) ||
                                                     s.addedby.ToLower().Contains(searchString.ToLower()) ||
                                                     s.addeddate.ToString().ToLower().Contains(searchString.ToLower()) ||
                                                     s.active.ToLower().Contains(searchString.ToLower())
                                               );
                    }

                    //For Sorting
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.category = sortOrder == "category" ? "category" : "category";
                    ViewBag.description = sortOrder == "description" ? "description_desc" : "description";
                    ViewBag.addedby = sortOrder == "addedby" ? "addedby_desc" : "addedby";
                    ViewBag.addeddate = sortOrder == "addeddate" ? "addeddate_desc" : "addeddate";
                    ViewBag.active = sortOrder == "active" ? "active_desc" : "active";
                    switch (sortOrder)
                    {
                        case "category":
                            process = process.OrderByDescending(s => s.name);
                            break;
                        case "description":
                            process = process.OrderBy(s => s.description);
                            break;
                        case "description_desc":
                            process = process.OrderByDescending(s => s.description);
                            break;
                        case "addedby":
                            process = process.OrderBy(s => s.addedby);
                            break;
                        case "addedby_desc":
                            process = process.OrderByDescending(s => s.addedby);
                            break;
                        case "addeddate":
                            process = process.OrderBy(s => s.addeddate);
                            break;
                        case "addeddate_desc":
                            process = process.OrderByDescending(s => s.addeddate);
                            break;
                        case "active":
                            process = process.OrderBy(s => s.active);
                            break;
                        case "active_desc":
                            process = process.OrderByDescending(s => s.active);
                            break;
                        default:
                            process = process.OrderByDescending(s => s.addeddate);
                            break;
                    }
                    //For Paging
                    int pageSize = 10;
                    int pageNumber = (page ?? 1);
                    return View(process.ToPagedList(pageNumber, pageSize));
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult delete_category(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    var cat = context.NoteCategories.Where(x => x.ID == id).FirstOrDefault();
                    cat.IsActive = false;
                    context.SaveChanges();
                    return RedirectToAction("ManageCategory");
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult add_category()
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    return View("CreateEditcategory", new NoteCategory());
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult edit_category(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    return View("CreateEditcategory", context.NoteCategories.Find(id));
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        [HttpPost]
        public ActionResult CreateEditcategory(NoteCategory model)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    if (ModelState.IsValid)
                    {
                        if (model.ID == 0)
                        {
                            NoteCategory cate = new NoteCategory
                            {
                                Name = model.Name,
                                Description = model.Description,
                                CreatedBy = usrid,
                                ModifiedBy = usrid,
                                CreatedDate = DateTime.Now,
                                ModifiedDate = DateTime.Now,
                                IsActive = true
                            };
                            context.NoteCategories.Add(cate);
                            context.SaveChanges();
                        }
                        else
                        {
                            var id = model.ID;
                            var category = context.NoteCategories.Where(x => x.ID == id).FirstOrDefault();
                            category.Name = model.Name;
                            category.Description = model.Description;
                            category.ModifiedBy = usrid;
                            category.ModifiedDate = DateTime.Now;
                            category.IsActive = true;
                            context.SaveChanges();
                        }

                        return RedirectToAction("ManageCategory");
                    }

                    return View(model);
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }


        //Manage Type, Add Type, edit Type
        public ActionResult ManageType(string sortOrder, string currentFilter, string searchString, int? page)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    //For Process
                    List<NoteType> typelist = context.NoteTypes.ToList();
                    var process = from c in typelist
                                  select new AdminSetting
                                  {
                                      id = c.ID,
                                      name = c.Name,
                                      description = c.Description,
                                      addedby = context.Users.Where(x => x.ID == c.CreatedBy).Select(x => x.FirstName).FirstOrDefault() + " " +
                                                    context.Users.Where(x => x.ID == c.CreatedBy).Select(x => x.LastName).FirstOrDefault(),
                                      addeddate = Convert.ToDateTime(c.CreatedDate),
                                      active = c.IsActive == true ? "YES" : "NO"
                                  };

                    //For Searching
                    if (searchString != null)
                    {
                        page = 1;
                    }
                    else
                    {
                        searchString = currentFilter;
                    }
                    ViewBag.CurrentFilter = searchString;
                    if (!String.IsNullOrEmpty(searchString))
                    {
                        process = process.Where(s => s.name.ToLower().Contains(searchString.ToLower()) ||
                                                     s.description.ToLower().Contains(searchString.ToLower()) ||
                                                     s.addedby.ToLower().Contains(searchString.ToLower()) ||
                                                     s.addeddate.ToString().ToLower().Contains(searchString.ToLower()) ||
                                                     s.active.ToLower().Contains(searchString.ToLower())
                                                );
                    }
                    //For Sorting
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.type = sortOrder == "type" ? "type_desc" : "type";
                    ViewBag.description = sortOrder == "description" ? "description_desc" : "description";
                    ViewBag.addedby = sortOrder == "addedby" ? "addedby_desc" : "addedby";
                    ViewBag.addeddate = sortOrder == "addeddate" ? "addeddate_desc" : "addeddate";
                    ViewBag.active = sortOrder == "active" ? "active_desc" : "active";
                    switch (sortOrder)
                    {
                        case "type":
                            process = process.OrderByDescending(s => s.name);
                            break;
                        case "type_desc":
                            process = process.OrderByDescending(s => s.name);
                            break;
                        case "description":
                            process = process.OrderBy(s => s.description);
                            break;
                        case "description_desc":
                            process = process.OrderByDescending(s => s.description);
                            break;
                        case "addedby":
                            process = process.OrderBy(s => s.addedby);
                            break;
                        case "addedby_desc":
                            process = process.OrderByDescending(s => s.addedby);
                            break;
                        case "addeddate":
                            process = process.OrderBy(s => s.addeddate);
                            break;
                        case "addeddate_desc":
                            process = process.OrderByDescending(s => s.addeddate);
                            break;
                        case "active":
                            process = process.OrderBy(s => s.active);
                            break;
                        case "active_desc":
                            process = process.OrderByDescending(s => s.active);
                            break;
                        default:
                            process = process.OrderByDescending(s => s.addeddate);
                            break;
                    }

                    //For Paging
                    int pageSize = 10;
                    int pageNumber = (page ?? 1);
                    return View(process.ToPagedList(pageNumber, pageSize));
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult delete_type(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    var type = context.NoteTypes.Where(x => x.ID == id).FirstOrDefault();
                    type.IsActive = false;
                    context.SaveChanges();
                    return RedirectToAction("ManageType");
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult add_type()
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    return View("CreateEdittype", new NoteType());
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult edit_type(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    return View("CreateEdittype", context.NoteTypes.Find(id));
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        [HttpPost]
        public ActionResult CreateEdittype(NoteType model)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {

                    if (ModelState.IsValid)
                    {
                        if (model.ID == 0)
                        {
                            NoteType type = new NoteType
                            {
                                Name = model.Name,
                                Description = model.Description,
                                CreatedBy = usrid,
                                ModifiedBy = usrid,
                                CreatedDate = DateTime.Now,
                                ModifiedDate = DateTime.Now,
                                IsActive = true
                            };
                            context.NoteTypes.Add(type);
                            context.SaveChanges();
                        }
                        else
                        {
                            var id = model.ID;
                            var type = context.NoteTypes.Where(x => x.ID == id).FirstOrDefault();
                            type.Name = model.Name;
                            type.Description = model.Description;
                            type.ModifiedBy = usrid;
                            type.ModifiedDate = DateTime.Now;
                            type.IsActive = true;
                            context.SaveChanges();
                        }

                        return RedirectToAction("ManageType");
                    }
                    return View(model);
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }


        //Manage Country, Add Type, edit Country
        public ActionResult ManageCountry(string sortOrder, string currentFilter, string searchString, int? page)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    //For Process
                    List<Country> countrylist = context.Countries.ToList();
                    var process = from c in countrylist
                                  select new AdminSetting
                                  {
                                      id = c.ID,
                                      name = c.Name,
                                      countrycode = c.CountryCode,
                                      addedby = context.Users.Where(x => x.ID == c.CreatedBy).Select(x => x.FirstName).FirstOrDefault() + " " +
                                                    context.Users.Where(x => x.ID == c.CreatedBy).Select(x => x.LastName).FirstOrDefault(),
                                      addeddate = Convert.ToDateTime(c.CreatedDate),
                                      active = c.IsActive == true ? "YES" : "NO"
                                  };

                    //For Searching
                    if (searchString != null)
                    {
                        page = 1;
                    }
                    else
                    {
                        searchString = currentFilter;
                    }
                    ViewBag.CurrentFilter = searchString;
                    if (!String.IsNullOrEmpty(searchString))
                    {
                        process = process.Where(s => s.name.ToLower().Contains(searchString.ToLower()) ||
                                                     s.countrycode.ToLower().Contains(searchString.ToLower()) ||
                                                     s.addedby.ToLower().Contains(searchString.ToLower()) ||
                                                     s.addeddate.ToString().ToLower().Contains(searchString.ToLower()) ||
                                                     s.active.ToLower().Contains(searchString.ToLower())
                                                );
                    }

                    //For Sorting
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.country = sortOrder == "country" ? "country_desc" : "country";
                    ViewBag.countrycode = sortOrder == "countrycode" ? "countrycode_desc" : "countrycode";
                    ViewBag.addedby = sortOrder == "addedby" ? "addedby_desc" : "addedby";
                    ViewBag.addeddate = sortOrder == "addeddate" ? "addeddate_desc" : "addeddate";
                    ViewBag.active = sortOrder == "active" ? "active_desc" : "active";
                    switch (sortOrder)
                    {
                        case "country":
                            process = process.OrderBy(s => s.name);
                            break;
                        case "country_desc":
                            process = process.OrderByDescending(s => s.name);
                            break;
                        case "countrycode":
                            process = process.OrderBy(s => s.countrycode);
                            break;
                        case "countrycode_desc":
                            process = process.OrderByDescending(s => s.countrycode);
                            break;
                        case "addedby":
                            process = process.OrderBy(s => s.addedby);
                            break;
                        case "addedby_desc":
                            process = process.OrderByDescending(s => s.addedby);
                            break;
                        case "addeddate":
                            process = process.OrderBy(s => s.addeddate);
                            break;
                        case "addeddate_desc":
                            process = process.OrderByDescending(s => s.addeddate);
                            break;
                        case "active":
                            process = process.OrderBy(s => s.active);
                            break;
                        case "active_desc":
                            process = process.OrderByDescending(s => s.active);
                            break;
                        default:
                            process = process.OrderByDescending(s => s.addeddate);
                            break;
                    }

                    //For Paging
                    int pageSize = 10;
                    int pageNumber = (page ?? 1);
                    return View(process.ToPagedList(pageNumber, pageSize));
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult delete_Country(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    var country = context.Countries.Where(x => x.ID == id).FirstOrDefault();
                    country.IsActive = false;
                    context.SaveChanges();
                    return RedirectToAction("ManageCountry");
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult add_Country()
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    return View("CreateEditcountry", new Country());
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult edit_Country(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    return View("CreateEditcountry", context.Countries.Find(id));
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        [HttpPost]
        public ActionResult CreateEditcountry(Country model)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    if (ModelState.IsValid)
                    {
                        if (model.ID == 0)
                        {
                            Country type = new Country
                            {
                                Name = model.Name,
                                CountryCode = model.CountryCode,
                                CreatedBy = usrid,
                                ModifiedBy = usrid,
                                CreatedDate = DateTime.Now,
                                ModifiedDate = DateTime.Now,
                                IsActive = true
                            };
                            context.Countries.Add(type);
                            context.SaveChanges();
                        }
                        else
                        {
                            var id = model.ID;
                            var country = context.Countries.Where(x => x.ID == id).FirstOrDefault();
                            country.Name = model.Name;
                            country.CountryCode = model.CountryCode;
                            country.ModifiedBy = usrid;
                            country.ModifiedDate = DateTime.Now;
                            country.IsActive = true;
                            context.SaveChanges();
                        }
                        return RedirectToAction("ManageCountry");
                    }
                    return View(model);
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }

        //My profile
        public ActionResult Myprofile()
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    //first time create
                    var myprofile = context.UserProfiles.Where(x => x.ID == usrid).FirstOrDefault();
                    if (myprofile == null)
                    {
                        var profile = context.Users.Where(x => x.ID == usrid).ToList().FirstOrDefault();
                        ViewBag.fname = profile.FirstName;
                        ViewBag.lname = profile.LastName;
                        ViewBag.email = profile.EmailID;
                        return View();
                    }
                    else
                    {
                        //Update the profile 
                        var profile = context.Users.Where(x => x.ID == usrid).ToList().FirstOrDefault();
                        var profilelist = context.UserProfiles.Where(x => x.UserID == usrid).ToList().FirstOrDefault();
                        ViewBag.fname = profile.FirstName;
                        ViewBag.lname = profile.LastName;
                        ViewBag.email = profile.EmailID;
                        ViewBag.secondaryemail = profilelist.SecondaryEmailAddress;
                        ViewBag.phonecode = profilelist.PhoneNumberCountryCode;
                        ViewBag.phoneno = profilelist.PhoneNumber;
                        ViewBag.profilepic = profilelist.ProfilePicture;
                        return View();
                    }
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        [HttpPost]
        public ActionResult Myprofile(Adminmyprofile model)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                if (ModelState.IsValid)
                {
                    var myprofile = context.UserProfiles.Where(x => x.ID == usrid).FirstOrDefault();
                    //If Firsttime update 
                    if (myprofile == null)
                    {

                        var path3 = "";
                        if (model.UserProfilePic != null)
                        {
                            var fileName3 = Path.GetFileName(model.UserProfilePic.FileName);
                            path3 = Path.Combine(Server.MapPath("~/UserFile/UserProfile"), fileName3);
                            model.UserProfilePic.SaveAs(path3);
                            path3 = fileName3.ToString();
                        }
                        else
                        {
                            path3 = "";
                        }
                        var profile = context.Users.Where(x => x.ID == usrid).ToList().FirstOrDefault();
                        profile.FirstName = model.firstname;
                        profile.LastName = model.lastname;
                        profile.ModifiedDate = System.DateTime.Now;
                        context.SaveChanges();
                        UserProfile usrprofile = new UserProfile
                        {
                            ID = usrid,
                            UserID = usrid,
                            SecondaryEmailAddress = model.secondaryemail,
                            PhoneNumberCountryCode = model.phonecode,
                            PhoneNumber = model.phonenumber,
                            ProfilePicture = path3,
                            AddressLine1 = "-",
                            AddressLine2 = "-",
                            City = "-",
                            State = "-",
                            ZipCode = "-",
                            Country = "-",
                            CreatedBy = usrid,
                            CreatedDate = System.DateTime.Now,
                            ModifiedBy = usrid,
                            ModifiedDate = System.DateTime.Now
                        };
                        context.UserProfiles.Add(usrprofile);
                        context.SaveChanges();
                        return RedirectToAction("Dashboard");
                    }
                    //Not the First Time 
                    else
                    {
                        var path3 = "";
                        if (model.UserProfilePic != null)
                        {
                            var fileName3 = Path.GetFileName(model.UserProfilePic.FileName);
                            path3 = Path.Combine(Server.MapPath("~/UserFile/UserProfile"), fileName3);
                            model.UserProfilePic.SaveAs(path3);
                            path3 = fileName3.ToString();
                        }
                        else
                        {
                            path3 = context.UserProfiles.Where(s => s.UserID == usrid).Select(s => s.ProfilePicture).FirstOrDefault();
                        }

                        var profile = context.Users.Where(x => x.ID == usrid).ToList().FirstOrDefault();
                        profile.FirstName = model.firstname;
                        profile.LastName = model.lastname;
                        profile.ModifiedDate = DateTime.Now;
                         context.SaveChanges();
                        var usrprofile = context.UserProfiles.Where(x => x.ID == usrid).FirstOrDefault();
                        usrprofile.SecondaryEmailAddress = model.secondaryemail;
                        usrprofile.ProfilePicture = path3.ToString();
                        usrprofile.PhoneNumber = model.phonenumber;
                        usrprofile.PhoneNumberCountryCode = model.phonecode;
                        usrprofile.ModifiedDate = DateTime.Now;
                        context.SaveChanges();
                        return RedirectToAction("Dashboard");
                    }
                }
                return View();
            }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }


        //Logout
        public ActionResult Logout()
        {
            usrid = 0;
            Session["id"] = null;
            Session["Userrole"] = null;
            Session["Userprofile"] = null;
            return RedirectToAction("Home", "User");
        }


        //Manage Administration
        public ActionResult ManageAdministrator(string sortOrder, string currentFilter, string searchString, int? page)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    //For the table
                    List<User> userlist = context.Users.ToList();
                    var process = from u in userlist.Where(x => x.RoleID.Equals(2))
                                  select new Adminmanageadministrator
                                  {
                                      id = u.ID,
                                      firstname = u.FirstName,
                                      lastname = u.LastName,
                                      email = u.EmailID,
                                      phoneno = context.UserProfiles.Where(x => x.ID == u.ID).Select(x => x.PhoneNumber).FirstOrDefault(),
                                      addeddate = Convert.ToDateTime(u.CreatedDate),
                                      active = u.IsActive == true ? "YES" : "NO"
                                  };
                    //Searching
                    if (searchString != null)
                    {
                        page = 1;
                    }
                    else
                    {
                        searchString = currentFilter;
                    }
                    ViewBag.CurrentFilter = searchString;
                    if (!String.IsNullOrEmpty(searchString))
                    {
                        process = process.Where(s => s.firstname.ToLower().Contains(searchString.ToLower()) ||
                                                     s.lastname.ToLower().Contains(searchString.ToLower()) ||
                                                     s.email.ToLower().Contains(searchString.ToLower()) ||
                                                     s.addeddate.ToString().ToLower().Contains(searchString.ToLower()) ||
                                                     s.active.ToLower().Contains(searchString.ToLower()));
                    }
                    //Sorting
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.firstname = sortOrder == "firstname" ? "firstname_desc" : "firstname";
                    ViewBag.lastname = sortOrder == "lastname" ? "lastname_desc" : "lastname";
                    ViewBag.email = sortOrder == "email" ? "email_desc" : "email";
                    ViewBag.dateadded = sortOrder == "dateadded" ? "dateadded_desc" : "dateadded";
                    ViewBag.phone = sortOrder == "phone" ? "phone_desc" : "phone";
                    ViewBag.active = sortOrder == "active" ? "active_desc" : "active";
                    switch (sortOrder)
                    {
                        case "firstname":
                            process = process.OrderBy(s => s.firstname);
                            break;
                        case "firstname_desc":
                            process = process.OrderByDescending(s => s.firstname);
                            break;
                        case "lastname":
                            process = process.OrderBy(s => s.lastname);
                            break;
                        case "lastname_desc":
                            process = process.OrderByDescending(s => s.lastname);
                            break;
                        case "email":
                            process = process.OrderBy(s => s.email);
                            break;
                        case "email_desc":
                            process = process.OrderByDescending(s => s.email);
                            break;
                        case "dateadded":
                            process = process.OrderBy(s => s.addeddate);
                            break;
                        case "dateadded_desc":
                            process = process.OrderByDescending(s => s.addeddate);
                            break;
                        case "phone":
                            process = process.OrderBy(s => s.phoneno);
                            break;
                        case "phone_desc":
                            process = process.OrderByDescending(s => s.phoneno);
                            break;
                        case "active":
                            process = process.OrderBy(s => s.active);
                            break;
                        case "active_desc":
                            process = process.OrderByDescending(s => s.active);
                            break;
                        default:
                            process = process.OrderBy(s => s.addeddate);
                            break;
                    }
                    //Paging
                    int pageSize = 10;
                    int pageNumber = (page ?? 1);
                    return View(process.ToPagedList(pageNumber, pageSize));
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult Delete_administrator(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    var usr = context.Users.Where(x => x.ID == id).FirstOrDefault();
                    usr.IsActive = false;
                    context.SaveChanges();
                    return RedirectToAction("ManageAdministrator");
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult addedit_administrator(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    if (id == null)
                    {
                        return View();
                    }
                    else
                    {
                        var userlist = context.Users.Where(x => x.ID == id).FirstOrDefault();
                        var usrprofile = context.UserProfiles.Where(x => x.ID == id).FirstOrDefault();

                        ViewBag.id = userlist.ID;
                        ViewBag.firstname = userlist.FirstName;
                        ViewBag.lastname = userlist.LastName;
                        ViewBag.email = userlist.EmailID;
                        if (usrprofile != null)
                        {
                            ViewBag.phoneno = usrprofile.PhoneNumber;
                            ViewBag.phonecode = usrprofile.PhoneNumberCountryCode;
                        }
                        else
                        {
                            ViewBag.phoneno = "";
                            ViewBag.phonecode = "";
                        }
                        return View();
                    }
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        [HttpPost]
        public ActionResult addedit_administrator(Adminmanageadministrator model)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    if (ModelState.IsValid)
                    {
                        //Add data
                        if (ModelState.IsValid && model.id == 0)
                        {
                            var repeat = context.Users.Where(x => x.EmailID == model.email).FirstOrDefault();
                            if (repeat == null)
                            {
                                var ActivationCode = Guid.NewGuid().ToString();
                                User usr = new User
                                {
                                    RoleID = 2,
                                    FirstName = model.firstname,
                                    LastName = model.lastname,
                                    EmailID = model.email,
                                    Password = model.firstname + DateTime.Now,
                                    IsEmailVerified = false,
                                    CreatedDate = DateTime.Now,
                                    CreatedBy = usrid,
                                    ModifiedBy = usrid,
                                    ModifiedDate = DateTime.Now,
                                    ActivationCode = ActivationCode,
                                    IsActive = true
                                };
                                context.Users.Add(usr);
                                context.SaveChanges();
                                return RedirectToAction("ManageAdministrator");
                            }
                            ViewBag.administratorerror = "Enter valid detail.";
                            return View();
                        }
                        //editdate
                        else
                        {
                            var usr = context.Users.Where(x => x.ID == model.id).FirstOrDefault();
                            usr.FirstName = model.firstname;
                            usr.LastName = model.lastname;
                            usr.EmailID = model.email;
                            usr.IsActive = true;
                            usr.ModifiedDate = System.DateTime.Now;
                            context.SaveChanges();

                            var usrprofile = context.UserProfiles.Where(x => x.ID == model.id).FirstOrDefault();
                            if (usrprofile != null && model.phoneno != null && model.phonecode != null)
                            {
                                usrprofile.PhoneNumber = model.phoneno;
                                usrprofile.PhoneNumberCountryCode = model.phonecode;
                                usrprofile.ModifiedDate = System.DateTime.Now;
                                context.SaveChanges();
                            }
                            return RedirectToAction("ManageAdministrator");
                        }
                        ViewBag.administratorerror = "Enter valid detail.";
                        return View();
                    }
                    ViewBag.administratorerror = "Enter valid detail.";
                    return View();
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }


        //Manage System Configuration
        public ActionResult managesystemconfiguration()
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    var detail = context.SystemConfigurations.ToList();
                    ViewBag.email = detail.Where(x => x.Key.ToLower() == "email").Select(x => x.Value).FirstOrDefault();
                    ViewBag.phone = detail.Where(x => x.Key.ToLower() == "phone").Select(x => x.Value).FirstOrDefault();
                    ViewBag.facebook = detail.Where(x => x.Key.ToLower() == "facebook").Select(x => x.Value).FirstOrDefault();
                    ViewBag.twitter = detail.Where(x => x.Key.ToLower() == "twitter").Select(x => x.Value).FirstOrDefault();
                    ViewBag.linkedin = detail.Where(x => x.Key.ToLower() == "linkedin").Select(x => x.Value).FirstOrDefault();
                    ViewBag.defaultnoteimage = detail.Where(x => x.Key.ToLower() == "defaultnoteimage").Select(x => x.Value).FirstOrDefault();
                    ViewBag.defaultprofileimage = detail.Where(x => x.Key.ToLower() == "defaultprofileimage").Select(x => x.Value).FirstOrDefault();
                    return View();
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        [HttpPost]
        public ActionResult managesystemconfiguration(Adminmanagesystemconfiguration model)
        {
            NoteSystem();
            if ( usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    if (model.email != null)
                    {
                        var data = context.SystemConfigurations.Where(x => x.Key.ToLower() == "email").FirstOrDefault();
                        data.Value = model.email;
                        context.SaveChanges();
                    }
                    if (model.phone != null)
                    {
                        var data = context.SystemConfigurations.Where(x => x.Key.ToLower() == "phone").FirstOrDefault();
                        data.Value = model.phone;
                        context.SaveChanges();
                    }
                    if (model.facebook != null)
                    {
                        var data = context.SystemConfigurations.Where(x => x.Key.ToLower() == "facebook").FirstOrDefault();
                        data.Value = model.facebook;
                        context.SaveChanges();
                    }
                    if (model.linkedin != null)
                    {
                        var data = context.SystemConfigurations.Where(x => x.Key.ToLower() == "linkedin").FirstOrDefault();
                        data.Value = model.linkedin;
                        context.SaveChanges();
                    }
                    if (model.twitter != null)
                    {
                        var data = context.SystemConfigurations.Where(x => x.Key.ToLower() == "twitter").FirstOrDefault();
                        data.Value = model.twitter;
                        context.SaveChanges();
                    }
                    var noteimage = "";
                    if (model.defaultnoteimg != null)
                    {
                        var fileName3 = Path.GetFileName(model.defaultnoteimg.FileName);
                        noteimage = Path.Combine(Server.MapPath("~/UserFile/DisplayPictureName"), fileName3);
                        model.defaultnoteimg.SaveAs(noteimage);
                        noteimage = fileName3.ToString();
                        var data = context.SystemConfigurations.Where(x => x.Key.ToLower() == "defaultnoteimage").FirstOrDefault();
                        data.Value = noteimage;
                        context.SaveChanges();
                    }

                    var profileimg = "";
                    if (model.defaultprofileimg != null)
                    {
                        var fileName4 = Path.GetFileName(model.defaultprofileimg.FileName);
                        profileimg = Path.Combine(Server.MapPath("~/UserFile/UserProfile"), fileName4);
                        model.defaultprofileimg.SaveAs(profileimg);
                        profileimg = fileName4.ToString();
                        var data = context.SystemConfigurations.Where(x => x.Key.ToLower() == "defaultprofileimage").FirstOrDefault();
                        data.Value = profileimg;
                        context.SaveChanges();
                    }
                    return RedirectToAction("Dashboard");
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }


        //Note Detail
        public ActionResult Delete_review(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    var data = context.SellerNotesReviews.Where(x => x.ID == id).FirstOrDefault();
                    int noteid = data.NoteID;
                    context.SellerNotesReviews.Remove(data);
                    context.SaveChanges();
                    return RedirectToAction("Notedetail", new { id = noteid });
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        [ChildActionOnly]
        public ActionResult Notedetail_comment(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    List<SellerNotesReview> review = context.SellerNotesReviews.OrderByDescending(x => x.ID).Take(3).Where(x => x.NoteID == id).ToList();
                    List<User> userlist = context.Users.ToList();
                    List<UserProfile> userprofilelist = context.UserProfiles.ToList();
                    var process = from r in review
                                  join u in userlist on r.ReviewedByID equals u.ID into table1
                                  from u in table1.DefaultIfEmpty()
                                  select new AdminNotedetail
                                  {
                                      reviewid = r.ID,
                                      reviewername = u.FirstName + " " + u.LastName,
                                      reviewerphoto = context.UserProfiles.Where(x => x.UserID == r.ID).Select(x => x.ProfilePicture).FirstOrDefault(),
                                      comment = r.Comments,
                                      ratingstar = Convert.ToInt32(r.Ratings)
                                  };
                    return PartialView(process);
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
        public ActionResult Notedetail(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    List<SellerNote> notedetail = context.SellerNotes.Where(x => x.ID == id).ToList();
                    var process = from n in notedetail
                                  select new AdminNotedetail
                                  {

                                      noteid = n.ID,
                                      notephoto = n.DisplayPicture,
                                      title = n.Title,
                                      category = context.NoteCategories.Where(x => x.ID == n.Category).Select(x => x.Name).FirstOrDefault(),
                                      discription = n.Description,
                                      institution = n.UniversityName,
                                      country = context.Countries.Where(x => x.ID == n.Country).Select(x => x.Name).FirstOrDefault(),
                                      coursename = n.Course,
                                      coursecode = n.CourseCode,
                                      professor = n.Professor,
                                      noofpages = Convert.ToInt32(n.NumberOfPages),
                                      Approveddate = Convert.ToDateTime(n.PublishedDate),
                                      inappropriate = context.SellerNotesReportedIssues.Where(t => t.NoteID == id).Count(),
                                      countrating = context.SellerNotesReviews.Where(s => s.NoteID == id).Count(),
                                      averagerating = context.SellerNotesReviews.Where(s => s.NoteID == id).Count() == 0 ? 0 : Convert.ToInt32(context.SellerNotesReviews.Where(s => s.NoteID == id).Select(s => s.Ratings).Average()),
                                      notepreview = n.NotesPreview
                                  };
                    ViewBag.notepreview = context.SellerNotes.Where(x => x.ID == id).Select(x => x.NotesPreview).FirstOrDefault();

                    return View(process);
                }
                catch (Exception e)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
            {
                return RedirectToAction("Login", "User");
            }
        }
    }
}