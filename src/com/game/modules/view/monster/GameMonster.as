package com.game.modules.view.monster
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.MouseManager;
   import com.game.modules.vo.ShowData;
   import com.game.util.IdName;
   import com.publiccomponent.loading.MaterialLib;
   import com.publiccomponent.loading.XMLLocator;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.ui.MouseCursor;
   import org.dress.ui.BaseBody;
   import org.engine.frame.FrameTimer;
   import org.engine.game.AdMoveSprite;
   
   public class GameMonster extends AdMoveSprite
   {
      
      public var vo:ShowData;
      
      private var body:BaseBody;
      
      private var pointer:int;
      
      private var step:int;
      
      private var iscontinue:int;
      
      private var kingLabel:DisplayObject;
      
      public function GameMonster(value:ShowData)
      {
         super();
         this.vo = value;
         ui = new Sprite();
         this.speed = 6;
         this.addKingLabel();
         this.init();
      }
      
      private function addKingLabel() : void
      {
         if(this.vo.mstateCount >= 30)
         {
            this.kingLabel = MaterialLib.getInstance().getMaterial("kingView") as DisplayObject;
            this.addChild(this.kingLabel);
         }
      }
      
      private function delKingLabel() : void
      {
         if(Boolean(this.kingLabel))
         {
            this.removeChild(this.kingLabel);
            this.kingLabel = null;
         }
      }
      
      private function addChild(display:DisplayObject) : void
      {
         (ui as Sprite).addChild(display);
      }
      
      override public function get sortY() : Number
      {
         return y + dymaicY;
      }
      
      private function removeChild(display:DisplayObject) : void
      {
         if(display != null && (ui as Sprite).contains(display))
         {
            (ui as Sprite).removeChild(display);
         }
         display = null;
      }
      
      private function init() : void
      {
         this.body = new BaseBody();
         this.addChild(this.body);
         if(Boolean(this.vo.mid))
         {
            this.body.load("assets/spirit/" + this.vo.mid + ".green","spirit",this.onLoadComplement);
         }
         ui.addEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
         ui.addEventListener(MouseEvent.MOUSE_MOVE,this.onRollOver);
         ui.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickMonster);
         var xml:XML = XMLLocator.getInstance().getSprited(this.vo.mid);
         if(Boolean(xml))
         {
            this.iscontinue = int(xml.iscontinue);
            if(this.iscontinue == 1)
            {
               FrameTimer.getInstance().addCallBack(this.render);
            }
         }
      }
      
      private function onRollOver(evt:MouseEvent) : void
      {
         if(this.body != null)
         {
            if(this.body.isActive(evt.stageX,evt.stageY))
            {
               ui["filters"] = [new GlowFilter(16777215,1,10,10,2,1,false,false)];
               Sprite(ui).buttonMode = true;
            }
            else
            {
               ui["filters"] = null;
               Sprite(ui).buttonMode = false;
            }
         }
      }
      
      private function onRollOut(evt:MouseEvent) : void
      {
         ui["filters"] = null;
         Sprite(ui).buttonMode = false;
      }
      
      private function onLoadComplement(params:Object) : void
      {
         this.step = params.step;
      }
      
      private function onClickMonster(evt:MouseEvent) : void
      {
         var params:Object = null;
         if(GameData.instance.playerData.giantId == GameData.instance.playerData.userId)
         {
            return;
         }
         if(this.body != null)
         {
            if(!this.body.isActive(evt.stageX,evt.stageY))
            {
               return;
            }
         }
         evt.stopImmediatePropagation();
         var cursorname:String = MouseManager.getInstance().cursorName;
         if(cursorname == null || cursorname.length == 0 || cursorname == "auto" || cursorname == MouseCursor.BUTTON)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.GETMONSTERINFO,this.vo.userId);
         }
         else
         {
            params = {};
            params.actionid = int(cursorname.slice(13,cursorname.length));
            params.destx = this.x;
            params.desty = this.y - 30;
            ApplicationFacade.getInstance().dispatch(EventConst.SENDACTION,params);
            MouseManager.getInstance().setCursor("");
         }
      }
      
      public function stop() : void
      {
         FrameTimer.getInstance().removeCallBack(this.render);
         this.runner.stop();
      }
      
      override public function onStop() : void
      {
         if(this.iscontinue == 0)
         {
            FrameTimer.getInstance().removeCallBack(this.render);
         }
      }
      
      override public function render() : void
      {
         if(this.body != null)
         {
            this.body.render(direction,this.pointer);
         }
         if(this.pointer < this.step - 1)
         {
            ++this.pointer;
         }
         else
         {
            this.pointer = 0;
         }
      }
      
      public function update(params:ShowData) : void
      {
         if(params != null)
         {
            this.vo = params;
            this.spriteName = IdName.pet(params.userId);
            this.x = params.x;
            this.y = params.y;
         }
      }
      
      override public function dispos() : void
      {
         FrameTimer.getInstance().removeCallBack(this.render);
         this.delKingLabel();
         if(ui != null)
         {
            ui["filters"] = null;
            ui.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickMonster);
            ui.removeEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
            ui.removeEventListener(MouseEvent.MOUSE_MOVE,this.onRollOver);
         }
         if(this.body != null)
         {
            this.body.dispos();
            this.body = null;
         }
         if(this.runner != null)
         {
            this.runner.stop();
         }
         this.runner = null;
         super.dispos();
      }
   }
}

