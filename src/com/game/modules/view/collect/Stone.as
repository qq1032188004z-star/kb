package com.game.modules.view.collect
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.game.manager.MouseManager;
   import com.game.modules.view.MapView;
   import com.game.util.IdName;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import org.engine.core.GameSprite;
   
   public class Stone extends GameSprite
   {
      
      private static var GETSTUFFSTATUS:String = "getstuffstatus";
      
      private var stoneClip:MovieClip;
      
      private var callBack:Function;
      
      private var loader:Loader;
      
      private var _canCollectState:Boolean;
      
      private var lasttime:Number;
      
      private var _url:String;
      
      private var tempx:Number;
      
      private var tempy:Number;
      
      public function Stone(param:Object)
      {
         super();
         try
         {
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplement);
            this.x = param.x;
            this.y = param.y;
            this.sequenceID = param.sequenceID;
            this.spriteName = IdName.stone(param.sequenceID);
            this._url = param.url;
            ui = new Sprite();
         }
         catch(e:*)
         {
            O.o("实例化Stone -- > Stone");
         }
      }
      
      public function load(url:String, callBack:Function = null) : void
      {
         this.callBack = callBack;
         this.loader.load(new URLRequest(this._url));
      }
      
      public function update(param:Object) : void
      {
         try
         {
            if(param.hasOwnProperty("x"))
            {
               this.x = param.x;
            }
            if(param.hasOwnProperty("y"))
            {
               this.y = param.y;
            }
         }
         catch(e:*)
         {
         }
      }
      
      private function addChild(display:DisplayObject) : void
      {
         Sprite(ui).addChild(display);
      }
      
      private function removeChild(display:MovieClip) : void
      {
         if(Sprite(ui).contains(display))
         {
            Sprite(ui).removeChild(display);
            display.stop();
            display = null;
         }
      }
      
      override public function dispos() : void
      {
         this.loader.unloadAndStop();
         if(this.stoneClip != null)
         {
            this.stoneClip.stop();
            this.stoneClip.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickStone);
            this.stoneClip.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
            this.stoneClip.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            ToolTip.LooseDO(this.stoneClip);
            this.removeChild(this.stoneClip);
            this.stoneClip = null;
         }
         super.dispos();
      }
      
      private function onLoadComplement(evt:Event) : void
      {
         var cls:Class = null;
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplement);
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         if(domain == null)
         {
            return;
         }
         if(domain.hasDefinition("stone"))
         {
            cls = domain.getDefinition("stone") as Class;
            this.stoneClip = new cls() as MovieClip;
            if(this.stoneClip != null)
            {
               this.tempx = x + this.stoneClip.width / 2;
               this.tempy = y + this.stoneClip.height / 2;
               this.stoneClip.buttonMode = true;
               this.stoneClip.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickStone);
               this.stoneClip.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
               this.stoneClip.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
               this.addChild(this.stoneClip);
               GameData.instance.addEventListener(EventDefine.SIMULATED_CLICK_NPC,this.onSimulatedClick);
            }
         }
      }
      
      private function onSimulatedClick(event:MessageEvent) : void
      {
         var role:GameSprite = null;
         if(Boolean(event) && Boolean(event.body.hasOwnProperty("npc")))
         {
            if(sequenceID == event.body["npc"])
            {
               role = MapView.instance.findGameSprite(spriteName) as GameSprite;
               if(role && role == this && role["tempx"] == this.tempx && role["tempy"] == this.tempy)
               {
                  this.onClickStone(new MouseEvent(MouseEvent.CLICK));
               }
            }
         }
      }
      
      private function onClickStone(evt:MouseEvent) : void
      {
         var tx:int = 0;
         var point:Point = null;
         if(GameData.instance.playerData.collectStatus == 0)
         {
            evt.stopImmediatePropagation();
            MouseManager.getInstance().setCursor("");
            tx = this.tempx;
            if(MapView.instance.masterPerson.showData.moveFlag == 2)
            {
               tx = this.tempx + 50;
            }
            point = MapView.instance.masterPerson.ui.parent.localToGlobal(new Point(tx,this.tempy));
            ApplicationFacade.getInstance().dispatch(EventConst.ROLEMOVE,{
               "newx":point.x,
               "newy":point.y,
               "path":null
            });
            MapView.instance.masterPerson.moveto(point.x,point.y,this.afterClick);
         }
      }
      
      private function afterClick() : void
      {
         ApplicationFacade.getInstance().dispatch(EventConst.GETSTUFFSTATUS,{"stuffid":IdName.id(this.spriteName)});
         GameData.instance.playerData.collectStatus = 1;
         GameData.instance.dispatchEvent(new MessageEvent(EventDefine.AUTO_COLLECT_DIG));
      }
      
      private function onRollOut(evt:MouseEvent) : void
      {
         if(MouseManager.getInstance().cursorName == "chutou" || MouseManager.getInstance().cursorName == "tieqiao")
         {
            MouseManager.getInstance().setCursor("");
         }
      }
      
      private function onRollOver(evt:MouseEvent) : void
      {
         var itemlist:XML = XMLLocator.getInstance().tooldic[IdName.id(this.spriteName)];
         var stuffname:String = itemlist.name;
         var usetool:String = itemlist.usetool;
         ToolTip.BindDO(this.stoneClip,stuffname);
         if(usetool == "锄头")
         {
            MouseManager.getInstance().setCursor("chutou");
         }
         else if(usetool == "铁锹")
         {
            MouseManager.getInstance().setCursor("tieqiao");
         }
      }
   }
}

