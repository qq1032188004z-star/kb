package com.game.util
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class FriendAlert extends Sprite
   {
      
      private var callBack:Function;
      
      private var alertClip:MovieClip;
      
      private var loader:Loader;
      
      private var msgTxt:String;
      
      public function FriendAlert()
      {
         super();
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplement);
      }
      
      public function showAddFriendAlert(tip:String, parent:DisplayObjectContainer, callBack:Function = null) : void
      {
         this.msgTxt = tip;
         this.callBack = callBack;
         parent.addChild(this);
         this.loader.load(new URLRequest("assets/material/addfriendalert.swf"));
      }
      
      public function showAddFriendOk(tip:String, parent:DisplayObjectContainer, callBack:Function = null) : void
      {
         this.msgTxt = tip;
         this.callBack = callBack;
         parent.addChild(this);
         this.loader.load(new URLRequest("assets/material/addfriendok.swf"));
      }
      
      public function showRefuseAddFriend(tip:String, parent:DisplayObjectContainer, callBack:Function = null) : void
      {
         this.msgTxt = tip;
         this.callBack = callBack;
         parent.addChild(this);
         this.loader.load(new URLRequest("assets/material/refusefriend.swf"));
      }
      
      private function onLoadComplement(evt:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplement);
         this.alertClip = this.loader.getChildAt(0) as MovieClip;
         if(this.alertClip != null)
         {
            addChild(this.alertClip);
            this.alertClip.tipTxt.text = this.msgTxt;
            this.initEvent();
         }
      }
      
      private function initEvent() : void
      {
         if(this.alertClip.hasOwnProperty("btn1"))
         {
            this.alertClip.btn1.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickBtn);
         }
         if(this.alertClip.hasOwnProperty("btn2"))
         {
            this.alertClip.btn2.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickBtn);
         }
      }
      
      private function onClickBtn(evt:MouseEvent) : void
      {
         if(Boolean(this.alertClip.hasOwnProperty("btn1")) && evt.target == this.alertClip.btn1 && this.callBack != null)
         {
            this.callBack.apply(null,["sure"]);
         }
         if(Boolean(this.alertClip.hasOwnProperty("btn2")) && evt.target == this.alertClip.btn2 && this.callBack != null)
         {
            this.callBack.apply(null,["cancel"]);
         }
         this.dispos();
      }
      
      private function dispos() : void
      {
         this.alertClip.dClip.stop();
         this.loader.unloadAndStop(false);
         if(this.alertClip.hasOwnProperty("btn1"))
         {
            this.alertClip.btn1.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickBtn);
         }
         if(this.alertClip.hasOwnProperty("btn2"))
         {
            this.alertClip.btn2.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickBtn);
         }
         this.removeChild(this.alertClip);
         this.alertClip = null;
         if(this.parent != null)
         {
            if(this.parent.contains(this))
            {
               this.parent.removeChild(this);
            }
         }
      }
   }
}

