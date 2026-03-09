package com.game.modules.view
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.util.TimeTransform;
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol504")]
   public class HorseTip extends Sprite
   {
      
      public var nameTxt:TextField;
      
      public var quailTxt:TextField;
      
      public var timeTxt:TextField;
      
      public var strTxt:TextField;
      
      public var strClip:MovieClip;
      
      public var speedTxt:TextField;
      
      public var qinTxt:TextField;
      
      public var feedBtn:SimpleButton;
      
      public var selltimetxt:TextField;
      
      private var loader:Loader;
      
      private var userId:int;
      
      private var params:Object;
      
      public var ostime:int;
      
      public function HorseTip()
      {
         super();
         this.feedBtn.visible = false;
         this.cacheAsBitmap = true;
         this.loader = new Loader();
         this.loader.y = 7;
         this.loader.x = 7;
         addChild(this.loader);
         this.strClip.gotoAndStop(1);
      }
      
      public function setData(obj:Object, userId:int = 0) : void
      {
         if(!obj.hasOwnProperty("date"))
         {
            return;
         }
         this.params = obj;
         this.userId = userId;
         this.nameTxt.text = obj.name;
         this.quailTxt.text = "";
         this.qinTxt.text = obj.qmd;
         this.speedTxt.text = "+" + (obj.sp - 100) + "%";
         this.strTxt.text = obj.hp + "/" + obj.jhp;
         var frame:int = Math.round(obj.hp * 100 / obj.jhp);
         if(frame <= 0)
         {
            frame = 1;
         }
         if(frame >= 100)
         {
            frame = 100;
         }
         this.caclu(obj.jhp + obj.sp * 750 / 100);
         this.strClip.gotoAndStop(frame);
         this.timeTxt.text = TimeTransform.getInstance().transDate(obj.date);
         if(obj.cssj == 0 || !obj.hasOwnProperty("cssj") || obj.cssj == null)
         {
            this.selltimetxt.text = "";
         }
         else
         {
            this.ostime = GameData.instance.playerData.systemTimes;
            this.selltimetxt.text = TimeTransform.getInstance().transToDHM(obj.cssj - this.ostime) + "后出售";
         }
         this.loader.unloadAndStop(false);
         var url:String = URLUtil.getSvnVer("assets/tool/" + obj.iid + ".swf");
         this.loader.load(new URLRequest(url));
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         if(!this.hasEventListener(MouseEvent.ROLL_OUT))
         {
            this.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         }
         if(this.userId == GlobalConfig.userId)
         {
            this.feedBtn.visible = true;
            if(!this.hasEventListener(MouseEvent.MOUSE_DOWN))
            {
               this.feedBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.feedAnimal);
            }
         }
      }
      
      private function feedAnimal(evt:MouseEvent) : void
      {
         this.visible = false;
         var sendBody:Object = {
            "url":"assets/module/HorseTool.swf",
            "xCoord":230,
            "yCoord":50,
            "params":this.params
         };
         ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
            "url":"assets/module/HorseTool.swf",
            "xCoord":230,
            "yCoord":50,
            "moduleParams":this.params
         });
         this.visible = false;
      }
      
      private function onRollOut(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.visible = false;
      }
      
      override public function set x(value:Number) : void
      {
         if(value + width > 970)
         {
            super.x = value - width;
         }
         else
         {
            super.x = value;
         }
      }
      
      override public function set y(value:Number) : void
      {
         if(value + height > 570)
         {
            super.y = 570 - height;
         }
         else
         {
            super.y = value;
         }
      }
      
      public function dispos() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function caclu(total:Number) : void
      {
         if(total >= 2050)
         {
            this.quailTxt.text = "上古神兽";
         }
         else if(total >= 1872)
         {
            this.quailTxt.text = "绝世名骑";
         }
         else if(total >= 1694)
         {
            this.quailTxt.text = "风驰云卷";
         }
         else if(total >= 1516)
         {
            this.quailTxt.text = "日行千里";
         }
         else
         {
            this.quailTxt.text = "健步如飞";
         }
      }
   }
}

