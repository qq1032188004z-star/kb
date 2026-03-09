package com.game.modules.view.monsteridentify
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.modules.view.MapView;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.net.URLRequest;
   import flash.utils.getQualifiedClassName;
   
   public class MonidAction extends HLoaderSprite
   {
      
      private var imgloader:Loader;
      
      private var actionMc:MovieClip;
      
      public var packIID:int;
      
      public var mondetail:Object;
      
      private var bitmap:Bitmap;
      
      public function MonidAction()
      {
         super();
         this.bitmap = new Bitmap();
         addChild(this.bitmap);
         this.imgloader = new Loader();
         this.url = "assets/monsteridentify/monsteridentify2.swf";
      }
      
      override public function setShow() : void
      {
         this.actionMc = bg;
         this.actionMc.actmc.stop();
         this.actionMc.addChild(this.imgloader);
         this.imgloader.x = 425;
         this.imgloader.y = 215;
         this.addframelistener();
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.packIID = params.packIID;
         this.mondetail = params.monsterdetail;
         this.addframelistener();
      }
      
      public function addframelistener() : void
      {
         this.bitmap.bitmapData = MapView.instance.getStaticBg();
         if(!this.actionMc)
         {
            return;
         }
         this.actionMc.actmc.addFrameScript(this.actionMc.actmc.totalFrames - 1,this.openMonIDResult);
         this.actionMc.actmc.addFrameScript(126,this.removeimg);
         this.imgloader.unload();
         this.imgloader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterswf/" + this.packIID + ".swf")));
         this.imgloader.scaleX = 1.2;
         this.imgloader.scaleY = 1.2;
         this.onImgLoadComplete();
      }
      
      private function removeimg() : void
      {
         this.actionMc.actmc.addFrameScript(126,null);
         this.imgloader.unload();
      }
      
      private function onImgLoadComplete() : void
      {
         if(this.actionMc != null)
         {
            this.actionMc.actmc.gotoAndPlay(1);
         }
      }
      
      private function openMonIDResult() : void
      {
         this.actionMc.actmc.gotoAndStop(1);
         this.actionMc.actmc.addFrameScript(this.actionMc.actmc.totalFrames - 1,null);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         var obj:Object = {
            "monsterdetail":this.mondetail,
            "packIID":this.packIID,
            "showX":0,
            "showY":0
         };
         ApplicationFacade.getInstance().dispatch(EventConst.OPEN_CACHE_VIEW,obj,null,getQualifiedClassName(MonidResult));
      }
      
      override public function disport() : void
      {
         CacheUtil.deleteObject(MonidAction);
         if(Boolean(this.parent) && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

