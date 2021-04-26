using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Notes.Models;
using System.Net.Mail;
using System.IO;
using System.Data;
using PagedList;
using System.Web.Security;

namespace Notes.Controllers
{
    public class UserController : Controller
    {
        // GET: User
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
        
        //Home Page
        public ActionResult Home()
        {
            NoteSystem();
            return View();
        }
        
        //Logout
        public ActionResult Logout() {
            NoteSystem();
            usrid = 0;
            usrrole = 0;
            Session["usrid"] = "";
            Session["usrrole"] = "";
            return RedirectToAction("Login");
        }

        //Mail
        private void SendEmail(string receiver, string subject, string body)
        {
            NoteSystem();
            string sendmail = Session["email"].ToString();
            using (MailMessage mailMessage = new MailMessage())
            {
                mailMessage.From = new MailAddress(sendmail, "janakpatel patel");
                mailMessage.Subject = subject;
                mailMessage.Body = body;
                mailMessage.IsBodyHtml = true;
                mailMessage.To.Add(new MailAddress(receiver));
                SmtpClient smtp = new SmtpClient();
                smtp.Host = "smtp.gmail.com";
                smtp.EnableSsl = true;
                System.Net.NetworkCredential NetworkCred = new System.Net.NetworkCredential();
                NetworkCred.UserName = sendmail;
                NetworkCred.Password = "Nmplace1";
                smtp.UseDefaultCredentials = true;
                smtp.Credentials = NetworkCred;
                smtp.Port = 587;
                smtp.Send(mailMessage);
            }
        }

        //Encrypt the string
        public string EnryptString(string password)
        {
            byte[] b = System.Text.ASCIIEncoding.ASCII.GetBytes(password);
            string encrypted = Convert.ToBase64String(b);
            return encrypted;
        }
        
        //SignUp
        [HttpGet]
        public ActionResult Signup()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Signup(Signup model)
        {
            if (ModelState.IsValid)
            {
                //email already in table
                if (context.Users.Any(x => x.EmailID == model.EmailID))
                {
                    ViewBag.error = String.Format("Already you have an account exists.");
                    return View();
                }
                else
                {
                    //send verification email 
                    var ActivationCode = Guid.NewGuid().ToString();
                    var name = model.FirstName + " " + model.LastName; 
                    string body = "";
                    using (StreamReader reader = new StreamReader(Server.MapPath("~/email/signupmail.html")))
                    {
                        body = reader.ReadToEnd();
                    }
                    string subject= "Note Marketplace - Email Verification";
                    string link = "<br /><a style=\"color:white; margin:5px;\" href = '" + string.Format("{0}://{1}/User/Activation/{2}", Request.Url.Scheme, Request.Url.Authority, ActivationCode) + "'>Click here to Activate</a>";
                    body = body.Replace("[Name]", name);
                    body = body.Replace("[link]", link);
                    SendEmail(model.EmailID, subject, body);
                    var password = model.Password;
                    var encpassword = EnryptString(password);
                    //Entry in User table
                    var user = new User
                    {
                        RoleID = 1,
                        FirstName = model.FirstName,
                        LastName = model.LastName,
                        EmailID = model.EmailID,
                        Password = encpassword,
                        IsEmailVerified = false,
                        CreatedDate = DateTime.Now,
                        ModifiedDate = DateTime.Now,
                        ActivationCode = ActivationCode,
                        IsActive = false,
                    };
                    context.Users.Add(user);
                    context.SaveChanges();
                    return RedirectToAction("Login");
                }
            }
            return View();
        }

        //Activation Page
        [HttpGet]
        public ActionResult Activation()
        {
            ViewBag.Message = "Invalid Activation code.";
            if (RouteData.Values["id"] != null)
            {
                string activationCode = new Guid(RouteData.Values["id"].ToString()).ToString();
                var id = context.Users.Where(u => u.ActivationCode == activationCode).FirstOrDefault();
                if (id != null)
                {
                    id.IsEmailVerified = true;
                    id.IsActive = true;
                    context.SaveChanges();
                    ViewBag.Message = "Your email verified successfully.";
                }
            }
            return View();
        }

        //Login
        [HttpGet]
        public ActionResult Login()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Login(Login model)
        {
            NoteSystem();
            if (ModelState.IsValid)
            {
                var encpassword = EnryptString(model.Password);
                //Email, Password, and Isactive  
                var obj = context.Users.Where(a => a.EmailID.Equals(model.EmailID) && a.Password.Equals(encpassword)).FirstOrDefault();
                if (obj != null)
                {

                    FormsAuthentication.SetAuthCookie(model.EmailID, model.rememberme);
                    if (model.rememberme)
                    {
                        HttpCookie email = new HttpCookie("EmialID");
                        email.Expires = DateTime.Now.AddSeconds(3600);
                        email.Value = model.EmailID;
                        Response.Cookies.Add(email);
                    }
                    usrid = obj.ID;
                    usrrole = obj.RoleID;
                    Session["usrid"] = obj.ID.ToString();
                    Session["usrrole"] = obj.RoleID.ToString();
                    //UserRole is Superadmin
                    if (obj.IsActive == true && obj.RoleID.Equals(3))
                    {
                        var superadmin = context.UserProfiles.Where(b => b.UserID == obj.ID).FirstOrDefault();
                        //If profile Picture was added
                        if (superadmin != null && !string.IsNullOrEmpty(superadmin.ProfilePicture))
                        {
                            Session["Userprofile"] = superadmin.ProfilePicture;
                            return RedirectToAction("admin", "Admin");
                        }
                        else
                        {
                            Session["Userprofile"] = Session["defaultprofilepic"].ToString();
                            return RedirectToAction("admin", "Admin");
                        }
                    }
                    //UserRole is Admin
                    else if (obj.IsActive == true && obj.RoleID.Equals(2))
                    {
                        var admin = context.UserProfiles.Where(b => b.UserID == obj.ID).FirstOrDefault();
                        //If profile Picture was added
                        if (admin != null && !string.IsNullOrEmpty(admin.ProfilePicture))
                        {
                            Session["Userprofile"] = admin.ProfilePicture;
                            return RedirectToAction("admin", "Admin");
                        }
                        else
                        {
                            Session["Userprofile"] = Session["defaultprofilepic"];
                            return RedirectToAction("admin", "Admin");
                        }
                    }
                    //UserRole is user
                    else if (obj.IsActive == true && obj.RoleID.Equals(1))
                    {
                        var usr = context.UserProfiles.Where(b => b.UserID == obj.ID).FirstOrDefault();
                        //If profile added already 
                        if (usr != null)
                        {
                            if (!string.IsNullOrEmpty(usr.ProfilePicture))
                            {
                                Session["Userprofile"] = usr.ProfilePicture;
                                return RedirectToAction("Dashboard");
                            }
                            //If profile is not added 
                            else
                            {
                                Session["Userprofile"] = Session["defaultprofilepic"];
                                return RedirectToAction("Dashboard");
                            }
                        }
                        else
                        {
                            Session["Userprofile"] = Session["defaultprofilepic"];
                            return RedirectToAction("UserProfile");
                        }
                    }
                    //Email verification is remaining
                    else
                    {
                        ViewBag.error = String.Format("Please verify your email id.");
                        return View();
                    }
                }
                //email or password wrong or isactive == false
                else
                {
                    ViewBag.error = String.Format("Please enter valid username or password.");
                    return View();
                }
            }
            else
            {
                return View();
            }
        }

        //Forgot Password
        [HttpGet]
        public ActionResult Forgotpassword()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Forgotpassword(ForgotPassword model)
        {
            NoteSystem();
            //Email verification(Is in table or not) 
            var data = context.Users.Where(x => x.EmailID == model.EmailID).FirstOrDefault();
            if (data != null)
            {
                //random encrypted password
                string randompassword = data.FirstName+data.ID+data.LastName;
                var random = EnryptString(randompassword);
                var newpassword = EnryptString(random);
                
                //change old password 
                data.Password = newpassword;
                context.SaveChanges();

                //for mail to user
                string body = string.Empty;
                using (StreamReader reader = new StreamReader(Server.MapPath("~/email/Forgotpassword.htm")))
                {
                    body = reader.ReadToEnd();
                }
                body = body.Replace("[password]", random);
                string subject = "New Temporary Password has been created for you";
                SendEmail(model.EmailID, subject, body);
                TempData["Forgotpassword"] = "Your password has been changed successfully and newly generated password is sent on your registered email address.";
                return RedirectToAction("Login");
            }
            else
            {
                ViewBag.error = String.Format("Please enter correct email id.");
                return View();
            }
        }


