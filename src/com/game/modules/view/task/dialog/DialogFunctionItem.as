package com.game.modules.view.task.dialog
{
   import com.game.locators.GameData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class DialogFunctionItem extends Sprite
   {
      
      public var mc:MovieClip;
      
      public var personSayTxt:TextField;
      
      public var flag:int = 0;
      
      public var effectName:String = "";
      
      public var effectID:Array;
      
      public var effectType:int = 0;
      
      private var callback:Function;
      
      private var highlightFormat:TextFormat = new TextFormat("宋体",14,16478227);
      
      private var tf:TextFormat = new TextFormat("宋体",14,16776960,null,null,null,null,null,TextFormatAlign.CENTER,null,null,null,4);
      
      public function DialogFunctionItem(cls:Class, str:Object, flag:int, callback:Function, eName:String = "", eID:Array = null, eType:int = 0)
      {
         super();
         this.flag = flag;
         this.callback = callback;
         this.effectName = eName;
         this.effectID = eID;
         this.effectType = eType;
         this.highlightFormat.letterSpacing = 1;
         this.tf.letterSpacing = 1;
         this.mc = new cls() as MovieClip;
         this.mc.gotoAndStop(1);
         this.addChild(this.mc);
         this.mc.width = 200;
         this.mc.x = 0;
         this.mc.y = 0;
         this.personSayTxt = new TextField();
         this.addChild(this.personSayTxt);
         this.personSayTxt.width = this.mc.width - 15;
         this.personSayTxt.x = 7.7;
         this.personSayTxt.y = 2.2;
         this.personSayTxt.text = "";
         this.personSayTxt.defaultTextFormat = this.tf;
         this.personSayTxt.wordWrap = true;
         this.personSayTxt.multiline = true;
         this.mouseChildren = false;
         this.buttonMode = true;
         this.personSayTxt.htmlText = str.content;
         if(Boolean(str.hasOwnProperty("indexs")) && str.indexs.length > 0)
         {
            this.showEffect(str.indexs as Array);
         }
         this.personSayTxt.height = 20 * this.personSayTxt.numLines;
         this.mc.height += 20 * (this.personSayTxt.numLines - 1);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.addEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      private function showEffect(list:Array) : void
      {
         var i:int = 0;
         var len:int = int(list.length);
         for(i = 0; i < len; i++)
         {
            this.personSayTxt.setTextFormat(this.highlightFormat,list[i] + 1,list[i] + 1 + GameData.instance.playerData.userName.length);
         }
      }
      
      private function onMouseOver(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.gotoAndStop(2);
      }
      
      private function onMouseOut(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.mc.gotoAndStop(1);
      }
      
      private function onMouseClick(evt:MouseEvent) : void
      {
         if(this.callback != null)
         {
            this.callback.apply(null,[this.flag,this.effectName,this.effectID,this.effectType]);
         }
      }
      
      public function dispos() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         this.mc.stop();
         this.removeChild(this.mc);
         this.removeChild(this.personSayTxt);
         this.personSayTxt = null;
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         this.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
   }
}

