package com.game.modules.view.action
{
   import com.core.observer.MessageEvent;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.control.action.ActionControl;
   import com.game.modules.view.WindowLayer;
   import com.game.util.FloatAlert;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class ActionView extends HLoaderSprite
   {
      
      public static const SENDACTIONID:String = "sendactionid";
      
      private var xml:XML;
      
      private var urlLoader:URLLoader;
      
      private var xmlURL:String;
      
      private var list:TileList;
      
      private var dataArr:Array = [];
      
      public function ActionView()
      {
         super();
         this.urlLoader = new URLLoader();
         this.urlLoader.addEventListener(Event.COMPLETE,this.onLoadedXML);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         this.xmlURL = URLUtil.getSvnVer("config/actiontip.xml");
         this.urlLoader.load(new URLRequest(this.xmlURL));
      }
      
      private function onLoadedXML(evt:Event) : void
      {
         this.urlLoader.removeEventListener(Event.COMPLETE,this.onLoadedXML);
         this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         this.xml = new XML(this.urlLoader.data);
         this.urlLoader = null;
         this.url = "assets/action/actionView.swf";
         ApplicationFacade.getInstance().registerViewLogic(new ActionControl(this));
      }
      
      private function ioError(evt:Event) : void
      {
         this.urlLoader.load(new URLRequest(this.xmlURL));
      }
      
      override public function initParams(params:Object = null) : void
      {
         if(bg != null)
         {
            this.initEvents();
            this.setData();
         }
      }
      
      override public function setShow() : void
      {
         this.bg.cacheAsBitmap = true;
         this.list = new TileList(15,7);
         this.list.build(3,2,31.7,31.4,7,7,ActionItem);
         bg.addChild(this.list);
         this.initEvents();
         this.setData();
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onRollOut);
      }
      
      private function setData(type:int = 1) : void
      {
         var xmllist:XMLList = null;
         var xml:XML = null;
         var obj:Object = null;
         this.dataArr = [];
         xmllist = this.xml.children().(@id == type)[0].children() as XMLList;
         for each(xml in xmllist)
         {
            obj = {};
            obj.id = xml.@id;
            obj.tip = xml.tip;
            this.dataArr.push(obj);
         }
         this.initList();
      }
      
      private function initList() : void
      {
         this.list.dataProvider = this.dataArr;
      }
      
      private function initEvents() : void
      {
         this.list.addEventListener(ItemClickEvent.ITEMCLICKEVENT,this.onClickList,true);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      private function removeEvents() : void
      {
         if(Boolean(this.list) && this.list.hasEventListener(ItemClickEvent.ITEMCLICKEVENT))
         {
            this.list.removeEventListener(ItemClickEvent.ITEMCLICKEVENT,this.onClickList,true);
         }
         if(this.hasEventListener(MouseEvent.ROLL_OUT))
         {
            this.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         }
         if(Boolean(stage) && stage.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onRollOut);
         }
      }
      
      private function onClickList(evt:ItemClickEvent) : void
      {
         if(GameData.instance.playerData.bodyID != 0)
         {
            new FloatAlert().show(WindowLayer.instance.stage,300,300,"变身状态下不能做这些动作哦！");
            return;
         }
         var data:Object = evt.params;
         this.dispatchEvent(new MessageEvent(SENDACTIONID,{"actionId":data.id}));
         this.disport();
      }
      
      private function onRollOut(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      override public function disport() : void
      {
         this.removeEvents();
         this.dataArr = [];
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

