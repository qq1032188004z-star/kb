package com.game.modules.view.stgcopy
{
   import com.game.modules.view.MapView;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import org.dress.ui.RoleFace;
   import phpcon.PhpConnection;
   import phpcon.PhpEvent;
   import phpcon.PhpEventConst;
   
   public class StgCopyValue extends HLoaderSprite
   {
      
      private var data:Object;
      
      private var urlloader:URLLoader;
      
      private var xmldata:XML;
      
      private var titlexml:XMLList;
      
      private var roleFace:RoleFace;
      
      private var shapeMask:Shape;
      
      private var checkParams:Object;
      
      public function StgCopyValue()
      {
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         this.data = params.data;
         this.urlloader = new URLLoader();
         this.urlloader.addEventListener(Event.COMPLETE,this.onURLComplete);
         this.urlloader.load(new URLRequest(URLUtil.getSvnVer("config/title.xml")));
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         PhpConnection.instance().addEventListener(PhpEventConst.MY_SCORE,this.nomyrank);
         var urlvar:URLVariables = new URLVariables();
         urlvar.uid = this.data.id;
         PhpConnection.instance().getdata("stg_explorer/get_my_score.php",urlvar);
         this.bg.closebtn.addEventListener(MouseEvent.CLICK,this.onclose);
         this.inithead();
         this.setdata();
      }
      
      private function onURLComplete(evt:Event) : void
      {
         this.xmldata = new XML(this.urlloader.data);
         this.titlexml = this.xmldata.children();
         this.urlloader.removeEventListener(Event.COMPLETE,this.onURLComplete);
         this.urlloader = null;
         this.url = "assets/material/STGvalue.swf";
      }
      
      private function inithead() : void
      {
         this.roleFace = new RoleFace(395,294,4);
         this.roleFace.mouseEnabled = false;
         this.shapeMask = new Shape();
         this.shapeMask.graphics.beginFill(16711680,1);
         this.shapeMask.graphics.drawRect(359,207,73,68);
         this.shapeMask.graphics.endFill();
         this.bg.addChild(this.roleFace);
         this.roleFace.visible = true;
         this.bg.setChildIndex(this.roleFace,this.bg.numChildren - 1);
         this.bg.addChild(this.shapeMask);
         this.roleFace.mask = this.shapeMask;
         this.setHeadImage();
      }
      
      private function setHeadImage() : void
      {
         this.checkParams = {};
         this.checkParams.roleType = MapView.instance.masterPerson.showData.roleType;
         this.checkParams.clothId = MapView.instance.masterPerson.showData.clothId;
         this.checkParams.footId = MapView.instance.masterPerson.showData.footId;
         this.checkParams.hatId = MapView.instance.masterPerson.showData.hatId;
         this.checkParams.faceId = MapView.instance.masterPerson.showData.faceId;
         this.checkParams.wingId = MapView.instance.masterPerson.showData.wingId;
         this.roleFace.setRole(this.checkParams);
      }
      
      private function setdata() : void
      {
         bg.nametxt.text = this.data.username;
         bg.idtxt.text = this.data.id;
         bg.titletxt.text = String(this.titlexml.(@id == int(data.title)).txt);
         bg.nowtxt.text = this.data.now;
         bg.totaltxt.text = this.data.total;
      }
      
      private function onclose(evt:MouseEvent) : void
      {
         this.bg.closebtn.removeEventListener(MouseEvent.CLICK,this.onclose);
         this.disport();
      }
      
      private function nomyrank(evt:PhpEvent) : void
      {
         bg.ranktxt.text = evt.data.done + "";
      }
      
      override public function disport() : void
      {
         PhpConnection.instance().removeEventListener(PhpEventConst.MY_SCORE,this.nomyrank);
         if(Boolean(this.roleFace))
         {
            this.roleFace.dispos();
         }
         CacheUtil.deleteObject(StgCopyValue);
         this.data = null;
         this.roleFace = null;
         this.shapeMask = null;
         this.checkParams = null;
         this.xmldata = null;
         this.titlexml = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.disport();
      }
   }
}

