package com.publiccomponent.loading.data
{
   import com.publiccomponent.URLUtil;
   
   public class BufInfoTypeData
   {
      
      private var _id:int;
      
      public var name:String;
      
      public var combat_desc:String;
      
      public var no_buf_blood:int;
      
      public var buf_blood_desc:String;
      
      public var hide:int;
      
      private var _url:String;
      
      private var _other:Object;
      
      private var _other_desc:Object;
      
      public function BufInfoTypeData()
      {
         super();
      }
      
      public function get other_desc() : Object
      {
         return this._other_desc;
      }
      
      public function set other_desc(value:Object) : void
      {
         this._other_desc = value;
      }
      
      public function initOtherDesc(str:String) : void
      {
         var key:String = null;
         for(key in this._other_desc)
         {
            this._other_desc[key] = this._other_desc[key].replace("#desc#",str);
         }
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(value:int) : void
      {
         this._id = value;
         this._url = URLUtil.getSvnVer("assets/bufIcon/" + this._id + ".png");
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get other() : Object
      {
         return this._other;
      }
      
      public function set other(value:Object) : void
      {
         this._other = value;
      }
   }
}

