package com.publiccomponent.tips
{
   import com.publiccomponent.ui.NameLabelLoader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   
   public class ToolTipView extends Sprite
   {
      
      private var _tipMc:MovieClip;
      
      private var _tipInfo:String;
      
      private var _tipType:int = 1;
      
      private var _maxTxtWidth:Number = 200;
      
      private var loadList:Array = [];
      
      public function ToolTipView()
      {
         super();
         cacheAsBitmap = true;
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function setTipsInfo(tipInfo:String, type:int = 1) : void
      {
         var name:String = null;
         this._tipInfo = tipInfo;
         if(this._tipMc == null || this._tipType != type)
         {
            this.removeTipMc();
            this._tipType = type;
            this._tipMc = NameLabelLoader.instance.getMaterial("tips" + this._tipType) as MovieClip;
            if(Boolean(this._tipMc))
            {
               this.showTipClip();
            }
            else
            {
               name = "tips" + this._tipType;
               if(!this.checkLoadTip(name))
               {
                  this.loadList.push("tips" + this._tipType);
                  NameLabelLoader.instance.load("assets/tooltip/tips" + this._tipType + ".swf",this.tipClipBack,"tips" + this._tipType,true);
               }
            }
         }
         else
         {
            this._tipType = type;
            this.autoSizebyTips();
         }
      }
      
      private function tipClipBack(value:Object, name:String) : void
      {
         this.removeLoadTip(name);
         this.removeTipMc();
         this._tipMc = value as MovieClip;
         if(Boolean(this._tipMc))
         {
            this.showTipClip();
         }
      }
      
      private function removeLoadTip(value:String) : void
      {
         var i:int = 0;
         var temp:int = 0;
         var len:int = int(this.loadList.length);
         for(i = 0; i < len; i++)
         {
            if(value == this.loadList[i])
            {
               temp = i;
            }
         }
         this.loadList.splice(temp,1);
      }
      
      private function checkLoadTip(value:String) : Boolean
      {
         var i:int = 0;
         var len:int = int(this.loadList.length);
         for(i = 0; i < len; i++)
         {
            if(value == this.loadList[i])
            {
               return true;
            }
         }
         return false;
      }
      
      private function showTipClip() : void
      {
         this._tipMc.tipTxt.autoSize = TextFieldAutoSize.CENTER;
         this._tipMc.tipTxt.multiline = true;
         addChild(this._tipMc);
         this.autoSizebyTips();
      }
      
      private function autoSizebyTips() : void
      {
         this._tipMc.tipTxt.htmlText = this._tipInfo;
         this._tipMc.tipTxt.width = int(this._tipMc.tipTxt.textWidth + 10);
         if(this._tipMc.tipTxt.width > this._maxTxtWidth)
         {
            this._tipMc.tipTxt.width = this._maxTxtWidth;
            this._tipMc.tipTxt.wordWrap = true;
         }
         else
         {
            this._tipMc.tipTxt.wordWrap = false;
         }
         this._tipMc.bgMc.width = int(this._tipMc.tipTxt.width + 10);
         this._tipMc.bgMc.height = int(this._tipMc.tipTxt.height + 10);
         this._tipMc.tipTxt.x = int(this._tipMc.bgMc.x + 5);
         this._tipMc.tipTxt.y = int(this._tipMc.bgMc.y + 5);
      }
      
      private function removeTipMc() : void
      {
         if(Boolean(this._tipMc))
         {
            this._tipMc.stop();
            removeChild(this._tipMc);
            this._tipMc = null;
         }
      }
      
      override public function set x(value:Number) : void
      {
         if(value + width > 970)
         {
            super.x = 970 - width;
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
      
      public function set maxTipsWidth(value:Number) : void
      {
         this._maxTxtWidth = value;
      }
      
      public function get maxTipsWidth() : Number
      {
         return this._maxTxtWidth;
      }
      
      public function disport() : void
      {
         if(this._tipMc != null)
         {
            if(Boolean(this._tipMc.parent))
            {
               this._tipMc.parent.removeChild(this._tipMc);
            }
            this._tipMc = null;
         }
         if(this.parent != null)
         {
            this.parent.removeChild(this);
         }
      }
   }
}

