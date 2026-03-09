package com.game.modules.view.task
{
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol105")]
   public class AwardTipsItem extends Sprite
   {
      
      public var typeTF:TextField;
      
      public var numTF:TextField;
      
      private var loader:Loader;
      
      public function AwardTipsItem()
      {
         super();
      }
      
      public function showAward(type:String, num:int, fontSize:int = 20, fontColor:uint = 16776960) : void
      {
         this.typeTF.text = type;
         this.numTF.text = "+" + num;
         var textFormat:TextFormat = new TextFormat();
         textFormat.size = fontSize;
         textFormat.color = fontColor;
         this.typeTF.setTextFormat(textFormat);
         this.numTF.setTextFormat(textFormat);
      }
      
      public function showGoodAward(goodID:int, goodNum:int, fontSize:int = 20, fontColor:uint = 16776960) : void
      {
         this.typeTF.visible = false;
         this.numTF.text = " x " + goodNum;
         this.loader = new Loader();
         this.loader.load(new URLRequest("assets/tool/" + goodID + ".swf"));
         this.loader.scaleX = 0.5;
         this.loader.scaleY = 0.5;
         this.addChild(this.loader);
         this.loader.x = this.numTF.x - 30;
         this.loader.y = this.numTF.y - 30;
      }
      
      public function disport() : void
      {
         if(Boolean(this.loader))
         {
            this.loader.unloadAndStop();
            if(Boolean(this.loader.parent))
            {
               this.loader.parent.removeChild(this.loader);
            }
            this.loader = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

