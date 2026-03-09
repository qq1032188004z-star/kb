package com.xygame.module.battle.util
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol254")]
   public class BattleAlert extends MovieClip
   {
      
      public static const battleAlertOk:String = "battlealertok";
      
      public static const battleAlertNo:String = "battlealertno";
      
      private var havenoBtn:Boolean;
      
      private var showString:String;
      
      private var showParent:*;
      
      private var callBackFunction:Function;
      
      public var okBtn:SimpleButton;
      
      public var noBtn:SimpleButton;
      
      public var failTitle:MovieClip;
      
      public var successEscap:MovieClip;
      
      public var message:TextField;
      
      public var catchFail:MovieClip;
      
      public var battleover:MovieClip;
      
      public var failEscap:MovieClip;
      
      private var vd:Object;
      
      private var titleType:int;
      
      private var haveokBtn:Boolean;
      
      private var isModule:Boolean;
      
      public function BattleAlert(showparent:*, showstring:String, nobtn:Boolean = false, okbtn:Boolean = true, module:Boolean = false, callFunction:Function = null, ttype:int = 0, v:Object = null)
      {
         super();
         this.gotoAndStop(this.titleType == 6 ? 2 : 1);
         this.showString = showstring;
         this.havenoBtn = nobtn;
         this.haveokBtn = okbtn;
         this.isModule = module;
         this.callBackFunction = callFunction;
         this.vd = v;
         this.titleType = ttype;
         if(showparent is Sprite || showparent is MovieClip)
         {
            this.showParent = showparent;
         }
         else
         {
            this.showParent = GetGameClass.AppFace.getInstance().retrieveViewLogic(GetGameClass.AppMapMediator.NAME).getViewComponent().stage;
         }
         this.addshow();
         this.initView();
      }
      
      private function removeshow() : void
      {
         if(this.showParent)
         {
            if(Boolean(this.showParent.contains(this)))
            {
               this.showParent.removeChild(this);
            }
            this.showParent = null;
         }
      }
      
      public function setTitle() : void
      {
         if(Boolean(this.failTitle))
         {
            this.failTitle.visible = this.titleType == 1;
         }
         if(Boolean(this.successEscap))
         {
            this.successEscap.visible = this.titleType == 2;
         }
         if(Boolean(this.failEscap))
         {
            this.failEscap.visible = this.titleType == 3;
         }
         if(Boolean(this.catchFail))
         {
            this.catchFail.visible = this.titleType == 4;
         }
         if(Boolean(this.battleover))
         {
            this.battleover.visible = this.titleType == 5;
         }
      }
      
      private function setokBtn() : void
      {
         this.noBtn.x = 422;
         this.okBtn.visible = false;
      }
      
      private function setnoBtn() : void
      {
         this.okBtn.x = 422;
         this.noBtn.visible = false;
      }
      
      public function destroy() : void
      {
         if(Boolean(this.okBtn))
         {
            this.okBtn.removeEventListener(MouseEvent.CLICK,this.onClickOkBtn);
            this.okBtn = null;
         }
         if(Boolean(this.noBtn))
         {
            this.noBtn.removeEventListener(MouseEvent.CLICK,this.onClickNoBtn);
            this.noBtn = null;
         }
         this.callBackFunction = null;
      }
      
      private function initView() : void
      {
         this.okBtn.addEventListener(MouseEvent.CLICK,this.onClickOkBtn);
         this.noBtn.addEventListener(MouseEvent.CLICK,this.onClickNoBtn);
         if(this.titleType != 6)
         {
            this.message.htmlText = this.showString;
            this.message.selectable = false;
            this.message.autoSize = TextFieldAutoSize.CENTER;
            if(!this.havenoBtn && this.haveokBtn)
            {
               this.setnoBtn();
            }
            if(this.havenoBtn && !this.haveokBtn)
            {
               this.setokBtn();
            }
            this.setTitle();
         }
         else if(this.titleType == 6)
         {
            try
            {
               this.vd;
               if(this.vd["win"] == 1)
               {
                  this.getChildAt(0)["successTitle"].visible = this.vd["win"] == 1;
               }
               else
               {
                  this.getChildAt(0)["failTitle"].visible = this.vd["win"] != 1;
               }
               this.getChildAt(0)["xianli"].htmlText = "" + this.vd["xianli"];
               this.getChildAt(0)["zhangong"].htmlText = "" + this.vd["zhangong"];
            }
            catch(e:Error)
            {
               trace("【BattleAlert战力战功赋值异常】" + e);
            }
         }
      }
      
      private function addshow() : void
      {
         if(this.showParent)
         {
            this.showParent.addChild(this);
         }
      }
      
      private function onClickNoBtn(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
         if(this.callBackFunction != null)
         {
            try
            {
               this.callBackFunction.call(this,"no");
            }
            catch(error:Error)
            {
               trace("回调错误" + error);
            }
         }
         this.removeshow();
         if(this.titleType == 6)
         {
            this.dispatchEvent(new Event(BattleAlert.battleAlertOk));
         }
         else
         {
            this.dispatchEvent(new Event(BattleAlert.battleAlertNo));
         }
         this.destroy();
      }
      
      private function onClickOkBtn(event:MouseEvent) : void
      {
         ;
         event.stopImmediatePropagation();
         if(this.callBackFunction != null)
         {
            try
            {
               this.callBackFunction.call(this,"ok");
            }
            catch(error:Error)
            {
               trace("回调错误" + error);
            }
         }
         this.removeshow();
         this.dispatchEvent(new Event(BattleAlert.battleAlertOk));
         this.destroy();
      }
      
      public function close() : void
      {
         this.removeshow();
         this.destroy();
      }
   }
}

