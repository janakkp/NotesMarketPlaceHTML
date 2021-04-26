using System.Web;
using System.Web.Optimization;

namespace Notes
{
    public class BundleConfig
    {
        // For more information on bundling, visit https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at https://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js"));

            bundles.Add(new ScriptBundle("~/bundles/home").Include(
                      "~/Scripts/jquery.js",
                      "~/Scripts/bootstrap.min.js",
                      "~/Scripts/stickyheader.js",
                      "~/Scripts/script.js"
                      ));

            bundles.Add(new ScriptBundle("~/bundles/user").Include(
                                 "~/Scripts/bootstrap.min.js",
                                 "~/Scripts/header.js",
                                 "~/Scripts/jquery.js",
                                 "~/Scripts/script.js"
                                 ));

            bundles.Add(new ScriptBundle("~/bundles/admin").Include(
                      "~/Scripts/Admin/bootstrap.min.js",
                      "~/Scripts/Admin/header.js",
                      "~/Scripts/Admin/jquery.js",
                      "~/Scripts/Admin/script.js"
                      ));



            bundles.Add(new StyleBundle("~/Content/user").Include(
                      "~/Content/font-awesome.min.css",
                      "~/Content/bootstrap.min.css",
                      "~/Content/responsive-tabs.css",
                      "~/Content/header.css",
                      "~/Content/style.css",
                      "~/Content/responsive.css"
                    ));
            bundles.Add(new StyleBundle("~/Content/admin").Include(
                      "~/Content/Admin/font-awesome.min.css",
                      "~/Content/Admin/bootstrap.min.css",
                      "~/Content/Admin/responsive-tabs.css",
                      "~/Content/Admin/header.css",
                      "~/Content/Admin/style.css",
                      "~/Content/Admin/responsive.css"
                      ));
            bundles.Add(new StyleBundle("~/Content/home").Include(
                      "~/Content/font-awesome.min.css",
                      "~/Content/bootstrap.min.css",
                      "~/Content/responsive-tabs.css",
                      "~/Content/stickyheader.css",
                      "~/Content/style.css",
                      "~/Content/responsive.css"
                      ));


        }
    }
}
