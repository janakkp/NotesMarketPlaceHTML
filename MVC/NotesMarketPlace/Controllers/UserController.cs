using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using NotesMarketPlace.Models;
using System.Net.Mail;
using System.IO;
using System.Net;
using System.Text;
using System.Data;
using System.Configuration;
using PagedList;
using System.Web.UI;

namespace NotesMarketPlace.Controllers
{
    public class UserController : Controller
    {
        NotesMarketPlaceEntities context = new NotesMarketPlaceEntities();

        // GET: User
        public ActionResult Home()
        {
            Session["ID"] = null;
            return View();
        }
        private void SendEmail(string receiver, string subject, string body)
        {
            using (MailMessage mailMessage = new MailMessage())
            {
                mailMessage.From = new MailAddress("note.mk.p@gmail.com", "janakpatel patel");
                mailMessage.Subject = subject;
                mailMessage.Body = body;
                mailMessage.IsBodyHtml = true;
                mailMessage.To.Add(new MailAddress(receiver));
                SmtpClient smtp = new SmtpClient();
                smtp.Host = "smtp.gmail.com";
                smtp.EnableSsl = true;
                System.Net.NetworkCredential NetworkCred = new System.Net.NetworkCredential();
                NetworkCred.UserName = "note.mk.p@gmail.com";
                NetworkCred.Password = "Nmplace1";
                smtp.UseDefaultCredentials = true;
                smtp.Credentials = NetworkCred;
                smtp.Port = 587;
                smtp.Send(mailMessage);
            }
        }
 
        //Mail SignUp 
        private void SignupSendEmail(string name, string receiver, string activationcode)


        {
            using (MailMessage mailMessage = new MailMessage())
            {
                mailMessage.From = new MailAddress("note.mk.p@gmail.com", "janakpatel patel");
                mailMessage.Subject = "Note Marketplace - Email Verification";
                string body = "Hello " + name + ",";
                body += "<br /><br />Thank you for signing up with us. Please click on below link to verify your email address and to do login.<br/><br/>";
                body += "<br /><a href = '" + string.Format("{0}://{1}/User/Activation/{2}", Request.Url.Scheme, Request.Url.Authority, activationcode) + "'>Click here to activate your account.</a>";
                body += "<br /><br />Regards,<br/>";
                body += "Notes Marketplace";
                mailMessage.Body = body; mailMessage.IsBodyHtml = true;
                mailMessage.To.Add(new MailAddress(receiver));
                SmtpClient smtp = new SmtpClient();

                smtp.Host = "smtp.gmail.com";
                smtp.EnableSsl = true;
                System.Net.NetworkCredential NetworkCred = new System.Net.NetworkCredential();
                NetworkCred.UserName = "note.mk.p@gmail.com";
                NetworkCred.Password = "Nmplace1";
                smtp.UseDefaultCredentials = true;
                smtp.Credentials = NetworkCred;
                smtp.Port = 587;
                smtp.Send(mailMessage);
            }
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
                    context.SaveChanges();
                    ViewBag.Message = "Your email verified successfully.";
                }
            }

            return View();
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

