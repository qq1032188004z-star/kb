package com.game.modules.ai
{
   import com.game.locators.GameData;
   import com.game.modules.view.MapView;
   import com.game.util.FloatAlert;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class AlphaArea extends Sprite
   {
      
      public static var instance:AlphaArea = new AlphaArea();
      
      private var loader:Loader;
      
      private var lastClick:uint;
      
      public function AlphaArea()
      {
         super();
         this.mouseEnabled = false;
         this.loader = new Loader();
         addChild(this.loader);
      }
      
      public function loadAlpha(url:String) : void
      {
         if(url.indexOf("jiashicangmask.swf") != -1 || url.indexOf("yuguanghaomask.swf") != -1 || url.indexOf("freshmanmask") != -1)
         {
            if(Boolean(instance.parent))
            {
               if(instance.parent.contains(instance))
               {
                  instance.parent.setChildIndex(instance,instance.parent.numChildren - 1);
               }
            }
         }
         this.loader.load(new URLRequest(url));
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.alphaClick);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.alphaClick);
      }
      
      private function alphaClick(evt:Event) : void
      {
         if(GameData.instance.playerData.currentScenenId == 2102 || GameData.instance.playerData.currentScenenId == 8003 || GameData.instance.playerData.currentScenenId == 22012)
         {
            new FloatAlert().show(MapView.instance.stage,320,300,"此地危险，需要动动脑筋才能过去(⊙o⊙)哦");
         }
      }
      
      public function unLoadAlpha() : void
      {
         this.loader.unloadAndStop(false);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.alphaClick);
      }
   }
}