        //DashBoard
        [ChildActionOnly]
        public ActionResult publishednote(string sortOrder1, string currentFilter1, string searchString1, int? page1)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    // process For published note table
                    List<SellerNote> sellernotelist = context.SellerNotes.Where(x => x.Status == 9 && x.SellerID == usrid && x.IsActive == true).ToList();
                    var process1 = from s in sellernotelist
                                   select new UserBuyerSoldRejectedDownloadDashboardNotes
                                   {
                                       noteid = s.ID,
                                       title = s.Title,
                                       category = context.NoteCategories.Where(x => x.ID == s.Category).Select(x => x.Name).FirstOrDefault(),
                                       addeddate = Convert.ToDateTime(s.PublishedDate),
                                       selltype = s.IsPaid == 1 ? "Paid" : "Free",
                                       price = Convert.ToDouble(s.SellingPrice)
                                   };
                    //searching system for table
                    if (searchString1 != null)
                    {
                        page1 = 1;
                    }
                    else
                    {
                        searchString1 = currentFilter1;
                    }
                    ViewBag.CurrentFilter1 = searchString1;
                    if (!String.IsNullOrEmpty(searchString1))
                    {
                        process1 = process1.Where(s => s.title.ToLower().Contains(searchString1.ToLower())
                                           || s.category.ToLower().Contains(searchString1.ToLower())
                                           || s.addeddate.ToString().ToLower().Contains(searchString1.ToLower())
                                           || s.selltype.ToString().ToLower().Contains(searchString1.ToLower())
                                           || s.price.ToString().ToLower().Contains(searchString1.ToLower())
                                           );
                    }
                    //sorting system for table 
                    ViewBag.CurrentSort1 = sortOrder1;
                    ViewBag.title1 = sortOrder1 == "title" ? "title_desc" : "title";
                    ViewBag.category1 = sortOrder1 == "category" ? "category_desc" : "category";
                    ViewBag.selltype1 = sortOrder1 == "selltype" ? "selltype_desc" : "selltype";
                    ViewBag.date1 = sortOrder1 == "date" ? "date_desc" : "date";
                    ViewBag.price1 = sortOrder1 == "price" ? "price_desc" : "price";
                    switch (sortOrder1)
                    {
                        case "title":
                            process1 = process1.OrderBy(s => s.title);
                            break;
                        case "title_desc":
                            process1 = process1.OrderByDescending(s => s.title);
                            break;
                        case "category":
                            process1 = process1.OrderBy(s => s.category);
                            break;
                        case "category_desc":
                            process1 = process1.OrderByDescending(s => s.category);
                            break;
                        case "selltype":
                            process1 = process1.OrderBy(s => s.selltype);
                            break;
                        case "selltype_desc":
                            process1 = process1.OrderByDescending(s => s.selltype);
                            break;
                        case "price":
                            process1 = process1.OrderBy(s => s.price);
                            break;
                        case "price_desc":
                            process1 = process1.OrderByDescending(s => s.price);
                            break;
                        case "date":
                            process1 = process1.OrderBy(s => s.addeddate);
                            break;
                        case "date_desc":
                            process1 = process1.OrderByDescending(s => s.addeddate);
                            break;
                        default:
                            process1 = process1.OrderByDescending(s => s.addeddate);
                            break;
                    }
                    //paging system for table
                    int pageSize1 = 5;
                    int pageNumber1 = (page1 ?? 1);
                    return PartialView(process1.ToPagedList(pageNumber1, pageSize1));
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
        public ActionResult Inprocessnote(string sortOrder, string currentFilter, string searchString, int? page)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {                    //process for inprocess notes
                    List<SellerNote> sellernotelist = context.SellerNotes.Where(x => x.Status != 9 && x.SellerID == usrid && x.IsActive == true).ToList();
                    var process = from s in sellernotelist
                                  select new UserBuyerSoldRejectedDownloadDashboardNotes
                                  {
                                      noteid = s.ID,
                                      title = s.Title,
                                      category = context.NoteCategories.Where(x => x.ID == s.Category).Select(x => x.Name).FirstOrDefault(),
                                      addeddate = Convert.ToDateTime(s.PublishedDate),
                                      statusid = s.Status,
                                      status = context.ReferenceDatas.Where(x => x.ID == s.Status).Select(x => x.Value).FirstOrDefault()
                                  };
                    //searching for the table
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
                                           || s.status.ToString().ToLower().Contains(searchString.ToLower())
                                           || s.addeddate.ToString().ToLower().Contains(searchString.ToLower())
                                          );
                    }
                    //Sorting for the table
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.title = sortOrder == "title" ? "title_desc" : "title";
                    ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
                    ViewBag.status = sortOrder == "status" ? "status_desc" : "status";
                    ViewBag.date = sortOrder == "date" ? "date_desc" : "date";
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
                        case "date":
                            process = process.OrderBy(s => s.addeddate);
                            break;
                        case "date_desc":
                            process = process.OrderByDescending(s => s.addeddate);
                            break;
                        default:
                            process = process.OrderByDescending(s => s.addeddate);
                            break;
                    }
                    //paging for the table
                    int pageSize = 5;
                    int pageNumber = (page ?? 1);
                    return PartialView(process.ToPagedList(pageNumber, pageSize));
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
        public ActionResult Dashboard()
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {          
                    //Dashboard main box heading
                    ViewBag.downloadno = context.Downloads.Where(x => x.Downloader == usrid && x.IsSellerHasAllowedDownload == true).Count();
                    ViewBag.rejectno = context.SellerNotes.Where(x => x.Status == 10 && x.SellerID == usrid).Count();
                    ViewBag.Buyerreuest = context.Downloads.Where(x => x.Seller == usrid && x.IsSellerHasAllowedDownload == false).Count();
                    ViewBag.notesold = context.Downloads.Where(x => x.Seller == usrid && x.IsSellerHasAllowedDownload == true).Count();
                    ViewBag.Total = Convert.ToInt32(context.Downloads.Where(x => x.Seller == usrid && x.IsSellerHasAllowedDownload == true).Sum(u => u.PurchasedPrice));
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
        public ActionResult Delete(int id)
        {
            try
            {
                if (usrid != 0 && usrrole.Equals(1))
                {
                    //delete from sellernote and sellernoteattachment table
                    var data = context.SellerNotesAttachements.Where(x => x.NoteID == id).First();
                    var data1 = context.SellerNotes.Where(x => x.ID == id).First();
                    context.SellerNotesAttachements.Remove(data);
                    context.SaveChanges();
                    context.SellerNotes.Remove(data1);
                    context.SaveChanges();
                    return RedirectToAction("Dashboard");
                }
                else
                {
                    return RedirectToAction("error", "User");
                }
            }
            catch (Exception e)
            {
                return RedirectToAction("Login", "User");
            }
        }


        [HttpGet]
        // Add/Edit Note Page
        public ActionResult Addnote()
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    //For the Country, Notetype, NoteCategory Dropdown
                    int sellerid = Convert.ToInt32(Session["ID"]);
                    var category = context.NoteCategories.Where(x => x.IsActive == true).ToList();
                    SelectList list = new SelectList(category, "ID", "Name");
                    ViewBag.category = list;
                    var type = context.NoteTypes.Where(x => x.IsActive == true).ToList();
                    SelectList list1 = new SelectList(type, "ID", "Name");
                    ViewBag.type = list1;
                    var country = context.Countries.Where(x => x.IsActive == true).ToList();
                    SelectList list2 = new SelectList(country, "ID", "Name");
                    ViewBag.country = list2;
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
        public ActionResult Addnote(Addnote model)
        {
            Addnote();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    if (ModelState.IsValid)
                    {
                        //Status save or published
                        int statusid = Convert.ToInt32(model.Button);

                        //For the Uploaded NotePreview and DisplayPicture  Files
                        var NotePreviewPath = "";
                        var DisplayPicturePath = "";
                        if (model.DisplayPictureFile != null)
                        {
                            var DisplayFileName = Path.GetFileName(model.DisplayPictureFile.FileName);
                            DisplayPicturePath = Path.Combine(Server.MapPath("~/UserFile/DisplayPictureName"), DisplayFileName);
                            model.DisplayPictureFile.SaveAs(DisplayPicturePath);
                            DisplayPicturePath = DisplayFileName;
                        }
                        else
                        {
                            DisplayPicturePath = "";
                        }
                        if (model.NotesPreviewFile != null)
                        {
                            var NotePreviewName = Path.GetFileName(model.NotesPreviewFile.FileName);
                            NotePreviewPath = Path.Combine(Server.MapPath("~/UserFile/NotesPreview"), NotePreviewName);
                            model.NotesPreviewFile.SaveAs(NotePreviewPath);
                            NotePreviewPath = NotePreviewName;
                        }
                        else
                        {
                            NotePreviewPath = "";
                        }
                        //Save the Note in SellerNote table
                        SellerNote sellernote = new SellerNote();
                        sellernote.SellerID = usrid;
                        sellernote.Status = statusid;
                        sellernote.Title = model.Title;
                        sellernote.Category = model.Category;
                        sellernote.PublishedDate = DateTime.Now;
                        sellernote.NoteType = model.Type;
                        sellernote.NumberOfPages = model.NumberOfPages;
                        sellernote.Description = model.Description;
                        sellernote.DisplayPicture = DisplayPicturePath;
                        sellernote.NotesPreview = NotePreviewPath;
                        sellernote.UniversityName = model.UniversityName;
                        sellernote.Country = model.Country;
                        sellernote.Course = model.Course;
                        sellernote.CourseCode = model.CourseCode;
                        sellernote.Professor = model.Professor;
                        sellernote.IsPaid = model.IsPaid;
                        sellernote.IsActive = true;
                        //if Ispaid then price will be added
                        if (model.IsPaid == 1)
                        {
                            sellernote.SellingPrice = model.SellingPrice;
                        }
                        else
                        {
                            sellernote.SellingPrice = 0;
                        }
                        sellernote.CreatedDate = DateTime.Now;
                        sellernote.CreatedBy = usrid;
                        sellernote.ModifiedBy = usrid;
                        sellernote.ModifiedDate = DateTime.Now;
                        context.SellerNotes.Add(sellernote);
                        context.SaveChanges();

                        int noteid = context.SellerNotes.OrderByDescending(u => u.ID).Select(u => u.ID).FirstOrDefault();

                        //For SellerNoteAttachment
                        //For the uploaded Note
                        //var fileName3 = Path.GetFileName(model.UserProfilePic.FileName);
                        string fileName = Path.GetFileName(model.FileName.FileName);
                        string fileformat = fileName.Substring(fileName.IndexOf(".") + 1);
                        fileName = "file" + noteid +"."+fileformat;
                        var path = Path.Combine(Server.MapPath("~/UserFile/FileName"), fileName);
                        model.FileName.SaveAs(path);
                        path = "~/UserFile/FileName" + "/" + fileName;
                        //Save the data in table
                        SellerNotesAttachement att = new SellerNotesAttachement();
                        att.NoteID = noteid;
                        att.FileName = fileName;
                        att.FilePath = path;
                        att.CreatedBy = usrid;
                        att.CreatedDate = DateTime.Now;
                        att.ModifiedBy = usrid;
                        att.ModifiedDate = DateTime.Now;
                        att.IsActive = true;
                        context.SellerNotesAttachements.Add(att);

                        //If note submitted for the Review
                        if (statusid == 7)
                        {
                            // Mail to the Admin
                            var sellernamef = context.Users.Where(t => t.ID == usrid).Select(t => t.FirstName).FirstOrDefault();
                            var sellernamel = context.Users.Where(t => t.ID == usrid).Select(t => t.LastName).FirstOrDefault();
                            string body = string.Empty;
                            string subject = sellernamef + "" + sellernamel + " sent his note for review";
                            string Admin = context.Users.Where(x => x.RoleID.Equals(3)).Select(x => x.EmailID).FirstOrDefault();
                            using (StreamReader reader = new StreamReader(Server.MapPath("~/email/addnote.html")))
                            {
                                body = reader.ReadToEnd();
                            }
                            body = body.Replace("[Sellerf]", sellernamef);
                            body = body.Replace("[Sellerl]", sellernamel);
                            body = body.Replace("[NoteTitle]", model.Title);
                            SendEmail(Admin, subject, body);
                            context.SaveChanges();
                            return RedirectToAction("Dashboard");
                        }
                        //if submitted as draft
                        else
                        {
                            //Only save in the table
                            context.SaveChanges();
                            return RedirectToAction("Dashboard");
                        }
                    }
                    else
                    {
                        TempData["validinfo"] = "Please enter valid information.";
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

        [HttpGet]
        public ActionResult Editnote(int? noteid)
        {
            Addnote();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    //Take the data from table
                    var note = context.SellerNotes.FirstOrDefault(s => s.SellerID == usrid && s.ID == noteid);
                    var note1 = context.SellerNotesAttachements.FirstOrDefault(s => s.NoteID == noteid);
                    ViewBag.Noteid = note.ID;
                    ViewBag.notetitle = note.Title;
                    ViewBag.NumberOfPages = note.NumberOfPages;
                    ViewBag.Description = note.Description;
                    ViewBag.UniversityName = note.UniversityName;
                    ViewBag.Course = note.Course;
                    ViewBag.CourseCode = note.CourseCode;
                    ViewBag.Professor = note.Professor;
                    ViewBag.IsPaid = note.IsPaid;
                    ViewBag.SellingPrice = note.SellingPrice;
                    ViewBag.DisplayPictureFile = note.DisplayPicture;
                    ViewBag.NotesPreviewFile = note.NotesPreview;
                    ViewBag.FileName = note1.FileName;
                    ViewBag.selectedcategory = context.NoteCategories.Where(s => s.ID == note.Category).Select(s => s.Name).FirstOrDefault();
                    ViewBag.selectedtype = context.NoteTypes.Where(s => s.ID == note.NoteType).Select(s => s.Name).FirstOrDefault();
                    ViewBag.selectedcountry = context.Countries.Where(s => s.ID == note.Country).Select(s => s.Name).FirstOrDefault();
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
        public ActionResult Editnote(Editnote model)
        {
            Addnote();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    if (ModelState.IsValid)
                    {
                        int statusid = Convert.ToInt32(model.Button);

                        int note = Convert.ToInt32(model.noteid);

                        var sellernote = context.SellerNotes.Where(s => s.ID == note).FirstOrDefault();

                        //For the Upload NotePreview and DisplayPictureFile
                        var NotesPreviewFile = "";
                        var DisplayPictureFile = "";
                        if (model.DisplayPictureFile != null)
                        {
                            var fileName3 = Path.GetFileName(model.DisplayPictureFile.FileName);
                            DisplayPictureFile = Path.Combine(Server.MapPath("~/UserFile/DisplayPictureName"), fileName3);
                            model.DisplayPictureFile.SaveAs(DisplayPictureFile);
                            DisplayPictureFile = fileName3;
                        }
                        else
                        {
                            DisplayPictureFile = sellernote.DisplayPicture;
                        }
                        if (model.NotesPreviewFile != null)
                        {
                            var fileName2 = Path.GetFileName(model.NotesPreviewFile.FileName);
                            NotesPreviewFile = Path.Combine(Server.MapPath("~/UserFile/NotesPreview"), fileName2);
                            model.NotesPreviewFile.SaveAs(NotesPreviewFile);
                            NotesPreviewFile = fileName2;
                        }
                        else
                        {
                            NotesPreviewFile = sellernote.NotesPreview;
                        }
                        //Check the note is in table
                        if (sellernote != null)
                        {
                            sellernote.Status = statusid;
                            sellernote.Title = model.Title;
                            //If user change the category
                            if (model.Category != null)
                            {
                                sellernote.Category = Convert.ToInt32(model.Category);
                            }
                            else
                            {
                                sellernote.Category = sellernote.Category;
                            }
                            sellernote.PublishedDate = DateTime.Now;
                            //If user change the note type
                            if (model.Type != null)
                            {
                                sellernote.NoteType = model.Type;
                            }
                            else
                            {
                                sellernote.NoteType = sellernote.NoteType;
                            }
                            sellernote.NumberOfPages = model.NumberOfPages;
                            // If user change the description
                            if (model.Description != null)
                            {
                                sellernote.Description = model.Description;

                            }
                            else
                            {
                                sellernote.Description = sellernote.Description;

                            }
                            sellernote.DisplayPicture = DisplayPictureFile;
                            sellernote.NotesPreview = NotesPreviewFile;
                            sellernote.UniversityName = model.UniversityName;
                            //If user change the country
                            if (model.Country != null)
                            {
                                sellernote.Country = model.Country;
                            }
                            else
                            {
                                sellernote.Country = sellernote.Country;
                            }
                            sellernote.Course = model.Course;
                            sellernote.CourseCode = model.CourseCode;
                            sellernote.Professor = model.Professor;
                            sellernote.IsPaid = Convert.ToInt32(model.IsPaid);
                            //if Ispaid then price will be added
                            if (model.IsPaid == 1)
                            {
                                sellernote.SellingPrice = model.SellingPrice;
                            }
                            else
                            {
                                sellernote.SellingPrice = 0;
                            }
                            sellernote.ModifiedBy = usrid;
                            sellernote.ModifiedDate = DateTime.Now;
                            context.SaveChanges();

                        }

                        //For SellerNoteAttachment
                        var sellerattach = context.SellerNotesAttachements.Where(s => s.NoteID == note).FirstOrDefault();
                        var filename = "";
                        var filepath = "";
                        //if file was changed
                        if (model.FileName != null)
                        {
                            filename = sellerattach.FileName;
                            filepath = Path.Combine(Server.MapPath("~/UserFile/FileName"), filename);
                            model.FileName.SaveAs(filepath);
                        }
                        else
                        {
                            filename = sellerattach.FileName;
                            filepath = sellerattach.FilePath;
                        }
                        var att = context.SellerNotesAttachements.Where(s => s.NoteID == note).FirstOrDefault();
                        att.FileName = filename;
                        att.FilePath = filepath;
                        att.ModifiedBy = usrid;
                        att.ModifiedDate = DateTime.Now;
                        context.SaveChanges();

                        // if submitted for note under review
                        if (statusid == 7)
                        {
                            var user = context.Users.Where(t => t.ID == usrid).FirstOrDefault();
                            var sellernamef = user.FirstName;
                            var sellernamel = user.LastName;
                            string body = string.Empty;
                            string subject = sellernamef + "" + sellernamel + " sent his note for review";
                            string Admin = context.Users.Where(x => x.RoleID.Equals(1)).Select(x => x.EmailID).FirstOrDefault();
                            using (StreamReader reader = new StreamReader(Server.MapPath("~/email/addnote.html")))
                            {
                                body = reader.ReadToEnd();
                            }
                            body = body.Replace("[Sellerf]", sellernamef);
                            body = body.Replace("[Sellerl]", sellernamel);
                            body = body.Replace("[NoteTitle]", model.Title);
                            SendEmail(Admin, subject, body);
                            return RedirectToAction("Dashboard");
                        }
                        //if submitted as draft
                        else
                        {
                            return RedirectToAction("Dashboard");
                        }
                    }
                    else
                    {
                        ViewBag.error = "Enter valid detail";
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


        //searchnote
        //for average rating and count the total review
        int ratinginsearch(int? noteid)
        {
                ViewBag.count = context.SellerNotesReviews.Where(s => s.NoteID == noteid).Count();
                var data = context.SellerNotesReviews.Where(s => s.NoteID == noteid).Select(s => s.Ratings).ToList();
                if (ViewBag.count == 0)
                {
                    var average = 0;
                    return average;
                }
                else
                {
                    var average = Convert.ToInt32(data.Average());
                    return average;
                }
        
        }
        public ActionResult Searchnote(string Searching1, int? category1, string university1, string course1, int? type1, int? country1, int? Rating1, int? page)
        {
            NoteSystem();
            if (usrid == 0) {
                Session["usrrole"] = "";
            }
            ViewBag.Searching1 = Searching1;

            // Process of searchnote
            List<SellerNote> sellernotelist = context.SellerNotes.ToList();
            var notes = from s in sellernotelist.Where(u => u.IsActive == true && u.Status == 9 && u.SellerID != usrid).ToList()
                        select new Searchnote
                        {
                            noteid = s.ID,
                            title = s.Title,
                            noteimg = s.DisplayPicture,
                            university = s.UniversityName,
                            country = context.Countries.Where(x => x.ID == s.Country).Select(x => x.Name).FirstOrDefault(),
                            category = context.NoteCategories.Where(x => x.ID == s.Category).Select(x => x.Name).FirstOrDefault(),
                            type = context.NoteTypes.Where(x => x.ID == s.NoteType).Select(x => x.Name).FirstOrDefault(),
                            noofpage = Convert.ToInt32(s.NumberOfPages),
                            publishdate = Convert.ToDateTime(s.PublishedDate),
                            spamreport = context.SellerNotesReportedIssues.Where(x => x.NoteID == s.ID).Count(),
                            bookrating = ratinginsearch(s.ID),
                            totalrating = context.SellerNotesReviews.Where(x => x.NoteID == s.ID).Count(),
                            categoryid = s.Category,
                            typeid = s.NoteType,
                            Course = s.Course,
                            countryid = s.Country,
                        };

            //Dropdowns for sorting the books
            var category = notes.ToList().GroupBy(x => x.category).Select(group => group.First());
            SelectList list = new SelectList(category, "categoryid", "category");
            ViewBag.category = list;

            var type = notes.ToList().GroupBy(x => x.type).Select(group => group.First());
            SelectList list1 = new SelectList(type, "typeid", "type");
            ViewBag.type = list1;

            var university = notes.Where(x => x.university != null && x.university != " ").ToList().GroupBy(x => x.university).Select(group => group.First());
            SelectList universitylist = new SelectList(university, "university", "university");
            ViewBag.university = universitylist;

            var course = context.SellerNotes.Where(x => x.Course != null && x.SellerID != usrid).ToList().GroupBy(x => x.Course).Select(group => group.First());
            SelectList courselist = new SelectList(course, "Course", "Course");
            ViewBag.course = courselist;

            var country = notes.ToList().GroupBy(x => x.country).Select(group => group.First());
            SelectList countrylist = new SelectList(country, "countryid", "country");
            ViewBag.country = countrylist;

            //Searching system for book
            if (!String.IsNullOrEmpty(Searching1))
            {
                notes = notes.Where(m => m.title.ToLower().Contains(Searching1.ToLower())).ToList();
            }
            //University
            if (!String.IsNullOrEmpty(university1))
            {
                notes = notes.Where(m => m.university == university1).ToList();
            }
            //Note Type
            if (!String.IsNullOrEmpty(type1.ToString()))
            {
                notes = notes.Where(m => m.typeid.Equals(type1)).ToList();
            }
            //Country
            if (!String.IsNullOrEmpty(country1.ToString()))
            {
                notes = notes.Where(m => m.countryid.Equals(country1)).ToList();
            }
            //Course Name
            if (!String.IsNullOrEmpty(course1))
            {
                notes = notes.Where(m => m.Course == course1).ToList();
            }
            //Category Name
            if (!String.IsNullOrEmpty(category1.ToString()))
            {
                notes = notes.Where(m => m.categoryid.Equals(category1)).ToList();
            }
            //Rating
            if (!String.IsNullOrEmpty(Rating1.ToString()))
            {
                notes = notes.Where(m => m.bookrating >= Rating1).ToList();
            }
            ViewBag.totalnotes = notes.Count();

            //Paging for the process
            int pageSize = 9;
            int pageNumber = (page ?? 1);
            return View(notes.ToPagedList(pageNumber, pageSize));

        }


        //NoteDetail
        public ActionResult Notedetail(int? id)
        {
            NoteSystem();
            if (usrid == 0)
            {
                Session["usrid"] = "";
                Session["usrrole"] = "";
            }
            List<User> userlist = context.Users.ToList();
            List<UserProfile> userprofilelist = context.UserProfiles.ToList();
            List<SellerNote> sellernotelist = context.SellerNotes.ToList();
            List<NoteCategory> categorylist = context.NoteCategories.ToList();
            List<Country> countrylist = context.Countries.ToList();
            List<NoteType> typelist = context.NoteTypes.ToList();
            List<SellerNotesReview> reviewlist = context.SellerNotesReviews.ToList();

            ViewBag.data = from s in sellernotelist.Where(x => x.ID.Equals(id))
                           join c in categorylist on s.Category equals c.ID into table1
                           from c in table1.DefaultIfEmpty()
                           join co in countrylist on s.Country equals co.ID into table2
                           from co in table2.DefaultIfEmpty()
                           join t in typelist on s.NoteType equals t.ID into table3
                           from t in table3.DefaultIfEmpty()
                           select new Notedetail { sellernotelist = s, categorylist = c, countrylist = co, typelist = t };

            ViewBag.data2 = from r in reviewlist.Where(x => x.NoteID.Equals(id)).OrderByDescending(x => x.ID).Take(3)
                            join u in userlist on r.ReviewedByID equals u.ID into table1
                            from u in table1.DefaultIfEmpty()
                            join us in userprofilelist on r.ReviewedByID equals us.UserID into table2
                            from us in table2.DefaultIfEmpty()
                            select new Notedetail { reviewlist = r, userlist = u, userprofilelist = us };

            ViewBag.sellerid = usrid.ToString();
            ViewBag.noteid = id;
            var sellerid = context.SellerNotes.Where(t => t.ID == id).Select(t => t.SellerID).FirstOrDefault();
            ViewBag.sellername = context.Users.Where(t => t.ID == sellerid).Select(t => t.FirstName).FirstOrDefault();
            ViewBag.sellerlastname = context.Users.Where(t => t.ID == sellerid).Select(t => t.LastName).FirstOrDefault();

            int count = context.SellerNotesReviews.Where(s => s.NoteID == id).Count();
            ViewBag.count = count; 
            var data = context.SellerNotesReviews.Where(s => s.NoteID == id).Select(s => s.Ratings).ToList();
            if (count.Equals(0))
            {
                var average = 0;
            }
            else
            {
                var average = data.Average();
                ViewBag.average = Convert.ToInt32(average);
            }
            ViewBag.attach = context.SellerNotesAttachements.Where(t => t.NoteID == id).Select(t => t.FileName).FirstOrDefault();
            ViewBag.inappropriate = context.SellerNotesReportedIssues.Where(t => t.NoteID == id).Count();
            return View();
        }
        public ActionResult mailnotedetail(int? noteid)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    var note = context.SellerNotes.Where(x => x.ID == noteid).FirstOrDefault();
                    var attach = context.SellerNotesAttachements.Where(x => x.NoteID == noteid).FirstOrDefault();
                    int downloader = usrid;
                    var alreadyrequest = context.Downloads.Where(x => x.NoteID == noteid && x.Downloader == downloader).FirstOrDefault();
                    if (alreadyrequest != null)
                    {
                        TempData["notedetail"] = "You already request for the note.";
                        return RedirectToAction("Notedetail", new { id = noteid });
                    }
                    else
                    {
                        var download = new Download
                        {
                            NoteID = Convert.ToInt32(noteid),
                            Seller = Convert.ToInt32(note.SellerID),
                            Downloader = Convert.ToInt32(downloader),
                            AttachmentPath = attach.FilePath,
                            IsAttachmentDownloaded = false,
                            IsSellerHasAllowedDownload = false,
                            IsPaid = note.IsPaid,
                            PurchasedPrice = note.SellingPrice,
                            NoteTitle = note.Title,
                            AttachmentDownloadedDate = DateTime.Now,
                            NoteCategory = context.NoteCategories.Where(x => x.ID == note.Category).Select(x => x.Name).FirstOrDefault(),
                            ModifiedDate = DateTime.Now,
                            CreatedBy = downloader,
                            CreatedDate = DateTime.Now,
                            ModifiedBy = downloader,
                        };

                        context.Downloads.Add(download);
                        context.SaveChanges();
                        var sellerid = context.SellerNotes.Where(t => t.ID == noteid).Select(t => t.SellerID).FirstOrDefault();
                        var sellername = context.Users.Where(t => t.ID == sellerid).Select(t => t.FirstName).FirstOrDefault();
                        var username1 = context.Users.Where(t => t.ID == downloader).Select(t => t.FirstName).FirstOrDefault();
                        var username2 = context.Users.Where(t => t.ID == downloader).Select(t => t.LastName).FirstOrDefault();
                        var receiver = context.Users.Where(t => t.ID == sellerid).Select(t => t.EmailID).FirstOrDefault();
                        string body = string.Empty;
                        string subject = username1 + " " + username2 + "wants to purchase your notes ";
                        using (StreamReader reader = new StreamReader(Server.MapPath("~/email/mailnotedetail.html")))
                        {
                            body = reader.ReadToEnd();
                        }
                        body = body.Replace("[seller]", sellername);
                        body = body.Replace("[BuyerF]", username1);
                        body = body.Replace("[BuyerL]", username2);
                        SendEmail(receiver, subject, body);
                        TempData["notedetail"] = "Your request is send successfully.";
                        return RedirectToAction("Notedetail", new { id = noteid });
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
        public ActionResult Notedetaildownload(string path, int id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    var note = context.SellerNotes.Where(x => x.ID == id).FirstOrDefault();
                    var attach = context.SellerNotesAttachements.Where(x => x.NoteID == id).FirstOrDefault();

                    var already = context.Downloads.Where(x => x.Seller == note.SellerID && x.NoteID == id && x.Downloader == usrid).FirstOrDefault();
                    if (already == null)
                    {
                        var download = new Download
                        {
                            NoteID = Convert.ToInt32(id),
                            Seller = Convert.ToInt32(note.SellerID),
                            Downloader = usrid,
                            AttachmentPath = attach.FilePath,
                            IsAttachmentDownloaded = true,
                            IsSellerHasAllowedDownload = true,
                            AttachmentDownloadedDate = DateTime.Now,
                            IsPaid = note.IsPaid,
                            PurchasedPrice = note.SellingPrice,
                            NoteTitle = note.Title,
                            NoteCategory = context.NoteCategories.Where(x => x.ID == note.Category).Select(x => x.Name).FirstOrDefault(),
                            ModifiedDate = DateTime.Now,
                            CreatedBy = usrid,
                            CreatedDate = DateTime.Now,
                            ModifiedBy = usrid,
                        };
                        context.Downloads.Add(download);
                        context.SaveChanges();
                    }
                    string fullName = "C:\\Users\\Admin\\source\\repos\\Notes\\UserFile\\FileName\\" + path;
                    byte[] fileBytes = GetFile(fullName);
                    return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, path);
                }
                catch (Exception ex)
                {
                    return RedirectToAction("error", "User");
                }
            }
            else
                {
                    return RedirectToAction("error", "User");
                }
        }


        //BuyerRequest
        public ActionResult BuyerRequest(string sortOrder, string currentFilter, string searchString, int? page)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    //list of process for buyerrequest table
                    List<Download> downloadnotelist = context.Downloads.ToList();
                    var process1 = from d in downloadnotelist.Where(x => x.Seller.Equals(usrid) && x.IsSellerHasAllowedDownload == false)
                                   select new UserBuyerSoldRejectedDownloadDashboardNotes
                                   {
                                       noteid = d.NoteID,
                                       title = d.NoteTitle,
                                       email = context.Users.Where(x => x.ID == d.Downloader).Select(x => x.EmailID).FirstOrDefault(),
                                       category = d.NoteCategory,
                                       date = Convert.ToDateTime(d.CreatedDate),
                                       selltype = d.IsPaid == 1 ? "Paid" : "Free",
                                       price = Convert.ToDouble(d.PurchasedPrice)
                                   };
                    // searching for the table
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
                        process1 = process1.Where(s => s.title.ToLower().Contains(searchString.ToLower())
                                                    || s.email.ToLower().Contains(searchString.ToLower())
                                                    || s.category.ToLower().Contains(searchString.ToLower())
                                                    || s.date.ToString().ToLower().Contains(searchString.ToLower())
                                                    || s.selltype.ToLower().Contains(searchString.ToLower())
                                                    || s.price.ToString().ToLower().Contains(searchString.ToLower())
                                                    );
                    }
                    //sorting for the process
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.title = sortOrder == "title" ? "title_desc" : "title";
                    ViewBag.email = sortOrder == "email" ? "email_desc" : "email";
                    ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
                    ViewBag.selltype = sortOrder == "selltype" ? "selltype_desc" : "selltype";
                    ViewBag.price = sortOrder == "price" ? "price_desc" : "price";
                    ViewBag.date = sortOrder == "date" ? "date_desc" : "date";
                    switch (sortOrder)
                    {
                        case "title":
                            process1 = process1.OrderBy(s => s.title);
                            break;
                        case "title_desc":
                            process1 = process1.OrderByDescending(s => s.title);
                            break;
                        case "email":
                            process1 = process1.OrderBy(s => s.email);
                            break;
                        case "email_desc":
                            process1 = process1.OrderByDescending(s => s.email);
                            break;
                        case "category":
                            process1 = process1.OrderBy(s => s.category);
                            break;
                        case "category_desc":
                            process1 = process1.OrderByDescending(s => s.category);
                            break;
                        case "selltype":
                            process1 = process1.OrderBy(s => s.selltype);
                            break;
                        case "selltype_desc":
                            process1 = process1.OrderByDescending(s => s.selltype);
                            break;
                        case "price":
                            process1 = process1.OrderBy(s => s.price);
                            break;
                        case "price_desc":
                            process1 = process1.OrderByDescending(s => s.price);
                            break;
                        case "date":
                            process1 = process1.OrderBy(s => s.date);
                            break;
                        case "date_desc":
                            process1 = process1.OrderByDescending(s => s.date);
                            break;
                        default:
                            process1 = process1.OrderByDescending(s => s.date);
                            break;
                    }
                    //pagination
                    int pageSize = 10;
                    int pageNumber = (page ?? 1);
                    return View(process1.ToPagedList(pageNumber, pageSize));
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
        public ActionResult allowdownload()
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    if (RouteData.Values["id"] != null)
                    {
                        //Update the download table
                        int id = Convert.ToInt32(RouteData.Values["id"]);
                        var data = context.Downloads.Where(x => x.NoteID == id && x.Seller == usrid && x.IsSellerHasAllowedDownload == false).First();
                        if (data != null)
                        {
                            data.IsSellerHasAllowedDownload = true;
                            data.AttachmentDownloadedDate = DateTime.Now;
                            context.SaveChanges();
                        }
                        //For send the mail to user
                        var buyer = context.Users.Where(t => t.ID == data.Downloader).FirstOrDefault();
                        var seller = context.Users.Where(t => t.ID == data.Seller).FirstOrDefault();
                        var receiver = buyer.EmailID;
                        string body = string.Empty;
                        string subject = buyer.FirstName + " " + buyer.LastName + " Allow you to download a note ";
                        using (StreamReader reader = new StreamReader(Server.MapPath("~/email/allowdownload.html")))
                        {
                            body = reader.ReadToEnd();
                        }
                        body = body.Replace("[buyer]", buyer.FirstName + buyer.LastName);
                        body = body.Replace("[seller]", seller.FirstName + seller.LastName);
                        SendEmail(receiver, subject, body);

                    }
                    return RedirectToAction("BuyerRequest");
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


        //SoldNotes
        public ActionResult SoldNote(string sortOrder, string currentFilter, string searchString, int? page)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    //Process
                    List<Download> downloadnotelist = context.Downloads.ToList();
                    var process1 = from d in downloadnotelist.Where(x => x.Seller.Equals(usrid) && x.IsSellerHasAllowedDownload == true)
                                   select new UserBuyerSoldRejectedDownloadDashboardNotes
                                   {
                                       noteid = d.NoteID,
                                       title = d.NoteTitle,
                                       email = context.Users.Where(x => x.ID == d.Seller).Select(x => x.EmailID).FirstOrDefault(),
                                       category = d.NoteCategory,
                                       date = Convert.ToDateTime(d.AttachmentDownloadedDate),
                                       selltype = d.IsPaid == 1 ? "Paid" : "Free",
                                       price = Convert.ToDouble(d.PurchasedPrice)
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
                        process1 = process1.Where(s => s.title.ToLower().Contains(searchString.ToLower())
                                                       || s.email.ToLower().Contains(searchString.ToLower())
                                                       || s.category.ToLower().Contains(searchString.ToLower())
                                                       || s.price.ToString().ToLower().Contains(searchString.ToLower())
                                                        );
                    }

                    //Sorting
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.title = sortOrder == "title" ? "title_desc" : "title";
                    ViewBag.email = sortOrder == "email" ? "email_desc" : "email";
                    ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
                    ViewBag.selltype = sortOrder == "selltype" ? "selltype_desc" : "selltype";
                    ViewBag.price = sortOrder == "price" ? "price_desc" : "price";
                    ViewBag.date = sortOrder == "date" ? "date_desc" : "date";
                    switch (sortOrder)
                    {
                        case "title":
                            process1 = process1.OrderBy(s => s.title);
                            break;
                        case "title_desc":
                            process1 = process1.OrderByDescending(s => s.title);
                            break;
                        case "email":
                            process1 = process1.OrderBy(s => s.email);
                            break;
                        case "email_desc":
                            process1 = process1.OrderByDescending(s => s.email);
                            break;
                        case "category":
                            process1 = process1.OrderBy(s => s.category);
                            break;
                        case "category_desc":
                            process1 = process1.OrderByDescending(s => s.category);
                            break;
                        case "selltype":
                            process1 = process1.OrderBy(s => s.selltype);
                            break;
                        case "selltype_desc":
                            process1 = process1.OrderByDescending(s => s.selltype);
                            break;
                        case "price":
                            process1 = process1.OrderBy(s => s.price);
                            break;
                        case "price_desc":
                            process1 = process1.OrderByDescending(s => s.price);
                            break;
                        case "date":
                            process1 = process1.OrderBy(s => s.date);
                            break;
                        case "date_desc":
                            process1 = process1.OrderByDescending(s => s.date);
                            break;
                        default:
                            process1 = process1.OrderByDescending(s => s.date);
                            break;
                    }
                    //Paging
                    int pageSize = 10;
                    int pageNumber = (page ?? 1);
                    return View(process1.ToPagedList(pageNumber, pageSize));
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
        public ActionResult RejectedNote(string sortOrder, string currentFilter, string searchString, int? page)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    //process
                    List<SellerNote> sellernotelist = context.SellerNotes.ToList();
                    var process1 = from s in sellernotelist.Where(x => x.SellerID.Equals(usrid) && x.Status == 10)
                                   select new UserBuyerSoldRejectedDownloadDashboardNotes
                                   {
                                       noteid = s.ID,
                                       title = s.Title,
                                       remark = s.AdminRemark,
                                       category = context.NoteCategories.Where(x => x.ID == s.Category).Select(x => x.Name).FirstOrDefault()
                                   };

                    //searching
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
                        process1 = process1.Where(s => s.title.ToLower().Contains(searchString.ToLower())
                                                    || s.remark.ToLower().Contains(searchString.ToLower())
                                                    || s.category.ToLower().Contains(searchString.ToLower())
                                                   );
                    }

                    //sorting
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.title = sortOrder == "title" ? "title_desc" : "title";
                    ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
                    ViewBag.remark = sortOrder == "remark" ? "remark_desc" : "remark";
                    switch (sortOrder)
                    {
                        case "title":
                            process1 = process1.OrderBy(s => s.title);
                            break;
                        case "title_desc":
                            process1 = process1.OrderByDescending(s => s.title);
                            break;
                        case "category":
                            process1 = process1.OrderBy(s => s.category);
                            break;
                        case "category_desc":
                            process1 = process1.OrderByDescending(s => s.category);
                            break;
                        case "remark":
                            process1 = process1.OrderBy(s => s.remark);
                            break;
                        case "remark_desc":
                            process1 = process1.OrderByDescending(s => s.remark);
                            break;
                        default:  // Name ascending 
                            process1 = process1.OrderBy(s => s.title);
                            break;
                    }
                    //Pagination
                    int pageSize = 10;
                    int pageNumber = (page ?? 1);
                    return View(process1.ToPagedList(pageNumber, pageSize));
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
        public ActionResult clonenote(int? id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    int noteid = Convert.ToInt32(id);
                    var getnote = context.SellerNotes.Where(s => s.SellerID == usrid && s.ID == noteid && s.Status == 10).FirstOrDefault();
                    var getfile = context.SellerNotesAttachements.Where(x => x.NoteID == noteid).FirstOrDefault();
                    //save book in sellernote as a draft
                    if (getnote != null)
                    {
                        SellerNote s = new SellerNote
                        {
                            SellerID = getnote.SellerID,
                            Status = 6,
                            PublishedDate = DateTime.Now,
                            Title = getnote.Title,
                            Category = getnote.Category,
                            DisplayPicture = getnote.DisplayPicture,
                            NoteType = getnote.NoteType,
                            NumberOfPages = getnote.NumberOfPages,
                            Description = getnote.Description,
                            UniversityName = getnote.UniversityName,
                            Country = getnote.Country,
                            Course = getnote.Course,
                            CourseCode = getnote.CourseCode,
                            Professor = getnote.Professor,
                            IsPaid = getnote.IsPaid,
                            SellingPrice = getnote.SellingPrice,
                            NotesPreview = getnote.NotesPreview,
                            CreatedBy = usrid,
                            CreatedDate = DateTime.Now,
                            ModifiedBy = usrid,
                            ModifiedDate = DateTime.Now,
                            IsActive = true
                        };
                        context.SellerNotes.Add(s);
                        context.SaveChanges();
                        int attachid = context.SellerNotes.OrderByDescending(u => u.ID).Select(u => u.ID).FirstOrDefault();
                        //save book in sellernoteattachment as a draft
                        SellerNotesAttachement sa = new SellerNotesAttachement
                        {
                            NoteID = attachid,
                            FileName = getfile.FileName,
                            FilePath = getfile.FilePath,
                            CreatedBy = usrid,
                            CreatedDate = DateTime.Now,
                            ModifiedBy = usrid,
                            ModifiedDate = DateTime.Now
                        };
                        context.SellerNotesAttachements.Add(sa);
                        context.SaveChanges();
                    }
                    TempData["Clone"] = "Save this note as a draft note successfully.";
                    return RedirectToAction("RejectedNote", "User");
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
            if (usrid != 0 && usrrole.Equals(1))
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


        //My Download Note
        public ActionResult Mydownloads(string sortOrder, string currentFilter, string searchString, int? page)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    //process
                    List<Download> downloadnotelist = context.Downloads.ToList();
                    var process1 = from d in downloadnotelist.Where(x => x.Downloader.Equals(usrid) && x.IsSellerHasAllowedDownload == true)
                                   select new UserBuyerSoldRejectedDownloadDashboardNotes
                                   {
                                       noteid = d.NoteID,
                                       title = d.NoteTitle,
                                       category = d.NoteCategory,
                                       email = context.Users.Where(x => x.ID == d.Seller).Select(x => x.EmailID).FirstOrDefault(),
                                       selltype = d.IsPaid == 1 ? "Paid" : "Free",
                                       price = Convert.ToDouble(d.PurchasedPrice),
                                       date = Convert.ToDateTime(d.AttachmentDownloadedDate),
                                       attachpath = context.SellerNotesAttachements.Where(x => x.NoteID == d.NoteID).Select(x => x.FilePath).FirstOrDefault()
                                   };
                    //searching
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
                        process1 = process1.Where(s => s.title.ToLower().Contains(searchString.ToLower())
                                               || s.category.ToLower().Contains(searchString.ToLower())
                                               || s.email.ToLower().Contains(searchString.ToLower())
                                               || s.selltype.ToLower().Contains(searchString.ToLower())
                                               || s.date.ToString().ToLower().Contains(searchString.ToLower())
                                            );
                    }
                    //sorting            
                    ViewBag.CurrentSort = sortOrder;
                    ViewBag.title = sortOrder == "title" ? "title_desc" : "title";
                    ViewBag.email = sortOrder == "email" ? "email_desc" : "email";
                    ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
                    ViewBag.selltype = sortOrder == "selltype" ? "selltype_desc" : "selltype";
                    ViewBag.price = sortOrder == "price" ? "price_desc" : "price";
                    ViewBag.date = sortOrder == "date" ? "date_desc" : "date";

                    switch (sortOrder)
                    {
                        case "title":
                            process1 = process1.OrderBy(s => s.title);
                            break;
                        case "title_desc":
                            process1 = process1.OrderByDescending(s => s.title);
                            break;
                        case "email":
                            process1 = process1.OrderBy(s => s.email);
                            break;
                        case "email_desc":
                            process1 = process1.OrderByDescending(s => s.email);
                            break;
                        case "category":
                            process1 = process1.OrderBy(s => s.category);
                            break;
                        case "category_desc":
                            process1 = process1.OrderByDescending(s => s.category);
                            break;
                        case "selltype":
                            process1 = process1.OrderBy(s => s.selltype);
                            break;
                        case "selltype_desc":
                            process1 = process1.OrderByDescending(s => s.selltype);
                            break;
                        case "price":
                            process1 = process1.OrderBy(s => s.price);
                            break;
                        case "price_desc":
                            process1 = process1.OrderByDescending(s => s.price);
                            break;
                        case "date":
                            process1 = process1.OrderBy(s => s.date);
                            break;
                        case "date_desc":
                            process1 = process1.OrderByDescending(s => s.date);
                            break;
                        default:
                            process1 = process1.OrderByDescending(s => s.date);
                            break;
                    }

                    int pageSize = 10;
                    int pageNumber = (page ?? 1);
                    return View(process1.ToPagedList(pageNumber, pageSize));
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
        public ActionResult Inappropriate(string id, string remark)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    int noteid = Convert.ToInt32(id);
                    string remarks = remark;
                    var note = context.Downloads.FirstOrDefault(s => s.NoteID == noteid);
                    var reportedissue = context.SellerNotesReportedIssues.FirstOrDefault(c => c.NoteID == noteid && c.ReportedByID == usrid);
                    if (reportedissue != null)
                    {
                        TempData["Mydownload"] = "You already reported issue.";
                        return RedirectToAction("MyDownloads");
                    }
                    else
                    {
                        SellerNotesReportedIssue issue = new SellerNotesReportedIssue
                        {
                            NoteID = noteid,
                            ReportedByID = usrid,
                            AgainstDownloadID = note.ID,
                            Remarks = remarks,
                            CreatedDate = DateTime.Now,
                            CreatedBy = usrid,
                            ModifiedBy = usrid,
                            ModifiedDate = DateTime.Now
                        };
                        context.SellerNotesReportedIssues.Add(issue);

                        string downloadername = context.Users.Where(s => s.ID == usrid).Select(s => s.FirstName).FirstOrDefault();
                        string sellername = context.Users.Where(s => s.ID == note.Seller).Select(s => s.FirstName).FirstOrDefault();
                        string body = string.Empty;
                        string subject = downloadername + "Reported an issue for" + note.NoteTitle;
                        using (StreamReader reader = new StreamReader(Server.MapPath("~/email/reportmail.html")))
                        {
                            body = reader.ReadToEnd();
                        }
                        body = body.Replace("[Seller]", sellername);
                        body = body.Replace("[Member]", downloadername);
                        body = body.Replace("[NoteTitle]", note.NoteTitle);
                        string receiver = "janakpatel00002@gmail.com";
                        SendEmail(receiver, subject, body);

                        context.SaveChanges();
                        TempData["Mydownload"] = "Your reported issue save successfully.";
                        return RedirectToAction("MyDownloads");
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
        public ActionResult rating(string rating, string id, string comments)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    int noteid = Convert.ToInt32(id);
                    int ratings = Convert.ToInt32(rating);
                    string remarks = comments;
                    var note = context.Downloads.FirstOrDefault(s => s.NoteID == noteid);

                    var sellerreview = context.SellerNotesReviews.FirstOrDefault(c => c.ReviewedByID == usrid && c.NoteID == noteid);

                    if (sellerreview != null)
                    {
                        sellerreview.Ratings = ratings;
                        sellerreview.Comments = remarks;
                        context.SaveChanges();
                        TempData["Mydownload"] = "Your rating save successfully.";
                        return RedirectToAction("MyDownloads");


                    }
                    else
                    {
                        SellerNotesReview review = new SellerNotesReview
                        {
                            NoteID = noteid,
                            ReviewedByID = usrid,
                            AgainstDownloadsID = note.ID,
                            Ratings = ratings,
                            Comments = remarks,
                            CreatedBy = usrid,
                            CreatedDate = DateTime.Now,
                            ModifiedBy = usrid,
                            ModifiedDate = DateTime.Now
                        };
                        context.SellerNotesReviews.Add(review);
                        context.SaveChanges();
                        TempData["Mydownload"] = "Your rating save successfully.";
                        return RedirectToAction("MyDownloads");


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
        public ActionResult MyDownloadNote(string path, int id)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    var note = context.SellerNotes.Where(x => x.ID == id).FirstOrDefault();
                    var attach = context.SellerNotesAttachements.Where(x => x.NoteID == id).FirstOrDefault();
                    var data = context.Downloads.Where(x => x.NoteID == id && x.Downloader == usrid).FirstOrDefault();
                    data.AttachmentDownloadedDate = DateTime.Now;
                    data.IsAttachmentDownloaded = true;
                    data.IsSellerHasAllowedDownload = true;
                    context.SaveChanges();
                    string fullName = "C:\\Users\\Admin\\source\\repos\\Notes\\UserFile\\FileName\\" + attach.FileName;
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


        //UserProfile
        [HttpGet]
        public ActionResult UserProfile()
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
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
        public ActionResult UserProfile(Userprofile model)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {

                    //Model Verification
                    if (ModelState.IsValid)
                    {
                        //For the Profile Pic
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
                        //Add data in UserProfile
                        UserProfile userprofile = new UserProfile
                        {
                            ID = usrid,
                            UserID = usrid,
                            Gender = model.Gender,
                            DOB = model.DOB,
                            SecondaryEmailAddress = model.SecondaryEmailAddress,
                            PhoneNumberCountryCode = model.PhoneNumberCountryCode.ToString(),
                            PhoneNumber = model.PhoneNumber,
                            ProfilePicture = path3,
                            AddressLine1 = model.AddressLine1,
                            AddressLine2 = model.AddressLine2,
                            City = model.City,
                            State = model.State,
                            ZipCode = model.ZipCode,
                            Country = model.Country,
                            University = model.University,
                            College = model.College,
                            CreatedDate = DateTime.Now,
                            CreatedBy = usrid,
                            ModifiedDate = DateTime.Now,
                            ModifiedBy = usrid,
                        };
                        context.UserProfiles.Add(userprofile);
                        context.SaveChanges();
                        return RedirectToAction("Searchnote");
                    }
                    else
                    {
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
        [HttpGet]
        public ActionResult EditProfile()
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {
                    var profile = context.UserProfiles.Where(s => s.UserID == usrid).FirstOrDefault();
                    var name = context.Users.Where(s => s.ID == usrid).FirstOrDefault();
                    if (profile != null)
                    {
                        ViewBag.FirstName = name.FirstName;
                        ViewBag.LastName = name.LastName;
                        ViewBag.DOB = profile.DOB;
                        ViewBag.Gender = profile.Gender;
                        ViewBag.Path = profile.ProfilePicture;
                        ViewBag.SecondaryEmailAddress = profile.SecondaryEmailAddress;
                        ViewBag.PhoneNumberCountryCode = profile.PhoneNumberCountryCode;
                        ViewBag.PhoneNumber = profile.PhoneNumber;
                        ViewBag.AddressLine1 = profile.AddressLine1;
                        ViewBag.AddressLine2 = profile.AddressLine2;
                        ViewBag.City = profile.City;
                        ViewBag.State = profile.State;
                        ViewBag.ZipCode = profile.ZipCode;
                        ViewBag.Country = profile.Country;
                        ViewBag.College = profile.College;
                        ViewBag.University = profile.University;
                        return View();
                    }
                    else
                    {
                        return RedirectToAction("UserProfile");
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
        public ActionResult EditProfile(Userprofile model)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1))
            {
                try
                {

                    if (ModelState.IsValid)
                    {
                        //uploaded profile picture
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
                        //change detail in userprofile
                        var data = context.UserProfiles.FirstOrDefault(s => s.UserID == usrid);
                        if (data != null)
                        {
                            data.Gender = model.Gender;
                            data.DOB = model.DOB;
                            data.SecondaryEmailAddress = model.SecondaryEmailAddress;
                            data.PhoneNumberCountryCode = model.PhoneNumberCountryCode.ToString();
                            data.PhoneNumber = model.PhoneNumber;
                            data.ProfilePicture = path3;
                            data.AddressLine1 = model.AddressLine1;
                            data.AddressLine2 = model.AddressLine2;
                            data.City = model.City;
                            data.State = model.State;
                            data.ZipCode = model.ZipCode;
                            data.Country = model.Country;
                            data.University = model.University;
                            data.College = model.College;
                            data.ModifiedBy = usrid;
                            data.ModifiedDate = DateTime.Now;

                            context.SaveChanges();
                            return RedirectToAction("Searchnote");
                        }
                        ViewBag.Message = "please enter valid information.";
                        return View();
                    }
                    else
                    {
                        ViewBag.Message = "please enter valid information.";
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


        // Change Password
        [HttpGet]
        public ActionResult ChangePassword()
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1) || usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {

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
        public ActionResult ChangePassword(Changepassword model)
        {
            NoteSystem();
            if (usrid != 0 && usrrole.Equals(1) || usrid != 0 && usrrole.Equals(2) || usrid != 0 && usrrole.Equals(3))
            {
                try
                {
                    if (ModelState.IsValid)
                    {
                        string encrpassword = EnryptString(model.OldPassword);
                        //take old password from table and change it
                        var data = context.Users.Where(s => s.ID == usrid && s.Password == encrpassword).FirstOrDefault();
                        if (data != null)
                        {
                            string newpassword = EnryptString(model.NewPassword);
                            data.Password = newpassword;
                            context.SaveChanges();
                            return RedirectToAction("Logout");
                        }
                        else
                        {
                            ViewBag.message = String.Format("Please enter valid password.");
                            return View();
                        }
                    }
                    else
                    {
                        ViewBag.mmessage = String.Format("Please enter valid password.");
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


        //Contact Us
        [HttpGet]
        public ActionResult Contactus()
        {
            NoteSystem();
            try
            {
                //if already login 
                if (usrid != 0)
                {
                    var userlist = context.Users.Where(s => s.ID == usrid).FirstOrDefault();
                    ViewBag.email = userlist.EmailID;
                    ViewBag.name = userlist.FirstName + " " + userlist.LastName;
                    return View();
                }
                //without login
                else
                {
                    Session["usrid"] = "";
                    Session["usrrole"] = "";
                    return View();
                }
            }
            catch (Exception e)
            {
                return RedirectToAction("error", "User");
            }
        }
        [HttpPost]
        public ActionResult Contactus(ContactUs model)
        {
            NoteSystem();
            try
            {
                if (ModelState.IsValid)
                {                  
                    //if already login
                    if (usrid != 0)
                    {
                        string body = string.Empty;
                        string subject = model.Subject;
                        string receiver = context.Users.Where(x => x.RoleID.Equals(3)).Select(x => x.EmailID).FirstOrDefault();
                        using (StreamReader reader = new StreamReader(Server.MapPath("~/email/contactus.html")))
                        {
                            body = reader.ReadToEnd();
                        }
                        body = body.Replace("[Comment]", model.Comment);
                        body = body.Replace("[Name]", model.FirstName);
                        SendEmail(receiver, subject, body);
                        ViewBag.Success = "your comment sent to the admin.";

                        var userlist = context.Users.Where(x => x.RoleID.Equals(3)).FirstOrDefault();
                        ViewBag.email = userlist.EmailID;
                        ViewBag.name = userlist.FirstName + " " + userlist.LastName;
                        return View();
                    }
                    //without login
                    else
                    {
                       string body = string.Empty;
                        string subject = model.Subject;
                        string receiver = context.Users.Where(x => x.RoleID.Equals(3)).Select(x => x.EmailID).FirstOrDefault();
                        using (StreamReader reader = new StreamReader(Server.MapPath("~/email/contactus.html")))
                        {
                            body = reader.ReadToEnd();
                        }
                        body = body.Replace("[Comment]", model.Comment);
                        body = body.Replace("[Name]", model.FirstName);
                        SendEmail(receiver, subject, body);
                        ViewBag.Success = "your comment sent to the admin.";

                        return View();
                    }
                }
                else
                {
                    ViewBag.error = "Please enter valid detail";
                    return View();
                }
            }
            catch (Exception e)
            {
                return RedirectToAction("error", "User");
            }
        }


        //Faq
        public ActionResult Faqs()
        {
            NoteSystem();
            if (usrid == 0)
            {
                Session["usrid"] = "";
                Session["usrrole"] = "";
            }
            return View();
        }




    }
}