                if (context.Users.Any(x => x.EmailID == model.EmailID))
                {
                    ViewBag.error = String.Format("Already you have an account exists.");
                    return View();
                }
                else
                {
                    var ActivationCode = Guid.NewGuid().ToString();
                    SignupSendEmail(model.FirstName, model.EmailID, ActivationCode);


                    var userrole = new UserRole
                    {
                        Name = model.FirstName,
                        Description = "User",
                        CreatedDate = DateTime.Now,
                        ModifiedDate = DateTime.Now,
                        IsActive = true,
                    };
                    context.UserRoles.Add(userrole);
                    context.SaveChanges();


                    var usrid = context.UserRoles.OrderByDescending(u => u.ID).FirstOrDefault();
                    int id = Convert.ToInt32(usrid.ID);
                    var user = new User
                    {
                        ID = id,
                        RoleID = id,
                        FirstName = model.FirstName,
                        LastName = model.LastName,
                        EmailID = model.EmailID,
                        Password = model.Password,
                        IsEmailVerified = false,
                        CreatedDate = DateTime.Now,
                        CreatedBy = id,
                        ModifiedBy = id,
                        ModifiedDate = DateTime.Now,
                        ActivationCode = ActivationCode,
                        IsActive = true,

                    };
                    context.Users.Add(user);
                    context.SaveChanges();

                    Session["FirstName"] = model.FirstName.ToString();
                    return RedirectToAction("emailverification");
                }
            }
            return View();
        }


        //Email Verification
        [HttpGet]
        public ActionResult emailverification()
        {
            var name = Session["FirstName"].ToString();
            ViewBag.name = name;
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
            if (ModelState.IsValid)
            {

                var obj = context.Users.Where(a => a.EmailID.Equals(model.EmailID) && a.Password.Equals(model.Password)).FirstOrDefault();

                if (obj != null)
                {
                    var usertype = context.UserRoles.Where(b => b.ID == obj.ID).FirstOrDefault();
                    if (obj.IsEmailVerified == true && usertype.Description == "Admin")
                    {
                        Session["ID"] = obj.ID.ToString();
                        Session["EmailID"] = obj.EmailID.ToString();
                        return RedirectToAction("Dashboard", "Admin");
                    }
                    else if (obj.IsEmailVerified == true && usertype.Description == "User")
                    {
                        var usr = context.UserProfiles.Where(b => b.UserID == usertype.ID).FirstOrDefault();
                        if (usr == null)
                        {
                            Session["ID"] = obj.ID.ToString();
                            Session["EmailID"] = obj.EmailID.ToString();
                            Session["Userprofile"] = null;
                            return RedirectToAction("UserProfile");
                        }
                        else
                        {
                            Session["ID"] = obj.ID.ToString();
                            Session["EmailID"] = obj.EmailID.ToString();
                            Session["Userprofile"] = usr.ProfilePicture;
                            return RedirectToAction("Dashboard");
                        }
                    }
                    else
                    {
                        Session["FirstName"] = usertype.Name.ToString();
                        return RedirectToAction("emailverification");
                    }
                }
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
        public class RandomGenerator
        {
            private readonly Random _random = new Random();
            public int RandomNumber(int min, int max)
            {
                return _random.Next(min, max);
            }
            public string RandomString(int size, bool lowerCase = false)
            {
                var builder = new StringBuilder(size);
                char offset = lowerCase ? 'a' : 'A';
                const int lettersOffset = 26; // A...Z or a..z: length = 26  
                for (var i = 0; i < size; i++)
                {
                    var @char = (char)_random.Next(offset, offset + lettersOffset);
                    builder.Append(@char);
                }
                return lowerCase ? builder.ToString().ToLower() : builder.ToString();
            }
            public string RandomPassword()
            {
                var passwordBuilder = new StringBuilder();
                passwordBuilder.Append(RandomString(4, true));
                passwordBuilder.Append(RandomNumber(1000, 9999));
                passwordBuilder.Append(RandomString(2));
                return passwordBuilder.ToString();
            }
        }
        [HttpGet]
        public ActionResult Forgotpassword()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Forgotpassword(ForgotPassword model)
        {
            var generator = new RandomGenerator();
            var randomString = generator.RandomString(10);
            var data = context.Users.Where(x => x.EmailID == model.EmailID).FirstOrDefault();
            if (data != null)
            {
                data.Password = randomString;
                context.SaveChanges();
                string body = string.Empty;
                using (StreamReader reader = new StreamReader(Server.MapPath("~/email/Forgotpassword.htm")))
                {
                    body = reader.ReadToEnd();
                }
                body = body.Replace("[password]", randomString);
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
            int useid1 = Convert.ToInt32(Session["ID"]);
            List<ReferenceData> referencelist = context.ReferenceDatas.ToList();
            List<SellerNote> sellernotelist = context.SellerNotes.ToList();
            List<NoteCategory> notecategory = context.NoteCategories.ToList();
            List<Paid> paidlist = context.Paids.ToList();
            ViewBag.CurrentSort1 = sortOrder1;
            ViewBag.title1 = String.IsNullOrEmpty(sortOrder1) ? "title_desc" : "";
            ViewBag.category1 = sortOrder1 == "category" ? "category_desc" : "category";
            ViewBag.selltype1 = sortOrder1 == "selltype" ? "selltype_desc" : "selltype";
            ViewBag.date1 = sortOrder1 == "date" ? "date_desc" : "date";
            ViewBag.price1 = sortOrder1 == "price" ? "price_desc" : "price";
            if (searchString1 != null)
            {
                page1 = 1;
            }
            else
            {
                searchString1 = currentFilter1;
            }

            ViewBag.CurrentFilter1 = searchString1;
            var process1 = from s in sellernotelist.Where(x => x.SellerID.Equals(useid1) && x.Status == 9)
                           join r in referencelist on s.Status equals r.ID into table1
                           from r in table1.DefaultIfEmpty()
                           join c in notecategory on s.Category equals c.ID into table2
                           from c in table2.DefaultIfEmpty()
                           join p in paidlist on s.IsPaid equals p.ID into table3
                           from p in table3.DefaultIfEmpty()
                           select new Dashboard { sellernotelist = s, referencelist = r, notecategory = c, paidlist = p };

            if (!String.IsNullOrEmpty(searchString1))
            {
                process1 = process1.Where(s => s.sellernotelist.Title.ToLower().Contains(searchString1.ToLower()));
            }
            switch (sortOrder1)
            {
                case "title_desc":
                    process1 = process1.OrderByDescending(s => s.sellernotelist.Title);
                    break;
                case "category":
                    process1 = process1.OrderBy(s => s.notecategory.Name);
                    break;
                case "category_desc":
                    process1 = process1.OrderByDescending(s => s.notecategory.Name);
                    break;
                case "selltype":
                    process1 = process1.OrderBy(s => s.paidlist.PaidType);
                    break;
                case "selltype_desc":
                    process1 = process1.OrderByDescending(s => s.paidlist.PaidType);
                    break;
                case "price":
                    process1 = process1.OrderBy(s => s.sellernotelist.SellingPrice);
                    break;
                case "price_desc":
                    process1 = process1.OrderByDescending(s => s.sellernotelist.SellingPrice);
                    break;
                case "date":
                    process1 = process1.OrderBy(s => s.sellernotelist.CreatedDate);
                    break;
                case "date_desc":
                    process1 = process1.OrderByDescending(s => s.sellernotelist.CreatedDate);
                    break;
                default:  // Name ascending 
                    process1 = process1.OrderBy(s => s.sellernotelist.Title);
                    break;
            }
            int pageSize1 = 5;
            int pageNumber1 = (page1 ?? 1);
            return PartialView(process1.ToPagedList(pageNumber1, pageSize1));
        }
        [ChildActionOnly]
        public ActionResult Inprocessnote(string sortOrder, string currentFilter, string searchString, int? page)
        {
            int useid1 = Convert.ToInt32(Session["ID"]);
            List<ReferenceData> referencelist = context.ReferenceDatas.ToList();
            List<SellerNote> sellernotelist = context.SellerNotes.ToList();
            List<NoteCategory> notecategory = context.NoteCategories.ToList();
            List<Paid> paidlist = context.Paids.ToList();
            ViewBag.CurrentSort = sortOrder;
            ViewBag.title = String.IsNullOrEmpty(sortOrder) ? "title_desc" : "";
            ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
            ViewBag.status = sortOrder == "status" ? "status_desc" : "status";
            ViewBag.date = sortOrder == "date" ? "date_desc" : "date";
            if (searchString != null)
            {
                page = 1;
            }
            else
            {
                searchString = currentFilter;
            }

            ViewBag.CurrentFilter = searchString;
            var process = from s in sellernotelist.Where(x => x.SellerID.Equals(useid1) && x.Status != 9)
                           join r in referencelist on s.Status equals r.ID into table1
                           from r in table1.DefaultIfEmpty()
                           join c in notecategory on s.Category equals c.ID into table2
                           from c in table2.DefaultIfEmpty()
                           join p in paidlist on s.IsPaid equals p.ID into table3
                           from p in table3.DefaultIfEmpty()
                           select new Dashboard { sellernotelist = s, referencelist = r, notecategory = c, paidlist = p };
            if (!String.IsNullOrEmpty(searchString))
            {
                process = process.Where(s => s.sellernotelist.Title.ToLower().Contains(searchString.ToLower()));
            }
            switch (sortOrder)
            {
                case "title_desc":
                    process = process.OrderByDescending(s => s.sellernotelist.Title);
                    break;
                case "category":
                    process = process.OrderBy(s => s.notecategory.Name);
                    break;
                case "category_desc":
                    process = process.OrderByDescending(s => s.notecategory.Name);
                    break;
                case "status":
                    process = process.OrderBy(s => s.referencelist.DataValue);
                    break;
                case "status_desc":
                    process = process.OrderByDescending(s => s.referencelist.DataValue);
                    break;
                case "date":
                    process = process.OrderBy(s => s.sellernotelist.CreatedDate);
                    break;
                case "date_desc":
                    process = process.OrderByDescending(s => s.sellernotelist.CreatedDate);
                    break;
                default:  // Name ascending 
                    process = process.OrderBy(s => s.sellernotelist.Title);
                    break;
            }
            int pageSize = 5;
            int pageNumber = (page ?? 1);
            return PartialView(process.ToPagedList(pageNumber, pageSize));
        }
        public ActionResult Dashboard()
        {
            string a = Session["ID"].ToString();


            int useid1 = Convert.ToInt32(Session["ID"]);
            //Dashboard main box heading
            NotesMarketPlaceEntities context = new NotesMarketPlaceEntities();
            ViewBag.downloadno = context.Downloads.Where(x => x.Downloader == useid1 && x.IsSellerHasAllowedDownload==true).Count();
            ViewBag.rejectno = context.SellerNotes.Where(x => x.Status == 10 && x.SellerID== useid1).Count();
            ViewBag.Buyerreuest = context.Downloads.Where(x => x.Seller == useid1 && x.IsSellerHasAllowedDownload == false).Count();
            ViewBag.notesold = context.Downloads.Where(x => x.Seller == useid1 && x.IsSellerHasAllowedDownload == true).Count();
            var n = context.Downloads.Where(x => x.Seller == useid1 && x.IsSellerHasAllowedDownload ==true).Select(u => u.PurchasedPrice).ToList();
            ViewBag.Total = n.Sum(x => x.Value);

            List<ReferenceData> referencelist = context.ReferenceDatas.ToList();
            List<SellerNote> sellernotelist = context.SellerNotes.ToList();
            List<NoteCategory> notecategory = context.NoteCategories.ToList();
            List<Paid> paidlist = context.Paids.ToList();
            return View();
        }
        public ActionResult Delete(int id)
        {
            if (Session["ID"] != null)
            {
                var data = context.SellerNotesAttachements.Where(x => x.NoteID == id).First();
                var data1 = context.SellerNotes.Where(x => x.ID == id).First();
                if (data != null | data1 != null)
                {

                    context.SellerNotesAttachements.Remove(data);
                    context.SaveChanges();
                    context.SellerNotes.Remove(data1);
                    context.SaveChanges();
                    return RedirectToAction("Dashboard");
                }
                else
                {
                    return RedirectToAction("Dashboard");
                }
            }
            else
            {
                return RedirectToAction("Home");
            }
        }


        [HttpGet]
        // Add/Edit Note Page
        public ActionResult Addnote()
        {
            int sellerid = Convert.ToInt32(Session["ID"]);
            var category = context.NoteCategories.ToList();
            SelectList list = new SelectList(category, "ID", "Name");
            ViewBag.category = list;
            var type = context.NoteTypes.ToList();
            SelectList list1 = new SelectList(type, "ID", "Name");
            ViewBag.type = list1;
            var country = context.Countries.ToList();
            SelectList list2 = new SelectList(country, "ID", "Name");
            ViewBag.country = list2;

            return View();

        }
        [HttpPost]
        public ActionResult Addnote(Addnote model)
        {
            if (ModelState.IsValid)
            {
                int sellerid = Convert.ToInt32(Session["ID"]);
                //For the DropDown
                var category = context.NoteCategories.ToList();
                SelectList list = new SelectList(category, "ID", "NAME");
                ViewBag.category = list;
                var type = context.NoteTypes.ToList();
                SelectList list1 = new SelectList(type, "ID", "NAME");
                ViewBag.type = list1;
                var country = context.Countries.ToList();
                SelectList list2 = new SelectList(country, "ID", "NAME");
                ViewBag.country = list2;

                //Status save or published
                int statusid = Convert.ToInt32(model.Button);
                //For the Uploaded Files
                var path2 = "";
                var path3 = "";
                if (model.DisplayPictureFile != null)
                {
                    var fileName3 = Path.GetFileName(model.DisplayPictureFile.FileName);
                    path3 = Path.Combine(Server.MapPath("~/UserFile/DisplayPictureName"), fileName3);
                    model.DisplayPictureFile.SaveAs(path3);
                    path3 = fileName3;
                }
                else
                {
                    path3 = "";
                }
                if (model.NotesPreviewFile != null)
                {
                    var fileName2 = Path.GetFileName(model.NotesPreviewFile.FileName);
                    path2 = Path.Combine(Server.MapPath("~/UserFile/NotesPreview"), fileName2);
                    model.NotesPreviewFile.SaveAs(path2);
                    path2 = fileName2;
                }
                else
                {
                    path2 = "";
                }
                SellerNote sellernote = new SellerNote();
                sellernote.SellerID = sellerid;
                sellernote.Status = statusid;
                sellernote.Title = model.Title;
                sellernote.Category = model.Category;
                sellernote.PublishedDate = DateTime.Now;
                sellernote.NoteType = model.Type;
                sellernote.NumberOfPages = model.NumberOfPages;
                sellernote.Description = model.Description;
                sellernote.DisplayPicture = path3;
                sellernote.NotesPreview = path2;
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
                sellernote.CreatedBy = sellerid;
                sellernote.ModifiedBy = sellerid;
                sellernote.ModifiedDate = DateTime.Now;

                context.SellerNotes.Add(sellernote);
                context.SaveChanges();

                int noteid = context.SellerNotes.OrderByDescending(u => u.ID).Select(u => u.ID).FirstOrDefault();
                //For SellerNoteAttachment
                var fileName = Path.GetFileName(model.FileName.FileName);
                var path = Path.Combine(Server.MapPath("~/UserFile/FileName"), fileName);
                model.FileName.SaveAs(path);
                path = "~/UserFile/FileName" + "/" + fileName;
                SellerNotesAttachement att = new SellerNotesAttachement();
                att.NoteID = noteid;
                att.FileName = fileName;
                att.FilePath = path;
                att.CreatedBy = sellerid;
                att.CreatedDate = DateTime.Now;
                att.ModifiedBy = sellerid;
                att.ModifiedDate = DateTime.Now;
                att.IsActive = true;
                context.SellerNotesAttachements.Add(att);

                if (statusid == 7)
                {
                    var sellernamef = context.Users.Where(t => t.ID == sellerid).Select(t => t.FirstName).FirstOrDefault();
                    var sellernamel = context.Users.Where(t => t.ID == sellerid).Select(t => t.LastName).FirstOrDefault();
                    string body = string.Empty;
                    string subject = sellernamef + "" + sellernamel + " sent his note for review";
                    string Admin = "janakpatel00002@gmail.com";
                    using (StreamReader reader = new StreamReader(Server.MapPath("~/email/addnote.html")))
                    {
                        body = reader.ReadToEnd();
                    }
                    body = body.Replace("[Sellerf]", sellernamef);
                    body = body.Replace("[Sellerl]", sellernamel);
                    body = body.Replace("[NoteTitle]", model.Title);
                    SendEmail(Admin, subject, body);
                    context.SaveChanges();
                    TempData["Addnote"] = "Note added for review successfully.";
                    return RedirectToAction("Dashboard");
                }
                else
                {
                    context.SaveChanges();
                    TempData["Addnote"] = "Note save as draft successfully.";
                    return RedirectToAction("Dashboard");
                }


            }
            else
            {
                int sellerid = Convert.ToInt32(Session["ID"]);
                var category = context.NoteCategories.ToList();
                SelectList list = new SelectList(category, "ID", "Name");
                ViewBag.category = list;
                var type = context.NoteTypes.ToList();
                SelectList list1 = new SelectList(type, "ID", "Name");
                ViewBag.type = list1;
                var country = context.Countries.ToList();
                SelectList list2 = new SelectList(country, "ID", "Name");
                ViewBag.country = list2;
                TempData["validinfo"] = "Please enter valid information.";
                return View();
            }

        }
        [HttpGet]
        public ActionResult Editnote(int? noteid)
        {
            var sessionid = Session["ID"];
            var id = Convert.ToInt32(sessionid);
            var category = context.NoteCategories.ToList();
            SelectList list = new SelectList(category, "ID", "Name");
            ViewBag.category = list;
            var type = context.NoteTypes.ToList();
            SelectList list1 = new SelectList(type, "ID", "Name");
            ViewBag.type = list1;
            var country = context.Countries.ToList();
            SelectList list2 = new SelectList(country, "ID", "Name");
            ViewBag.country = list2;

            var note = context.SellerNotes.FirstOrDefault(s => s.SellerID == id && s.ID == noteid);
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
        [HttpPost]
        public ActionResult Editnote(Editnote model)
        {
            if (ModelState.IsValid)
            {
                var sellerid = Convert.ToInt32(Session["ID"]);
                int statusid = Convert.ToInt32(model.Button);
                int note = Convert.ToInt32(model.noteid);

                var sellernote = context.SellerNotes.Where(s => s.ID == note).FirstOrDefault();

                //For the Uploaded Files
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

                if (sellernote != null)
                {
                    sellernote.Status = statusid;
                    sellernote.Title = model.Title;
                    if (model.Category != null)
                    {
                        sellernote.Category = Convert.ToInt32(model.Category);
                    }
                    else
                    {
                        sellernote.Category = sellernote.Category;
                    }
                    sellernote.PublishedDate = DateTime.Now;
                    if (model.Type != null)
                    {
                        sellernote.NoteType = model.Type;
                    }
                    else
                    {
                        sellernote.NoteType = sellernote.NoteType;
                    }
                    sellernote.NumberOfPages = model.NumberOfPages;
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
                    sellernote.ModifiedBy = sellerid;
                    sellernote.ModifiedDate = DateTime.Now;
                    context.SaveChanges();

                }

                var sellerattach = context.SellerNotesAttachements.Where(s => s.NoteID == note).FirstOrDefault();
                var filename = "";
                var filepath = "";
                //For SellerNoteAttachment
                if (model.FileName != null)
                {
                    filename = Path.GetFileName(model.FileName.FileName);
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
                att.ModifiedBy = sellerid;
                att.ModifiedDate = DateTime.Now;
                context.SaveChanges();


                if (statusid == 7)
                {
                    var user = context.Users.Where(t => t.ID == sellerid).FirstOrDefault();
                    var sellernamef = user.FirstName;
                    var sellernamel = user.LastName;
                    string body = string.Empty;
                    string subject = sellernamef + "" + sellernamel + " sent his note for review";
                    string Admin = "janakpatel00002@gmail.com";
                    using (StreamReader reader = new StreamReader(Server.MapPath("~/email/addnote.html")))
                    {
                        body = reader.ReadToEnd();
                    }
                    body = body.Replace("[Sellerf]", sellernamef);
                    body = body.Replace("[Sellerl]", sellernamel);
                    body = body.Replace("[NoteTitle]", model.Title);
                    SendEmail(Admin, subject, body);
                    TempData["Addnote"] = "Note added for review successfully.";
                    return RedirectToAction("Dashboard");
                }
                else
                {
                    TempData["Addnote"] = "Note save as draft successfully.";
                    return RedirectToAction("Dashboard");
                }
            }
            else
            {
                int sellerid = Convert.ToInt32(Session["ID"]);
                //For the DropDown
                var category = context.NoteCategories.ToList();
                SelectList list = new SelectList(category, "ID", "NAME");
                ViewBag.category = list;
                var type = context.NoteTypes.ToList();
                SelectList list1 = new SelectList(type, "ID", "NAME");
                ViewBag.type = list1;
                var country = context.Countries.ToList();
                SelectList list2 = new SelectList(country, "ID", "NAME");
                ViewBag.country = list2;

                ViewBag.error = "Enter valid detail";
                return View();
            }
        }


        //searchnote
        [ChildActionOnly]
        public ActionResult reportinsearch(int? noteid) {
            ViewBag.reportissue = context.SellerNotesReportedIssues.Where(s => s.NoteID == noteid).Count();
            return PartialView();
        }
        [ChildActionOnly]
        public ActionResult ratinginsearch(int? noteid)
        {
            ViewBag.count = context.SellerNotesReviews.Where(s => s.NoteID == noteid).Count();
            var data = context.SellerNotesReviews.Where(s => s.NoteID == noteid).Select(s => s.Ratings).ToList();
            if (ViewBag.count == 0)
            {
                var average = 0;
            }
            else
            {
                var average = data.Average();
                ViewBag.average = Convert.ToInt32(average);
            }

            return PartialView();
        }
        public ActionResult Searchnote(string Searching1, int? category1, string university1, string course1, int? type1, int? country1, int? page)
        {
            ViewBag.Searching1 = Searching1;
            ViewBag.category1 = category1;
            ViewBag.university1 = university1;
            ViewBag.course1 = course1;
            ViewBag.type1 = type1;
            ViewBag.country = country1;

            if (Session["ID"] == null)
            {
                ViewBag.sellerid = null;
            }
            else
            {
                ViewBag.sellerid = Session["ID"];
            }
            int sellerid = Convert.ToInt32(Session["ID"]);
            List<SellerNote> sellernotelist = context.SellerNotes.ToList();
            var notes = from d in sellernotelist.Where(u => u.IsActive == true && u.Status == 9 && u.SellerID != sellerid).ToList()
                        select new Searchnote { sellernotelist = d };
           
            //Dropdowns
            var category = context.NoteCategories.ToList();
            SelectList list = new SelectList(category, "ID", "NAME");
            ViewBag.category = list;

            var type = context.NoteTypes.ToList();
            SelectList list1 = new SelectList(type, "ID", "NAME");
            ViewBag.type = list1;

            var university = context.SellerNotes.Where(x => x.UniversityName != null && x.SellerID != sellerid).ToList().GroupBy(x => x.UniversityName).Select(group => group.First());
            SelectList universitylist = new SelectList(university, "UniversityName", "UniversityName");
            ViewBag.university = universitylist;

            var course = context.SellerNotes.Where(x => x.Course != null && x.SellerID != sellerid).ToList().GroupBy(x => x.Course).Select(group => group.First());
            SelectList courselist = new SelectList(course, "Course", "Course");
            ViewBag.course = courselist;

            var country = context.Countries.ToList();
            SelectList countrylist = new SelectList(country, "ID", "NAME");
            ViewBag.country = countrylist;

            //Condition for books
            if (!String.IsNullOrEmpty(Searching1))
            {
                notes = notes.Where(m => m.sellernotelist.Title.ToLower().Contains(Searching1.ToLower())).ToList();
            }
            if (!String.IsNullOrEmpty(university1))
            {
                notes = notes.Where(m => m.sellernotelist.UniversityName == university1).ToList();
            }
            if (!String.IsNullOrEmpty(type1.ToString()))
            {
                notes = notes.Where(m => m.sellernotelist.NoteType.Equals(type1)).ToList();
            }
            if (!String.IsNullOrEmpty(country1.ToString()))
            {
                notes = notes.Where(m => m.sellernotelist.Country.Equals(country1)).ToList();
            }
            if (!String.IsNullOrEmpty(course1))
            {
                notes = notes.Where(m => m.sellernotelist.Course == course1).ToList();
            }
            if (!String.IsNullOrEmpty(category1.ToString()))
            {
                notes = notes.Where(m => m.sellernotelist.Category.Equals(category1)).ToList();
            }
            ViewBag.notes = notes;
            ViewBag.totalnotes = notes.Count();
            //PageNumber
            int pageSize = 9;
            int pageNumber = (page ?? 1);
            return View(notes.ToPagedList(pageNumber, pageSize));
        }


        //NoteDetail
        public ActionResult Notedetail(int? id)
        {
            if (Session["ID"] == null)
            {
                ViewBag.sellerid = null;
            }
            else
            {
                ViewBag.sellerid = Session["ID"];
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

            ViewBag.noteid = id;
            var sellerid = context.SellerNotes.Where(t => t.ID == id).Select(t => t.SellerID).FirstOrDefault();
            ViewBag.sellername = context.Users.Where(t => t.ID == sellerid).Select(t => t.FirstName).FirstOrDefault();
            ViewBag.sellerlastname = context.Users.Where(t => t.ID == sellerid).Select(t => t.LastName).FirstOrDefault();

            ViewBag.count = context.SellerNotesReviews.Where(s => s.NoteID == id).Count();
            var data = context.SellerNotesReviews.Where(s => s.NoteID == id).Select(s => s.Ratings).ToList();
            if (ViewBag.count == 0)
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
        public ActionResult mailnotedetail()
        {
            var noteid = Convert.ToInt32(RouteData.Values["id"]);
            string a = Session["ID"].ToString();

            var note = context.SellerNotes.Where(x => x.ID == noteid).FirstOrDefault();
            var attach = context.SellerNotesAttachements.Where(x => x.NoteID == noteid).FirstOrDefault();
            int usrid = Convert.ToInt32(a);
            var alreadyrequest = context.Downloads.Where(x => x.NoteID == noteid && x.Downloader == usrid).FirstOrDefault();
            if (alreadyrequest != null)
            {
                TempData["notedetail"] = "You already request for the note.";
                return RedirectToAction("Notedetail", new { id = noteid });
            }
            else {
                var download = new Download
                {
                    NoteID = Convert.ToInt32(noteid),
                    Seller = Convert.ToInt32(note.SellerID),
                    Downloader = Convert.ToInt32(usrid),
                    AttachmentPath = attach.FilePath,
                    IsAttachmentDownloaded = false,
                    IsSellerHasAllowedDownload = false,
                    IsPaid = note.IsPaid,
                    PurchasedPrice = note.SellingPrice,
                    NoteTitle = note.Title,
                    AttachmentDownloadedDate = DateTime.Now,
                    NoteCategory = context.NoteCategories.Where(x => x.ID == note.Category).Select(x => x.Name).FirstOrDefault(),
                    ModifiedDate = DateTime.Now,
                    CreatedBy = usrid,
                    CreatedDate = DateTime.Now,
                    ModifiedBy = usrid,
                };

                context.Downloads.Add(download);
                context.SaveChanges();
                var sellerid = context.SellerNotes.Where(t => t.ID == noteid).Select(t => t.SellerID).FirstOrDefault();
                var sellername = context.Users.Where(t => t.ID == sellerid).Select(t => t.FirstName).FirstOrDefault();
                var username1 = context.Users.Where(t => t.ID == usrid).Select(t => t.FirstName).FirstOrDefault();
                var username2 = context.Users.Where(t => t.ID == usrid).Select(t => t.LastName).FirstOrDefault();
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
        public ActionResult Notedetaildownload(string path, int id)
        {
            var note = context.SellerNotes.Where(x => x.ID == id).FirstOrDefault();
            var attach = context.SellerNotesAttachements.Where(x => x.NoteID == id).FirstOrDefault();
            int usrid = Convert.ToInt32(Session["ID"]);

            var download = new Download
            {
                NoteID = Convert.ToInt32(id),
                Seller = Convert.ToInt32(note.SellerID),
                Downloader = Convert.ToInt32(usrid),
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

            string fullName = "C:\\Users\\Administrator\\source\\repos\\NotesMarketPlace\\UserFile\\FileName\\" + path;
            byte[] fileBytes = GetFile(fullName);
            return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, path);
        }


        //BuyerRequest
        public ViewResult BuyerRequest(string sortOrder, string currentFilter, string searchString, int? page)
        {

            ViewBag.CurrentSort = sortOrder;
            ViewBag.title = String.IsNullOrEmpty(sortOrder) ? "title_desc" : "";
            ViewBag.email = sortOrder == "email" ? "email_desc" : "email";
            ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
            ViewBag.selltype = sortOrder == "selltype" ? "selltype_desc" : "selltype";
            ViewBag.price = sortOrder == "price" ? "price_desc" : "price";
            ViewBag.date = sortOrder == "date" ? "date_desc" : "date";
            if (searchString != null)
            {
                page = 1;
            }
            else
            {
                searchString = currentFilter;
            }

            ViewBag.CurrentFilter = searchString;

            int usrid = Convert.ToInt32(Session["ID"]);
            List<User> userlist = context.Users.ToList();
            List<Download> downloadnotelist = context.Downloads.ToList();
            List<Paid> paidlist = context.Paids.ToList();

            var process1 = from d in downloadnotelist.Where(x => x.Seller.Equals(usrid) && x.IsSellerHasAllowedDownload == false)
                           join u in userlist on d.Downloader equals u.ID into table1
                           from u in table1.DefaultIfEmpty()
                           join p in paidlist on d.IsPaid equals p.ID into table2
                           from p in table2.DefaultIfEmpty()
                           select new Buyerrequest { downloadnotelist = d, userlist = u, paidlist = p };

            if (!String.IsNullOrEmpty(searchString))
            {
                process1 = process1.Where(s => s.downloadnotelist.NoteTitle.ToLower().Contains(searchString.ToLower()));
            }
            switch (sortOrder)
            {
                case "title_desc":
                    process1 = process1.OrderByDescending(s => s.downloadnotelist.NoteTitle);
                    break;
                case "email":
                    process1 = process1.OrderBy(s => s.userlist.EmailID);
                    break;
                case "email_desc":
                    process1 = process1.OrderByDescending(s => s.userlist.EmailID);
                    break;
                case "category":
                    process1 = process1.OrderBy(s => s.downloadnotelist.NoteCategory);
                    break;
                case "category_desc":
                    process1 = process1.OrderByDescending(s => s.downloadnotelist.NoteCategory);
                    break;
                case "selltype":
                    process1 = process1.OrderBy(s => s.paidlist.PaidType);
                    break;
                case "selltype_desc":
                    process1 = process1.OrderByDescending(s => s.paidlist.PaidType);
                    break;
                case "price":
                    process1 = process1.OrderBy(s => s.downloadnotelist.PurchasedPrice);
                    break;
                case "price_desc":
                    process1 = process1.OrderByDescending(s => s.downloadnotelist.PurchasedPrice);
                    break;
                case "date":
                    process1 = process1.OrderBy(s => s.downloadnotelist.AttachmentDownloadedDate);
                    break;
                case "date_desc":
                    process1 = process1.OrderByDescending(s => s.downloadnotelist.AttachmentDownloadedDate);
                    break;
                default:  // Name ascending 
                    process1 = process1.OrderBy(s => s.downloadnotelist.NoteTitle);
                    break;
            }

            int pageSize = 10;
            int pageNumber = (page ?? 1);
            return View(process1.ToPagedList(pageNumber, pageSize));

        }
        public ActionResult allowdownload()
        {
            int usrid = Convert.ToInt32(Session["ID"]);
            if (RouteData.Values["id"] != null)
            {
                int id = Convert.ToInt32(RouteData.Values["id"]);
                var data = context.Downloads.Where(x => x.NoteID == id && x.Seller == usrid && x.IsSellerHasAllowedDownload == false).First();
                if (data != null)
                {
                    data.IsSellerHasAllowedDownload = true;
                    data.AttachmentDownloadedDate = DateTime.Now;
                    context.SaveChanges();
                }

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


        //SoldNotes
        public ActionResult SoldNote(string sortOrder, string currentFilter, string searchString, int? page)
        {
            string a = Session["ID"].ToString();
            int usrid = Convert.ToInt32(a);
            ViewBag.CurrentSort = sortOrder;
            ViewBag.title = String.IsNullOrEmpty(sortOrder) ? "title_desc" : "";
            ViewBag.email = sortOrder == "email" ? "email_desc" : "email";
            ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
            ViewBag.selltype = sortOrder == "selltype" ? "selltype_desc" : "selltype";
            ViewBag.price = sortOrder == "price" ? "price_desc" : "price";
            ViewBag.date = sortOrder == "date" ? "date_desc" : "date";
            if (searchString != null)
            {
                page = 1;
            }
            else
            {
                searchString = currentFilter;
            }

            ViewBag.CurrentFilter = searchString;

            List<User> userlist = context.Users.ToList();
            List<Download> downloadnotelist = context.Downloads.ToList();
            List<Paid> paidlist = context.Paids.ToList();
            List<SellerNotesAttachement> attachmentlist = context.SellerNotesAttachements.ToList();

            var process1 = from d in downloadnotelist.Where(x => x.Seller.Equals(usrid) && x.IsSellerHasAllowedDownload == true)
                           join u in userlist on d.Downloader equals u.ID into table1
                           from u in table1.DefaultIfEmpty()
                           join p in paidlist on d.IsPaid equals p.ID into table2
                           from p in table2.DefaultIfEmpty()
                           join t in attachmentlist on d.NoteID equals t.NoteID into table3
                           from t in table3.DefaultIfEmpty()
                           select new Soldnote { downloadnotelist = d, userlist = u, paidlist = p, attachmentlist = t };

            if (!String.IsNullOrEmpty(searchString))
            {
                process1 = process1.Where(s => s.downloadnotelist.NoteTitle.ToLower().Contains(searchString.ToLower()));
            }
            switch (sortOrder)
            {
                case "title_desc":
                    process1 = process1.OrderByDescending(s => s.downloadnotelist.NoteTitle);
                    break;
                case "email":
                    process1 = process1.OrderBy(s => s.userlist.EmailID);
                    break;
                case "email_desc":
                    process1 = process1.OrderByDescending(s => s.userlist.EmailID);
                    break;
                case "category":
                    process1 = process1.OrderBy(s => s.downloadnotelist.NoteCategory);
                    break;
                case "category_desc":
                    process1 = process1.OrderByDescending(s => s.downloadnotelist.NoteCategory);
                    break;
                case "selltype":
                    process1 = process1.OrderBy(s => s.paidlist.PaidType);
                    break;
                case "selltype_desc":
                    process1 = process1.OrderByDescending(s => s.paidlist.PaidType);
                    break;
                case "price":
                    process1 = process1.OrderBy(s => s.downloadnotelist.PurchasedPrice);
                    break;
                case "price_desc":
                    process1 = process1.OrderByDescending(s => s.downloadnotelist.PurchasedPrice);
                    break;
                case "date":
                    process1 = process1.OrderBy(s => s.downloadnotelist.AttachmentDownloadedDate);
                    break;
                case "date_desc":
                    process1 = process1.OrderByDescending(s => s.downloadnotelist.AttachmentDownloadedDate);
                    break;
                default:  // Name ascending 
                    process1 = process1.OrderBy(s => s.downloadnotelist.NoteTitle);
                    break;
            }

            int pageSize = 8;
            int pageNumber = (page ?? 1);
            return View(process1.ToPagedList(pageNumber, pageSize));
        }


        //Rejected Notes
        public ActionResult RejectedNote(string sortOrder, string currentFilter, string searchString, int? page)
        {
            string a = Session["ID"].ToString();
            int usrid = Convert.ToInt32(a);
            ViewBag.CurrentSort = sortOrder;
            ViewBag.title = String.IsNullOrEmpty(sortOrder) ? "title_desc" : "";
            ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
            ViewBag.remark = sortOrder == "remark" ? "remark_desc" : "remark";
            if (searchString != null)
            {
                page = 1;
            }
            else
            {
                searchString = currentFilter;
            }

            ViewBag.CurrentFilter = searchString;
            List<SellerNote> sellernotelist = context.SellerNotes.ToList();
            List<NoteCategory> categorylist = context.NoteCategories.ToList();
            List<SellerNotesAttachement> attachmentlist = context.SellerNotesAttachements.ToList();
            var process1 = from d in sellernotelist.Where(x => x.SellerID.Equals(usrid) && x.Status == 10)
                           join c in categorylist on d.Category equals c.ID into table1
                           from c in table1.DefaultIfEmpty()
                           join t in attachmentlist on d.ID equals t.NoteID into table2
                           from t in table2.DefaultIfEmpty()
                           select new Rejectednote { sellernotelist = d, categorylist = c, attachmentlist = t };

            if (!String.IsNullOrEmpty(searchString))
            {
                process1 = process1.Where(s => s.sellernotelist.Title.ToLower().Contains(searchString.ToLower()));
            }
            switch (sortOrder)
            {
                case "title_desc":
                    process1 = process1.OrderByDescending(s => s.sellernotelist.Title);
                    break;
                case "category":
                    process1 = process1.OrderBy(s => s.categorylist.Name);
                    break;
                case "category_desc":
                    process1 = process1.OrderByDescending(s => s.categorylist.Name);
                    break;
                case "remark":
                    process1 = process1.OrderBy(s => s.sellernotelist.AdminRemark);
                    break;
                case "date_desc":
                    process1 = process1.OrderByDescending(s => s.sellernotelist.AdminRemark);
                    break;
                default:  // Name ascending 
                    process1 = process1.OrderBy(s => s.sellernotelist.Title);
                    break;
            }
            int pageSize = 8;
            int pageNumber = (page ?? 1);
            return View(process1.ToPagedList(pageNumber, pageSize));
        }
        public ActionResult clonenote(int? id) {
            int usrid = Convert.ToInt32(Session["ID"]);
            int noteid = Convert.ToInt32(id);

            var getnote = context.SellerNotes.Where(s => s.SellerID == usrid && s.ID == noteid && s.Status == 10).FirstOrDefault();
            var getfile = context.SellerNotesAttachements.Where(x => x.NoteID == noteid).FirstOrDefault();
            if (getnote != null) {
                SellerNote s = new SellerNote
                {
                    SellerID = getnote.SellerID,
                    Status = 6,
                    PublishedDate = DateTime.Now,
                    Title = getnote.Title,
                    Category =getnote.Category,
                    DisplayPicture = getnote.DisplayPicture,
                    NoteType = getnote.NoteType,
                    NumberOfPages = getnote.NumberOfPages,
                    Description = getnote.Description,
                    UniversityName = getnote.UniversityName,
                    Country = getnote.Country,
                    Course = getnote.Course,
                    CourseCode =getnote.CourseCode,
                    Professor = getnote.Professor,
                    IsPaid=getnote.IsPaid,
                    SellingPrice =getnote.SellingPrice,
                    NotesPreview=getnote.NotesPreview,
                    CreatedBy=usrid,
                    CreatedDate=DateTime.Now,
                    ModifiedBy=usrid,
                    ModifiedDate = DateTime.Now,
                    IsActive = true
                };
                context.SellerNotes.Add(s);
                context.SaveChanges();
                int attachid = context.SellerNotes.OrderByDescending(u => u.ID).Select(u => u.ID).FirstOrDefault();
                SellerNotesAttachement sa = new SellerNotesAttachement
                { 
                    NoteID = attachid,
                    FileName=getfile.FileName,
                    FilePath = getfile.FilePath,
                    CreatedBy=usrid,
                    CreatedDate=DateTime.Now,
                    ModifiedBy=usrid,
                    ModifiedDate=DateTime.Now
                };
                context.SellerNotesAttachements.Add(sa);
                context.SaveChanges();
            }
            TempData["Clone"] = "Save this note as a draft note successfully.";
            return RedirectToAction("RejectedNote", "User");
        }

        
        //Download File
        public ActionResult Download(string path)
        {
            string fullName = "C:\\Users\\Administrator\\source\\repos\\NotesMarketPlace\\UserFile\\FileName\\" + path;
            byte[] fileBytes = GetFile(fullName);
            return File(
                fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, path);
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
            string a = Session["ID"].ToString();
            int usrid = Convert.ToInt32(a);
            ViewBag.CurrentSort = sortOrder;
            ViewBag.title = String.IsNullOrEmpty(sortOrder) ? "title_desc" : "";
            ViewBag.email = sortOrder == "email" ? "email_desc" : "email";
            ViewBag.category = sortOrder == "category" ? "category_desc" : "category";
            ViewBag.selltype = sortOrder == "selltype" ? "selltype_desc" : "selltype";
            ViewBag.price = sortOrder == "price" ? "price_desc" : "price";
            ViewBag.date = sortOrder == "date" ? "date_desc" : "date";
            if (searchString != null)
            {
                page = 1;
            }
            else
            {
                searchString = currentFilter;
            }

            ViewBag.CurrentFilter = searchString;

            List<User> userlist = context.Users.ToList();
            List<Download> downloadnotelist = context.Downloads.ToList();
            List<Paid> paidlist = context.Paids.ToList();

            var process1 = from d in downloadnotelist.Where(x => x.Downloader.Equals(usrid) && x.IsSellerHasAllowedDownload == true)
                           join u in userlist on d.Downloader equals u.ID into table1
                           from u in table1.DefaultIfEmpty()
                           join p in paidlist on d.IsPaid equals p.ID into table2
                           from p in table2.DefaultIfEmpty()
                           select new Mydownloads { downloadnotelist = d, userlist = u, paidlist = p };

            if (!String.IsNullOrEmpty(searchString))
            {
                process1 = process1.Where(s => s.downloadnotelist.NoteTitle.ToLower().Contains(searchString.ToLower()));
            }
            switch (sortOrder)
            {
                case "title_desc":
                    process1 = process1.OrderByDescending(s => s.downloadnotelist.NoteTitle);
                    break;
                case "email":
                    process1 = process1.OrderBy(s => s.userlist.EmailID);
                    break;
                case "email_desc":
                    process1 = process1.OrderByDescending(s => s.userlist.EmailID);
                    break;
                case "category":
                    process1 = process1.OrderBy(s => s.downloadnotelist.NoteCategory);
                    break;
                case "category_desc":
                    process1 = process1.OrderByDescending(s => s.downloadnotelist.NoteCategory);
                    break;
                case "selltype":
                    process1 = process1.OrderBy(s => s.paidlist.PaidType);
                    break;
                case "selltype_desc":
                    process1 = process1.OrderByDescending(s => s.paidlist.PaidType);
                    break;
                case "price":
                    process1 = process1.OrderBy(s => s.downloadnotelist.PurchasedPrice);
                    break;
                case "price_desc":
                    process1 = process1.OrderByDescending(s => s.downloadnotelist.PurchasedPrice);
                    break;
                case "date":
                    process1 = process1.OrderBy(s => s.downloadnotelist.AttachmentDownloadedDate);
                    break;
                case "date_desc":
                    process1 = process1.OrderByDescending(s => s.downloadnotelist.AttachmentDownloadedDate);
                    break;
                default:  // Name ascending 
                    process1 = process1.OrderBy(s => s.downloadnotelist.NoteTitle);
                    break;
            }

            int pageSize = 8;
            int pageNumber = (page ?? 1);
            return View(process1.ToPagedList(pageNumber, pageSize));

        }
        public ActionResult Inappropriate(string id, string remark)
        {
            int usrid = Convert.ToInt32(Session["ID"]);
            int noteid = Convert.ToInt32(id);
            string remarks = remark;
            var note = context.Downloads.FirstOrDefault(s => s.NoteID == noteid);
            var reportedissue = context.SellerNotesReportedIssues.FirstOrDefault(c => c.NoteID == noteid && c.ReportedByID == usrid);
            if (reportedissue != null)
            {
                TempData["Mydownload"] = "You already reported issue.";
                return RedirectToAction("MyDownloads");
            }
            else {
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

                string downloadername = context.Users.Where(s=>s.ID==usrid).Select(s=>s.FirstName).FirstOrDefault();
                string sellername = context.Users.Where(s => s.ID == note.Seller).Select(s => s.FirstName).FirstOrDefault();
                string body = string.Empty;
                string subject = downloadername + "Reported an issue for"+note.NoteTitle;
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
        public ActionResult rating(string rating, string id, string comments)
        {
            int usrid = Convert.ToInt32(Session["ID"]);
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
        public ActionResult MyDownloadNote(string path, int id)
        {
            var note = context.SellerNotes.Where(x => x.ID == id).FirstOrDefault();
            var attach = context.SellerNotesAttachements.Where(x => x.NoteID == id).FirstOrDefault();
            int usrid = Convert.ToInt32(Session["ID"]);


            var download = new Download
            {
                NoteID = Convert.ToInt32(id),
                Seller = Convert.ToInt32(note.SellerID),
                Downloader = Convert.ToInt32(usrid),
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

            string fullName = "C:\\Users\\Administrator\\source\\repos\\NotesMarketPlace\\UserFile\\FileName\\" + attach.FileName;
            byte[] fileBytes = GetFile(fullName);
            return File(
                fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, path);
        }


        //UserProfile
        [HttpGet]
        public ActionResult UserProfile()
        {
            return View();
        }
        [HttpPost]
        public ActionResult UserProfile(Userprofile model)
        {
            //Model Verification
            if (ModelState.IsValid)
            {
                int sessionid = Convert.ToInt32(Session["ID"]);
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
                UserProfile userprofile = new UserProfile
                {
                    ID = sessionid,
                    UserID = sessionid,
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
                    CreatedBy = sessionid,
                    ModifiedDate = DateTime.Now,
                    ModifiedBy = sessionid,
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
        [HttpGet]
        public ActionResult EditProfile()
        {
            int id = Convert.ToInt32(Session["ID"]);
            var profile = context.UserProfiles.Where(s => s.UserID == id).FirstOrDefault();
            var name = context.Users.Where(s => s.ID == id).FirstOrDefault();
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
        [HttpPost]
        public ActionResult EditProfile(Userprofile model)
        {
            if (ModelState.IsValid)
            {
                int id = Convert.ToInt32(Session["ID"]);
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
                    path3 = context.UserProfiles.Where(s => s.UserID == id).Select(s => s.ProfilePicture).FirstOrDefault();
                }
                var data = context.UserProfiles.FirstOrDefault(s => s.UserID == id);
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
                    data.ModifiedBy = id;
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


        // Change Password
        [HttpGet]
        public ActionResult ChangePassword()
        {
            return View();
        }
        [HttpPost]
        public ActionResult ChangePassword(Changepassword model)
        {
            int sellerid = Convert.ToInt32(Session["ID"]);
            if (ModelState.IsValid)
            {
                var data = context.Users.Where(s => s.ID == sellerid && s.Password == model.OldPassword).FirstOrDefault();
                if (data != null)
                {
                    data.Password = model.NewPassword;
                    context.SaveChanges();
                    return RedirectToAction("Home");
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


        //Contact Us
        [HttpGet]
        public ActionResult Contactus()
        {
            var sellerid = Session["ID"];
            ViewBag.sellerid = sellerid;
            var id = Convert.ToInt32(sellerid);
            if (sellerid != null)
            {
                var userlist = context.Users.Where(s => s.ID == id).FirstOrDefault();
                ViewBag.email = userlist.EmailID;
                ViewBag.name = userlist.FirstName + " " + userlist.LastName;
                return View();
            }
            else
            {
                return View();
            }

            return View();
        }
        [HttpPost]
        public ActionResult Contactus(ContactUs model)
        {
            if (ModelState.IsValid)
            {
                var sellerid = Session["ID"];
                ViewBag.sellerid = sellerid;
                var id = Convert.ToInt32(sellerid);
                if (sellerid != null)
                {
                    string body = string.Empty;
                    string subject = model.Subject;
                    string receiver = "janakpatel00002@gmail.com";
                    using (StreamReader reader = new StreamReader(Server.MapPath("~/email/contactus.html")))
                    {
                        body = reader.ReadToEnd();
                    }
                    body = body.Replace("[Comment]", model.Comment);
                    body = body.Replace("[Name]", model.FirstName);
                    SendEmail(receiver, subject, body);
                    ViewBag.Success = "your comment sent to the admin.";

                    var userlist = context.Users.Where(s => s.ID == id).FirstOrDefault();
                    ViewBag.email = userlist.EmailID;
                    ViewBag.name = userlist.FirstName + " " + userlist.LastName;
                    return View();
                }
                else
                {

                    string body = string.Empty;
                    string subject = model.Subject;
                    string receiver = "janakpatel00002@gmail.com";
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


        //Faq
        public ActionResult Faqs()
        {
            var sellerid = Session["ID"];
            ViewBag.sellerid = sellerid;
            return View();
        }
    }
}