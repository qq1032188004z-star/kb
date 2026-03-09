package com.game.modules.view.trump
{
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class TrumpTrainResult extends HLoaderSprite
   {
      
      private var body:Object;
      
      private var myloader:Loader;
      
      public function TrumpTrainResult()
      {
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.body = params;
         this.myloader = new Loader();
         this.url = "assets/fabao/trumptrainresult.swf";
      }
      
      override public function setShow() : void
      {
         bg.cacheAsBitmap = true;
         var i:int = 1;
         while(i <= 8)
         {
            bg["txt" + i].text = this.body["txt" + i];
            i++;
         }
         this.myloader = new Loader();
         this.myloader.x = 5;
         this.myloader.y = 175;
         this.myloader.scaleX = 2;
         this.myloader.scaleY = 2;
         addChild(this.myloader);
         this.myloader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterswf/" + this.body.iid + ".swf")));
         bg.btn0.addEventListener(MouseEvent.CLICK,this.onbtn0);
      }
      
      private function onbtn0(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      override public function disport() : void
      {
         CacheUtil.deleteObject(TrumpTrainResult);
         removeChild(this.myloader);
         this.myloader.unload();
         this.myloader = null;
         bg.btn0.removeEventListener(MouseEvent.CLICK,this.onbtn0);
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

