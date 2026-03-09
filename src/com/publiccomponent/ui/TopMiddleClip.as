package com.publiccomponent.ui
{
   import com.publiccomponent.tips.MainUIToolTip;
   import com.publiccomponent.util.ColorUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   public class TopMiddleClip extends Sprite
   {
      
      public var clearClip:MovieClip;
      
      public var voiceClip:MovieClip;
      
      public var placeTxt:TextField;
      
      public var topMask:MovieClip;
      
      public var effectName:MovieClip;
      
      public var effectMc:MovieClip;
      
      private var paperhorseXml:XML;
      
      private var paperHorseSid:uint;
      
      public var onlineTime:MovieClip;
      
      private var tid:int;
      
      private var lastX:Number;
      
      private var tid2:int;
      
      public var topMiddleList:Dictionary = new Dictionary();
      
      public var mcclip:MovieClip;
      
      private var f:ColorMatrixFilter = new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0]);
      
      public function TopMiddleClip()
      {
         super();
      }
      
      public function init(clip:MovieClip, dataList:Array) : void
      {
         this.initTips(clip,dataList);
         clip.cacheAsBitmap = true;
         this.mcclip = clip;
         this.addChild(clip);
         clip.topMask.visible = false;
         clip.topMask.mouseEnabled = false;
         clip.topMask.mouseChildren = false;
         this.placeTxt = clip.placeTxt;
         this.clearClip = clip.clearClip;
         this.clearClip.gotoAndStop(1);
         this.voiceClip = clip.voiceClip;
         this.voiceClip.gotoAndStop(1);
         this.topMask = clip.topMask;
         this.topMask.visible = false;
         this.effectName = clip.effectName;
         this.effectName.buttonMode = true;
         this.effectMc = clip.effectMc;
         this.effectMc.mouseChildren = false;
         this.effectMc.mouseEnabled = false;
         this.hideEffect();
      }
      
      private function initTips(clip:MovieClip, dataList:Array) : void
      {
         var data:Array = null;
         var len:int = int(dataList.length);
         var name:String = "";
         for(var i:int = 0; i < len; i++)
         {
            data = [];
            name = dataList[i].name;
            if(Boolean(clip[name]))
            {
               this.topMiddleList[name] = {
                  "item":clip[name],
                  "showPhares":dataList[i].showPhares,
                  "tips":dataList[i].desc
               };
            }
            if(dataList[i].desc != "")
            {
               MainUIToolTip.showTips(clip[name],dataList[i].desc,4,1);
            }
         }
      }
      
      public function showPlayer($value:Boolean) : void
      {
         if($value)
         {
            this.clearClip.gotoAndStop(1);
         }
         else
         {
            this.clearClip.gotoAndStop(2);
         }
      }
      
      public function disableUIByName(uiName:String) : void
      {
         if(Boolean(this.hasOwnProperty(uiName)) && this[uiName] != null)
         {
            if(Boolean(this[uiName].hasOwnProperty("currentFrame")))
            {
               this[uiName]["mouseEnabled"] = false;
               this[uiName]["filters"] = [this.f];
               this[uiName]["gotoAndStop"](2);
            }
            else
            {
               this[uiName]["filters"] = [this.f];
               this[uiName]["mouseEnabled"] = false;
            }
         }
      }
      
      public function enableUIByName(uiName:String) : void
      {
         if(Boolean(this.hasOwnProperty(uiName)) && this[uiName] != null)
         {
            if(Boolean(this[uiName].hasOwnProperty("currentFrame")))
            {
               this[uiName]["mouseEnabled"] = true;
               this[uiName]["gotoAndStop"](1);
               this[uiName]["filters"] = null;
            }
            else
            {
               this[uiName]["filters"] = null;
               this[uiName]["mouseEnabled"] = true;
            }
         }
      }
      
      public function hideUIByName(uiName:String) : void
      {
         if(Boolean(this.hasOwnProperty(uiName)) && this[uiName] != null)
         {
            this[uiName]["visible"] = false;
         }
      }
      
      public function showUIByName(uiName:String) : void
      {
         if(Boolean(this.hasOwnProperty(uiName)) && this[uiName] != null)
         {
            this[uiName]["visible"] = true;
         }
      }
      
      public function enableMask() : void
      {
         this.topMask.visible = true;
      }
      
      public function disableMask() : void
      {
         this.topMask.visible = false;
      }
      
      public function setMsgEffect(name:String, tipMsg:String = "") : void
      {
         this.mcclip.effectName.nameTxt.text = name;
         this.mcclip.effectMc.tipTxt.text = tipMsg;
         var txt:TextField = this.mcclip.effectMc.tipTxt;
         txt.width = txt.textWidth + 10;
         this.mcclip.effectMc.tipBg.width = txt.width + 10;
         this.mcclip.effectMc.x = (970 - this.mcclip.effectMc.width) / 2;
      }
      
      public function showEffect() : void
      {
         this.mcclip.effectMc.visible = true;
         this.mcclip.effectMc.y = 2;
      }
      
      public function hideEffect() : void
      {
         this.mcclip.effectMc.visible = false;
         this.mcclip.effectMc.y = -100;
      }
      
      public function setOnlineTime(time:int) : void
      {
         var min:int = Math.floor(time / 60);
         var sec:int = time % 60;
         var min1:int = Math.floor(min / 10);
         var min2:int = min % 10;
         var sec1:int = Math.floor((time - 60 * min) / 10);
         var sec2:int = (time - 60 * min) % 10;
         this.onlineTime.min1.gotoAndStop(min1 + 1);
         this.onlineTime.min2.gotoAndStop(min2 + 1);
         this.onlineTime.sec1.gotoAndStop(sec1 + 1);
         this.onlineTime.sec2.gotoAndStop(sec2 + 1);
      }
      
      public function clearClipEnabled(bool:Boolean) : void
      {
         this.clearClip.mouseEnabled = this.clearClip.mouseChildren = bool;
         if(bool)
         {
            this.clearClip.filters = null;
         }
         else
         {
            this.clearClip.filters = ColorUtil.getColorMatrixFilterGray();
         }
      }
   }
}

