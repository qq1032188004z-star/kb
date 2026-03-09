package com.game.util
{
   public class CheckMetalHeroBtnUtil
   {
      
      private static var _instance:CheckMetalHeroBtnUtil;
      
      private var _braveHide:Boolean;
      
      private var _freshManAwardHide:Boolean;
      
      private var _showFun:Function;
      
      private var _hideFun:Function;
      
      public function CheckMetalHeroBtnUtil()
      {
         super();
      }
      
      public static function instance() : CheckMetalHeroBtnUtil
      {
         if(_instance == null)
         {
            _instance = new CheckMetalHeroBtnUtil();
         }
         return _instance;
      }
      
      public function set showFun($fun:Function) : void
      {
         this._showFun = $fun;
      }
      
      public function set hideFun($fun:Function) : void
      {
         this._hideFun = $fun;
      }
      
      public function set braveStatus($status:Boolean) : void
      {
         this._braveHide = !$status;
         this.update();
      }
      
      public function set freshManAwardStatus($status:Boolean) : void
      {
         this._freshManAwardHide = !$status;
         this.update();
      }
      
      private function update() : void
      {
         if(this._braveHide && this._freshManAwardHide)
         {
            if(this._showFun != null)
            {
               this._showFun();
            }
         }
         else if(this._hideFun != null)
         {
            this._hideFun();
         }
      }
   }
}

