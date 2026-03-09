package com.publiccomponent.ui
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.util.ColorUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.dress.ui.RoleFace;
   
   public class ChatList
   {
      
      private var bg:MovieClip;
      
      private var Friends:Array = [];
      
      private var Dresses:Array = [];
      
      private var roleface0:RoleFace;
      
      private var roleface1:RoleFace;
      
      private var roleface2:RoleFace;
      
      private var roleface3:RoleFace;
      
      private var roleface4:RoleFace;
      
      private var Current:int = 0;
      
      private var Total:int = 1;
      
      private const PageNum:int = 5;
      
      public function ChatList(mc:MovieClip)
      {
         super();
         this.bg = mc;
      }
      
      public function hide() : void
      {
         this.bg.visible = false;
      }
      
      public function show() : void
      {
         this.bg.visible = true;
      }
      
      public function addFriend(someone:Object) : void
      {
         var i:int = 0;
         var len:int = int(this.Friends.length);
         var flag:Boolean = true;
         for(i = 0; i < len; i++)
         {
            if(this.Friends[i] != null && this.Friends[i].from_id == someone.from_id)
            {
               this.Friends[i] = someone;
               flag = false;
            }
         }
         if(flag)
         {
            this.Friends.unshift(someone);
         }
         this.Friends.sortOn(["isOnline","from_id"],[Array.DESCENDING,Array.NUMERIC]);
         if(someone.shakeFlag == 2)
         {
            this.renderFriends(this.Current);
         }
         else
         {
            this.renderFriends(0);
         }
      }
      
      public function delFriend(someone:Object) : void
      {
         var i:int = 0;
         var len:int = int(this.Friends.length);
         for(i = 0; i < len; i++)
         {
            if(this.Friends[i] != null && this.Friends[i].from_id == someone.userId)
            {
               this.Friends.splice(i,1);
               break;
            }
         }
         this.renderFriends(this.Current);
      }
      
      private function renderFriends(index:int = 0) : void
      {
         var i:int = 0;
         var len:int = int(this.Friends.length);
         this.Current = index;
         this.Total = Math.ceil(len / this.PageNum);
         for(i = 0; i < 5; i++)
         {
            this.bg["friend" + i].visible = false;
            this.bg["friend" + i].bgmc.gotoAndStop(7);
            this.bg["friend" + i].removeEventListener(MouseEvent.CLICK,this.onClickFriend);
            if(this.Friends[this.Current + i] != null)
            {
               this.bg["friend" + i].visible = true;
               this.bg["friend" + i].buttonMode = true;
               if(this.Friends[this.Current + i].shakeFlag == 1)
               {
                  this.bg["friend" + i].bgmc.gotoAndPlay(1);
               }
               else
               {
                  this.bg["friend" + i].bgmc.gotoAndStop(1);
               }
               if(this.Friends[this.Current + i].isOnline == 1)
               {
                  if(Boolean(this["roleface" + i]))
                  {
                     this["roleface" + i].filters = null;
                  }
               }
               else if(Boolean(this["roleface" + i]))
               {
                  this["roleface" + i].filters = ColorUtil.getColorMatrixFilterGray();
               }
               this.bg["friend" + i].nameTxt.text = this.showName(this.Friends[this.Current + i].from_name);
               this.bg["friend" + i].addEventListener(MouseEvent.CLICK,this.onClickFriend);
            }
         }
         this.updateLeftAndRight();
      }
      
      private function showName(str:String) : String
      {
         if(str.length > 3)
         {
            return str.substr(0,3) + "...";
         }
         return str;
      }
      
      public function addFriendDress(body:Object = null) : void
      {
         var i:int = 0;
         if(body == null)
         {
            this.renderDresses();
            return;
         }
         var len:int = int(this.Dresses.length);
         var flag:Boolean = true;
         for(i = 0; i < len; i++)
         {
            if(this.Dresses[i].userId == body.userId)
            {
               this.Dresses[i] = body;
               flag = false;
            }
         }
         if(flag)
         {
            this.Dresses.unshift(body);
         }
         this.renderDresses();
      }
      
      private function renderDresses() : void
      {
         var i:int = 0;
         var dress:Object = null;
         for(i = 0; i < 5; i++)
         {
            if(this.Friends[this.Current + i] != null)
            {
               dress = this.getDressById(this.Friends[this.Current + i].from_id);
               if(dress != null)
               {
                  if(this["roleface" + i] != null)
                  {
                     this["roleface" + i].clear();
                     this["roleface" + i].setRole(dress);
                     if(this.Friends[i].isOnline != null && this.Friends[this.Current + i].isOnline == 1)
                     {
                        this["roleface" + i].filters = [];
                     }
                     else
                     {
                        this["roleface" + i].filters = ColorUtil.getColorMatrixFilterGray();
                     }
                  }
                  else
                  {
                     this["roleface" + i] = new RoleFace(20,80);
                     this["roleface" + i].mouseEnabled = false;
                     this["roleface" + i].setRole(dress);
                     this.bg["friend" + i].addChild(this["roleface" + i]);
                     this.bg["friend" + i].setChildIndex(this.bg["friend" + i].bgmc,this.bg["friend" + i].numChildren - 1);
                     this["roleface" + i].mask = this.bg["friend" + i].bgmc;
                     if(this.Friends[this.Current + i].isOnline == 1)
                     {
                        this["roleface" + i].filters = [];
                     }
                     else
                     {
                        this["roleface" + i].filters = ColorUtil.getColorMatrixFilterGray();
                     }
                  }
               }
            }
         }
      }
      
      public function getDressById(uid:int) : Object
      {
         var obj:Object = null;
         for each(obj in this.Dresses)
         {
            if(obj.userId == uid)
            {
               return obj;
            }
         }
         return null;
      }
      
      public function stopShakeFriend(uid:int) : void
      {
         for(var i:int = 0; i < 5; i++)
         {
            if(this.Friends[this.Current + i] != null && this.Friends[this.Current + i].from_id == uid && this.bg["friend" + i] != null)
            {
               this.bg["friend" + i].bgmc.gotoAndStop(1);
               this.Friends[this.Current + i].shakeFlag = 0;
            }
         }
      }
      
      private function onClickFriend(evt:MouseEvent) : void
      {
         var i:int = int(String(evt.currentTarget.name).charAt(6));
         this.bg["friend" + i].bgmc.gotoAndStop(1);
         if(GameData.instance.playerData.isOpening[this.Friends[this.Current + i].from_id] != null && GameData.instance.playerData.isOpening[this.Friends[this.Current + i].from_id] == true)
         {
            return;
         }
         var sendBody:Object = {};
         sendBody.isBlack = 0;
         sendBody.isOnline = this.Friends[this.Current + i].isOnline;
         sendBody.sex = this.Friends[this.Current + i].sex;
         sendBody.userId = this.Friends[this.Current + i].from_id;
         sendBody.userName = this.Friends[this.Current + i].from_name;
         sendBody.vip = 0;
         sendBody.family = 0;
         ApplicationFacade.getInstance().dispatch(EventConst.CHATWITHFRIEND,sendBody);
      }
      
      private function onClickLeft(evt:MouseEvent) : void
      {
         if(this.Current > 0)
         {
            this.Current -= this.PageNum;
            this.renderFriends(this.Current);
            this.renderDresses();
            this.updateLeftAndRight();
         }
      }
      
      private function onClickRight(evt:MouseEvent) : void
      {
         if(this.Current < this.Total * this.PageNum)
         {
            this.Current += this.PageNum;
            this.renderFriends(this.Current);
            this.renderDresses();
            this.updateLeftAndRight();
         }
      }
      
      private function updateLeftAndRight() : void
      {
         if(this.Current <= 0)
         {
            this.bg.leftBtn.visible = false;
            this.bg.leftBtn.removeEventListener(MouseEvent.CLICK,this.onClickLeft);
         }
         else
         {
            this.bg.leftBtn.visible = true;
            if(!this.bg.leftBtn.hasEventListener(MouseEvent.CLICK))
            {
               this.bg.leftBtn.addEventListener(MouseEvent.CLICK,this.onClickLeft);
            }
         }
         if(this.Current >= (this.Total - 1) * this.PageNum)
         {
            this.bg.rightBtn.visible = false;
            this.bg.rightBtn.removeEventListener(MouseEvent.CLICK,this.onClickRight);
         }
         else
         {
            this.bg.rightBtn.visible = true;
            if(!this.bg.rightBtn.hasEventListener(MouseEvent.CLICK))
            {
               this.bg.rightBtn.addEventListener(MouseEvent.CLICK,this.onClickRight);
            }
         }
      }
   }
}

