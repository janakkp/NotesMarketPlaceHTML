using System.Web;
using System.Web.Optimization;

namespace NotesMarketPlace
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

            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));


            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.min.js",
                      "~/Scripts/header.js",
                      "~/Scripts/jquery.js",
                      "~/Scripts/script.js"
                      ));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap1").Include(
                      "~/Scripts/jquery.js",
                      "~/Scripts/bootstrap.min.js",
                      "~/Scripts/stickyheader.js",
                      "~/Scripts/script.js"
                      ));

            bundles.Add(new StyleBundle("~/Content/css1").Include(
                      "~/Content/font-awesome.min.css",
                      "~/Content/bootstrap.min.css",
                      "~/Content/responsive-tabs.css",
                      "~/Content/stickyheader.css",
                      "~/Content/style.css",
                      "~/Content/responsive.css"
          ));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/font-awesome.min.css",
                      "~/Content/bootstrap.min.css",
                      "~/Content/responsive-tabs.css",
                      "~/Content/header.css",
                      "~/Content/style.css",
                      "~/Content/responsive.css"
          ));
        }
    }
}
