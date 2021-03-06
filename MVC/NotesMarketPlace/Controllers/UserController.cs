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
using PagedList.Mvc;
using PagedList;
using System.Data;
using System.Configuration;

namespace NotesMarketPlace.Controllers
{
    public class UserController : Controller
    {
        NotesMarketPlaceEntities db = new NotesMarketPlaceEntities();

        // GET: User
        public ActionResult Index()
        {
            return View();
        }
    
        // Signup verification Email
        private void SignupSendEmail(string name, string receiver, string activationcode)
        {
            using (MailMessage mailMessage = new MailMessage())
            {
                mailMessage.From = new MailAddress("note.mk.p@gmail.com", "janakpatel patel");
                mailMessage.Subject = "Account Activation";
                string body = "Hello " + name + ",";
                body += "<br /><br />Thank you for signing up with us. Please click on below link to verify your email address and to do login.";
                body += "<br /><a href = '" + string.Format("{0}://{1}/User/Activation/{2}", Request.Url.Scheme, Request.Url.Authority, activationcode) + "'>Click here to activate your account.</a>";
                body += "<br /><br />Regards,";
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
        //Activation Code for the email verification
        public ActionResult Activation()
        {
            ViewBag.Message = "Invalid Activation code.";
            if (RouteData.Values["id"] != null)
            {
                //get activation code from the link
                string activationCode = new Guid(RouteData.Values["id"].ToString()).ToString();
                NotesMarketPlaceEntities context = new NotesMarketPlaceEntities();
                var id = context.Users.Where(u => u.ActivationCode== activationCode ).FirstOrDefault();

                if (id != null)
                {
                    id.IsEmailVerified = true;
                    context.SaveChanges();
                    ViewBag.Message = "Your Email varified successful.";
                }
            }

            return View();
        }
        // signup get method
        public ActionResult Signup()
        {
            return View();
        }

        //Signup page post method
        [HttpPost]
        public ActionResult Signup(Signup model)
        {
            //entered value is verified
            if (ModelState.IsValid)
            {
                //account already exist
                if (db.Users.Any(x => x.EmailID == model.EmailID))
                {
                    ViewBag.error = String.Format("Already you have an account exists.");
                    return View();
                }
                else
                {
                    // UserRole Table data
                    var userrole = new UserRole
                    {
                        Name = model.FirstName,
                        Description = "User",
                        CreatedDate= DateTime.Now,
                        ModifiedDate = DateTime.Now,
                        IsActive=true
                    };
                    db.UserRoles.Add(userrole);
                    db.SaveChanges();
                    var id = db.UserRoles.OrderByDescending(u => u.ID).FirstOrDefault();
                    var ActivationCode = Guid.NewGuid().ToString();

                    //User Table Data
                    User user = new User();
                    user.ID = userrole.ID;
                    user.RoleID = userrole.ID;
                    user.FirstName = model.FirstName;
                    user.LastName = model.LastName;
                    user.EmailID = model.EmailID;
                    user.Password = model.Password;
                    user.CreatedDate = DateTime.Now;
                    user.CreatedBy = userrole.ID;
                    user.ActivationCode = ActivationCode;
                    user.IsActive = true;
                    db.Users.Add(user);
                    SignupSendEmail(model.FirstName, model.EmailID, ActivationCode);
                    db.SaveChanges();
                    Session["FirstName"] = model.FirstName.ToString();
                    return RedirectToAction("emailverification");
                }
            }
            ViewBag.error = String.Format("Please Enter valid detail.");
            return View();
        }

        //Email verification page method
        public ActionResult emailverification()
        {
            var name = Session["FirstName"].ToString();
            ViewBag.name = name;
            return View();
        }

        //Login Page Methods
        public ActionResult Login()
        {
            return View();
        }

        //Login Page Post Methods
        [HttpPost]
        public ActionResult Login(Login model)
        {
            var obj = db.Users.Where(a => a.EmailID.Equals(model.EmailID) && a.Password.Equals(model.Password)).FirstOrDefault();
            var usertype = db.UserRoles.Where(b => b.ID == obj.ID).FirstOrDefault();
            //Entered value is valid 
            if (ModelState.IsValid && obj != null)
            {
                // Email is verified or not
                if (obj.IsEmailVerified == true && usertype.Description == "Admin")
                {
                    Session["ID"] = obj.ID;
                    Session["EmailID"] = obj.EmailID.ToString();
                    return RedirectToAction("Dashboard", "Admin");
                }
                else if (obj.IsEmailVerified == true && usertype.Description == "User")
                {
                    Session["ID"] = obj.ID;
                    Session["EmailID"] = obj.EmailID.ToString();
                    return RedirectToAction("Dashboard");
                }
                else
                {
                    ViewBag.error = String.Format("Please Verify your email id.");
                    return View();
                }
            }
            else
            {
                ViewBag.error = String.Format("Please enter valid username or password.");
                return View();
            }
        }


        //Random String for the generate password
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
        //  get email html body for ForgotPassword
        private string forgotpasswordbody(string forgotpassword)
        {
            string body = string.Empty;
            using (StreamReader reader = new StreamReader(Server.MapPath("~/email/Forgotpassword.htm")))
            {
                body = reader.ReadToEnd();
            }
            body = body.Replace("[password]", forgotpassword);
            return body;
        }

        //Forgot Password get method
        public ActionResult Forgotpassword()
        {
            return View();
        }
        
        //Post method for Forgot Password Page
        [HttpPost]
        public ActionResult Forgotpassword(ForgotPassword model)
        {
            NotesMarketPlaceEntities db = new NotesMarketPlaceEntities();
            //Generate the string
            var generator = new RandomGenerator();
            var randomString = generator.RandomString(10);
            var data = db.Users.FirstOrDefault(x => x.EmailID == model.EmailID);

            // Checking if any such record exist  
            if (data != null)
            {
                data.Password = randomString;
                db.SaveChanges();
                string body = forgotpasswordbody(randomString);
                string subject = "Forgot Password";
                SendEmail(model.EmailID, subject, body);
                ViewBag.success = String.Format("Your password is sent to your registered email id.");
                return View();
            }
            else
            {
                ViewBag.error = String.Format("Please enter correct email id.");
                return View();
            }
        }

        public ActionResult Dashboard(int PageNumber = 1, int PageNumber2 = 1)
        {
            string a = Session["ID"].ToString();
            int useid1 = Convert.ToInt32(a);

            NotesMarketPlaceEntities context = new NotesMarketPlaceEntities();

            //Dashboard main box heading
            ViewBag.downloadno = context.Downloads.Where(x => x.Downloader == useid1).Count();
            ViewBag.rejectno = context.SellerNotes.Where(x => x.Status == 10).Count();
            ViewBag.Buyerreuest = context.Downloads.Where(x => x.Seller == useid1 && x.IsSellerHasAllowedDownload == false).Count();
            ViewBag.notesold = context.Downloads.Where(x => x.Seller == useid1 && x.IsSellerHasAllowedDownload == true).Count();
            var n = context.Downloads.Where(x => x.Seller == useid1).Select(u => u.PurchasedPrice).ToList();
            ViewBag.Total = n.Sum(x => x.Value);

            // table 1
            List<ReferenceData> referencelist = db.ReferenceDatas.ToList();
            List<SellerNote> sellernotelist = db.SellerNotes.ToList();
            List<NoteCategory> notecategory = db.NoteCategories.ToList();
            ViewBag.PageNumber = PageNumber;

            var process1 = from s in sellernotelist.Where(x => x.SellerID.Equals(useid1) && x.Status != 9)
                           join r in referencelist on s.Status equals r.ID into table1
                           from r in table1.DefaultIfEmpty()
                           join c in notecategory on s.Category equals c.ID into table2
                           from c in table2.DefaultIfEmpty()
                           select new Dashboard { sellernotelist = s, referencelist = r, notecategory = c };
            ViewBag.TotalPages = Math.Ceiling(process1.Count() / 3.0);
            ViewBag.process1 = process1.Skip((PageNumber - 1) * 3).Take(3).ToList();

            // table 2-published book
            ViewBag.PageNumber2 = PageNumber2;
            var process2 = from s in sellernotelist.Where(x => x.SellerID.Equals(useid1) && x.Status == 9)
                           join r in referencelist on s.Status equals r.ID into table1
                           from r in table1.DefaultIfEmpty()
                           join c in notecategory on s.Category equals c.ID into table2
                           from c in table2.DefaultIfEmpty()
                           select new Dashboard { sellernotelist = s, referencelist = r, notecategory = c };
            ViewBag.TotalPages2 = Math.Ceiling(process2.Count() / 3.0);
            ViewBag.process2 = process2.Skip((PageNumber2 - 1) * 3).Take(3).ToList();
            return View();

        }

        // when user search for book
        [HttpPost]
        public ActionResult Dashboard(string searching1, string searching2)
        {
            string a = Session["ID"].ToString();
            int useid1 = Convert.ToInt32(a);

            //Dashboard main box heading
            NotesMarketPlaceEntities context = new NotesMarketPlaceEntities();
            ViewBag.downloadno = context.Downloads.Where(x => x.Downloader == useid1).Count();
            ViewBag.rejectno = context.SellerNotes.Where(x => x.Status == 10).Count();
            ViewBag.Buyerreuest = context.Downloads.Where(x => x.Seller == useid1 && x.IsSellerHasAllowedDownload == false).Count();
            ViewBag.notesold = context.Downloads.Where(x => x.Seller == useid1 && x.IsSellerHasAllowedDownload == true).Count();
            var n = context.Downloads.Where(x => x.Seller == useid1).Select(u => u.PurchasedPrice).ToList();
            ViewBag.Total = n.Sum(x => x.Value);

            // table 1
            List<ReferenceData> referencelist = db.ReferenceDatas.ToList();
            List<SellerNote> sellernotelist = db.SellerNotes.ToList();
            List<NoteCategory> notecategory = db.NoteCategories.ToList();
            int PageNumber = 1;
            ViewBag.PageNumber = PageNumber;
            var process1 = from s in sellernotelist.Where(x => x.SellerID.Equals(useid1) && x.Status != 9 && x.Title.Contains(searching1) || searching1 == null).ToList()
                           join r in referencelist on s.Status equals r.ID into table1
                           from r in table1.DefaultIfEmpty()
                           join c in notecategory on s.Category equals c.ID into table2
                           from c in table2.DefaultIfEmpty()
                           select new Dashboard { sellernotelist = s, referencelist = r, notecategory = c };
            ViewBag.TotalPages = Math.Ceiling(process1.Count() / 3.0);
            ViewBag.process1 = process1.Skip((PageNumber - 1) * 3).Take(3).ToList();

            // table 2
            int PageNumber2 = 1;
            ViewBag.PageNumber2 = PageNumber2;
            var process2 = from s in sellernotelist.Where(x => x.SellerID.Equals(useid1) && x.Status == 9 && x.Title.Contains(searching2) || searching2 == null)
                           join r in referencelist on s.Status equals r.ID into table1
                           from r in table1.DefaultIfEmpty()
                           join c in notecategory on s.Category equals c.ID into table2
                           from c in table2.DefaultIfEmpty()
                           select new Dashboard { sellernotelist = s, referencelist = r, notecategory = c };
            ViewBag.TotalPages2 = Math.Ceiling(process2.Count() / 3.0);
            ViewBag.process2 = process2.Skip((PageNumber2 - 1) * 3).Take(3).ToList();
            return View();

        }

        //when user click on delete icon of dashboard page
        public ActionResult Delete(int id)
        {
            var data = db.SellerNotesAttachements.Where(x => x.NoteID == id).First();
            var data1 = db.SellerNotes.Where(x => x.ID == id).First();
            if (data != null | data1 != null)
            {
                db.SellerNotesAttachements.Remove(data);
                db.SaveChanges();
                db.SellerNotes.Remove(data1);
                db.SaveChanges();
                return RedirectToAction("Dashboard");
            }
            else
            {
                return View();
            }
        }




        //Add Note Page 
        public ActionResult Addnote()
        {
            NotesMarketPlaceEntities context = new NotesMarketPlaceEntities();
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


        //Add Note Page
        [HttpPost]
        public ActionResult Addnote(Addnote model)
        {
            string a = Session["ID"].ToString();
            int sellerid = Convert.ToInt32(a);
            //For the DropDown
            NotesMarketPlaceEntities context = new NotesMarketPlaceEntities();
            var category = context.NoteCategories.ToList();

            SelectList list = new SelectList(category, "ID", "NAME");
            ViewBag.category = list;
            var type = context.NoteTypes.ToList();
            SelectList list1 = new SelectList(type, "ID", "NAME");
            ViewBag.type = list1;
            var country = context.Countries.ToList();
            SelectList list2 = new SelectList(country, "ID", "NAME");
            ViewBag.country = list2;

            //Model Verification
            if (ModelState.IsValid)
            {
                //Status save or published
                int statusid = 0;
                string status = model.Button.ToString();
                if (status == "save")
                {
                    statusid = 6;
                }
                else
                {
                    statusid = 9;
                }
                //For the Uploaded Files
                var path2 = "";
                var path3 = "";
                if (model.DisplayPictureFile != null)
                {
                    var fileName3 = Path.GetFileName(model.DisplayPictureFile.FileName);
                    path3 = Path.Combine(Server.MapPath("~/UserFile/DisplayPictureName"), fileName3);
                    model.DisplayPictureFile.SaveAs(path3);
                    path3 = "~/UserFile/DisplayPictureName" + "/" + fileName3;
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
                    path2 = "~/UserFile/NotesPreview" + "/" + fileName2;
                }
                else
                {
                    path2 = "";
                }
                SellerNote sellernote = new SellerNote();
                sellernote.SellerID = sellerid;
                sellernote.Status = statusid;
                sellernote.ActionedBy = sellerid;
                sellernote.Title = model.Title;
                sellernote.Category = model.Category;
                sellernote.PublishedDate = DateTime.Now;
                sellernote.NoteType = model.Type;
                sellernote.NumberOfPages = model.NumberOfPages;
                sellernote.Description = model.Description;
                sellernote.DisplayPicture = path3;
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
                context.SellerNotes.Add(sellernote);
                int noteid = context.SellerNotes.OrderByDescending(u => u.ID).Select(u => u.ID).FirstOrDefault();
                //For SellerNoteAttachment
                var fileName = Path.GetFileName(model.FileName.FileName);
                var path = Path.Combine(Server.MapPath("~/UserFile/FileName"), fileName);
                model.FileName.SaveAs(path);
                path = "~/UserFile/FileName" + "/" + fileName;
                SellerNotesAttachement att = new SellerNotesAttachement();
                att.NoteID = noteid + 1;
                att.FileName = fileName;
                att.FilePath = path;
                att.CreatedBy = sellerid;
                att.CreatedDate = DateTime.Now;
                context.SellerNotesAttachements.Add(att);
                context.SaveChanges();

                var sellernamef = db.Users.Where(t => t.ID == sellerid).Select(t => t.FirstName).FirstOrDefault();
                var sellernamel = db.Users.Where(t => t.ID == sellerid).Select(t => t.LastName).FirstOrDefault();
                string body = string.Empty;
                string subject = sellernamef+""+sellernamel+" sent his note for review";
                string Admin = "janakpatel00002@gmail.com";
                using (StreamReader reader = new StreamReader(Server.MapPath("~/email/addnote.html")))
                {
                    body = reader.ReadToEnd();
                }
                body = body.Replace("[Sellerf]", sellernamef);
                body = body.Replace("[Sellerl]", sellernamel);
                body = body.Replace("[NoteTitle]", model.Title);
                SendEmail(Admin, subject, body);
                ViewBag.message= String.Format("Addnote successfully and send the mail to admins.");
                return View();

            }
            else
            {
                ViewBag.message = String.Format("Please enter valid detail");
                return View();
            }

        }



        public ActionResult BuyerRequest(int PageNumber = 1)
        {
            string a = Session["ID"].ToString();
            int usrid = Convert.ToInt32(a);
            List<User> userlist = db.Users.ToList();
            List<Download> downloadnotelist = db.Downloads.ToList();

            ViewBag.PageNumber = PageNumber;
            var process1 = from d in downloadnotelist.Where(x => x.Seller.Equals(usrid) && x.IsSellerHasAllowedDownload == false)
                           join u in userlist on d.Downloader equals u.ID into table1
                           from u in table1.DefaultIfEmpty()
                           select new Buyerrequest { downloadnotelist = d, userlist = u };
            ViewBag.TotalPages = Math.Ceiling(process1.Count() / 3.0);
            ViewBag.process1 = process1.Skip((PageNumber - 1) * 3).Take(3).ToList();

            return View();
        }
        [HttpPost]
        public ActionResult BuyerRequest(string searching1)
        {
            string a = Session["ID"].ToString();
            int usrid = Convert.ToInt32(a);
            List<User> userlist = db.Users.ToList();
            List<Download> downloadnotelist = db.Downloads.ToList();
            int PageNumber = 1;

            ViewBag.PageNumber = PageNumber;
            var process1 = from d in downloadnotelist.Where(x => x.Seller.Equals(usrid) && x.IsSellerHasAllowedDownload == false && x.NoteTitle.Contains(searching1) || searching1 == null).ToList()
                           join u in userlist on d.Downloader equals u.ID into table1
                           from u in table1.DefaultIfEmpty()
                           select new Buyerrequest { downloadnotelist = d, userlist = u };
            ViewBag.TotalPages = Math.Ceiling(process1.Count() / 3.0);
            ViewBag.process1 = process1.Skip((PageNumber - 1) * 3).Take(3).ToList();

            return View();
        }

        public ActionResult allowdownload(int? id)
        {
            var data = db.Downloads.Where(x => x.NoteID == id).First();
            if (data != null)
            {
                data.IsSellerHasAllowedDownload = true;
                db.SaveChanges();
                return RedirectToAction("BuyerRequest");
            }
            else
            {
                return View();
            }
        }
        [HttpGet]
        public ActionResult Contactus() {
            return View();
        }
        [HttpPost]
        public ActionResult Contactus(contactus model)
        {
            string body = string.Empty;
            string subject = model.Subject;
            string Admin = "janakpatel00002@gmail.com";
            using (StreamReader reader = new StreamReader(Server.MapPath("~/email/contactus.html")))
            {
                body = reader.ReadToEnd();
            }
            body = body.Replace("[Comment]", model.Comment);
            body = body.Replace("[Name]", model.Name);
            SendEmail(Admin, subject,body);
            ViewBag.Success = "your comment sent to the admin.";
            return View();
        }

        public ActionResult Faqs()
        {
            return View();
        }

        [HttpGet]
        public ActionResult Notedetail(int? id)
        {
            string a = Session["ID"].ToString();
            int usrid = Convert.ToInt32(a);
            
            List<User> userlist = db.Users.ToList();
            List<SellerNote> sellernotelist = db.SellerNotes.ToList();
            List<NoteCategory> categorylist = db.NoteCategories.ToList();
            List<Country> countrylist = db.Countries.ToList();
            List<NoteType> typelist = db.NoteTypes.ToList();
            List<SellerNotesReview> reviewlist = db.SellerNotesReviews.ToList();

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
                            select new Notedetail { reviewlist = r, userlist = u };

            ViewBag.noteid = id;
            var sellerid = db.SellerNotes.Where(t => t.ID == id).Select(t => t.SellerID).FirstOrDefault();
            ViewBag.sellername = db.Users.Where(t => t.ID == sellerid).Select(t => t.FirstName).FirstOrDefault();
            ViewBag.sellerlastname = db.Users.Where(t => t.ID == sellerid).Select(t => t.LastName).FirstOrDefault();
            ViewBag.username = db.Users.Where(t => t.ID == usrid).Select(t => t.FirstName).FirstOrDefault();

            ViewBag.count = db.SellerNotesReviews.Where(s => s.NoteID == id).Count();
            var data = db.SellerNotesReviews.Where(s => s.NoteID == id).Select(s => s.Ratings).ToList();
            if (ViewBag.count == 0)
            {
                var average = 0;
            }
            else
            {
                var average = data.Average();
                ViewBag.average = Convert.ToInt32(average);
            }

            Session["NoteID"] = id;
            return View();
        }

        public ActionResult mailnotedetail(int? id)
        {
            string a = Session["ID"].ToString();
            int usrid = Convert.ToInt32(a);

            var sellerid = db.SellerNotes.Where(t => t.ID == id).Select(t => t.SellerID).FirstOrDefault();
            var sellername = db.Users.Where(t => t.ID == sellerid).Select(t => t.FirstName).FirstOrDefault();
            var username1 = db.Users.Where(t => t.ID == usrid).Select(t => t.FirstName).FirstOrDefault();
            var username2 = db.Users.Where(t => t.ID == usrid).Select(t => t.LastName).FirstOrDefault();
            var email = db.Users.Where(t => t.ID == sellerid).Select(t => t.EmailID).FirstOrDefault();
            string body = string.Empty;
            string subject = username1+" "+username2+ "wants to purchase your notes ";
            using (StreamReader reader = new StreamReader(Server.MapPath("~/email/mailnotedetail.html")))
            {
                body = reader.ReadToEnd();
            }
            body = body.Replace("[seller]", sellername);
            body = body.Replace("[BuyerF]", username1);
            body = body.Replace("[BuyerL]", username2);
            SendEmail(email, subject, body);
            return RedirectToAction("Dashboard");
        }





























        }
    }