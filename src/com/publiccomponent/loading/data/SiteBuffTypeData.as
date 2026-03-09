package com.publiccomponent.loading.data
{
   import com.publiccomponent.URLUtil;
   
   public class SiteBuffTypeData
   {
      
      private var _id:int;
      
      public var name:String;
      
      private var _s_url:String;
      
      private var _bg_url:String;
      
      public var monster_desc:Object;
      
      public function SiteBuffTypeData()
      {
         super();
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(value:int) : void
      {
         this._id = value;
         this._s_url = URLUtil.getSvnVer("assets/siteIcon/" + this._id + "_s.png");
         this._bg_url = URLUtil.getSvnVer("assets/siteIcon/" + this._id + "_bg.png");
      }
      
      public function get s_url() : String
      {
         return this._s_url;
      }
      
      public function get bg_url() : String
      {
         return this._bg_url;
      }
   }
}

