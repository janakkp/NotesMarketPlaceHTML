//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace NotesMarketPlace
{
    using System;
    using System.Collections.Generic;
    
    public partial class SystemConfiguration
    {
        public SystemConfiguration()
        {
            this.UserProfiles = new HashSet<UserProfile>();
        }
    
        public int ID { get; set; }
        public string Key { get; set; }
        public string Value { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public Nullable<int> CreatedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
        public bool IsActive { get; set; }
    
        public virtual ICollection<UserProfile> UserProfiles { get; set; }
    }
}
