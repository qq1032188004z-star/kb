package com.game.modules.view
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.util.FloatAlert;
   import com.game.util.HtmlUtil;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class HorseRoundView extends Sprite
   {
      
      private var shape:Sprite;
      
      private var loader:Loader;
      
      private var horseId:int;
      
      private var userId:int;
      
      private var horseTip:HorseTip;
      
      public function HorseRoundView(xCoord:Number, yCoord:Number)
      {
         super();
         this.x = xCoord;
         this.y = yCoord;
         this.shape = new Sprite();
         this.shape.graphics.beginFill(0,0);
         this.shape.graphics.drawCircle(0,0,32);
         this.shape.graphics.endFill();
         addChild(this.shape);
         this.loader = new Loader();
         this.loader.x = -32;
         this.loader.y = -32;
         addChild(this.loader);
         this.loader.mask = this.shape;
      }
      
      private function onClickHorse(evt:MouseEvent) : void
      {
         if(this.userId == GlobalConfig.userId)
         {
            if(GameData.instance.playerData.sceneId != 15000)
            {
               if(!MapView.instance.masterPerson.isInMoveAbleMoveArea(true))
               {
                  if(GameData.instance.playerData.currentScenenId == 5003 || GameData.instance.playerData.currentScenenId == 30007)
                  {
                     new FloatAlert().show(MapView.instance.stage,320,300,"这里不可以取消飞行坐骑哦");
                  }
                  else
                  {
                     new FloatAlert().show(MapView.instance.stage,320,300,"到地面才能取消坐骑哦");
                  }
                  return;
               }
               if(GameData.instance.playerData.currentScenenId == 5003 || GameData.instance.playerData.currentScenenId == 30007)
               {
                  new FloatAlert().show(MapView.instance.stage,320,300,"这里不可以取消飞行坐骑哦");
                  return;
               }
            }
            GameData.instance.playerData.horseID = 0;
            this.loader.unloadAndStop(false);
            this.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickHorse);
            this.buttonMode = false;
            ApplicationFacade.getInstance().dispatch(EventConst.CANCELHORSE);
            if(Boolean(this.parent.parent))
            {
               this.parent.parent.removeChild(this.parent);
            }
         }
      }
      
      public function loadHorse(id:int, userId:int) : void
      {
         var desc:String = null;
         var xml:XML = null;
         this.horseId = id;
         this.userId = userId;
         this.loader.unloadAndStop(false);
         if(id != 0)
         {
            desc = "";
            if(userId == GlobalConfig.userId)
            {
               desc += HtmlUtil.getHtmlText(12,"#FF0000","点击取消骑乘状态") + "\n";
               this.buttonMode = true;
               if(!this.hasEventListener(MouseEvent.MOUSE_DOWN))
               {
                  this.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickHorse);
               }
            }
            xml = XMLLocator.getInstance().getTool(id);
            if(xml != null)
            {
               desc += HtmlUtil.getHtmlText(12,"#000000","名称: ");
               desc += HtmlUtil.getHtmlText(12,"#FF0000",xml.name) + "\n";
               desc += HtmlUtil.getHtmlText(12,"#000000","描述: ");
               desc += HtmlUtil.getHtmlText(12,"#000000",xml.desc) + "\n";
            }
            if(userId == GlobalConfig.userId || id >= 610001 && id <= 610012)
            {
               ToolTip.setDOInfo(this,desc);
            }
            this.loader.unloadAndStop(false);
            this.loader.load(new URLRequest("assets/tool/" + id + ".swf"));
         }
      }
      
      public function setHorseData(obj:Object) : void
      {
         if(Boolean(this.horseTip))
         {
            this.horseTip.dispos();
         }
         if(obj.iid >= 610001 && obj.iid <= 610012)
         {
            return;
         }
         ToolTip.LooseDO(this);
         this.horseTip = new HorseTip();
         this.horseTip.visible = false;
         stage.addChild(this.horseTip);
         this.horseTip.setData(obj);
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
      }
      
      private function onRollOver(evt:MouseEvent) : void
      {
         this.horseTip.x = 430;
         this.horseTip.y = 380;
         this.horseTip.visible = true;
      }
      
      private function onRollOut(evt:MouseEvent) : void
      {
         this.horseTip.visible = false;
      }
      
      public function dispos() : void
      {
         this.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickHorse);
         this.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         ToolTip.LooseDO(this);
         if(Boolean(this.loader))
         {
            if(Boolean(this.loader.parent))
            {
               this.loader.parent.removeChild(this.loader);
            }
            this.loader.unloadAndStop(false);
            this.loader = null;
         }
         if(Boolean(this.shape))
         {
            this.shape.graphics.clear();
            if(Boolean(this.shape.parent))
            {
               this.shape.parent.removeChild(this.shape);
            }
            this.shape = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

