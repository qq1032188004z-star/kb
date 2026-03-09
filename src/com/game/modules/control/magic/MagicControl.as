package com.game.modules.control.magic
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.EventManager;
   import com.game.manager.MouseManager;
   import com.game.modules.action.GameSpriteAction;
   import com.game.modules.view.MapView;
   import com.game.modules.view.magic.MagicView;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.events.ItemClickEvent;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class MagicControl extends ViewConLogic
   {
      
      public static const NANME:String = "magicmediator";
      
      public function MagicControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
         EventManager.attachEvent(this.view,Event.ADDED_TO_STAGE,this.onAddToStage);
         this.onAddToStage(null);
      }
      
      private function onAddToStage(evt:Event) : void
      {
         this.view.ininEvents();
         EventManager.attachEvent(this.view,EventConst.CHANGEFISH,this.cheakChangeFish);
         EventManager.attachEvent(this.view,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         EventManager.attachEvent(this.view,MagicView.QUANPINGMAGIC,this.onSendQuanPing);
         this.sendMessage(MsgDoc.OP_CLIENT_GETMAGICINDEX.send);
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.view.removeEvents();
         EventManager.removeEvent(this.view,EventConst.CHANGEFISH,this.cheakChangeFish);
         EventManager.removeEvent(this.view,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         EventManager.removeEvent(this.view,MagicView.QUANPINGMAGIC,this.onSendQuanPing);
      }
      
      public function get view() : MagicView
      {
         return this.getViewComponent() as MagicView;
      }
      
      private function clickAction(evt:ItemClickEvent) : void
      {
         var actionid:int = (evt.params as int) + 1;
         MouseManager.getInstance().setCursor("CursorTool200" + actionid);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.GETMAGICINDEXBACK,this.getMagicIndexBack],[EventConst.UPDATE_MAGIC_NUM,this.updateMagicNum]];
      }
      
      private function cheakChangeFish(evt:MessageEvent) : void
      {
         var rect:Rectangle = new Rectangle(300,248,120,85);
         if(rect.contains(MapView.instance.masterPerson.x,MapView.instance.masterPerson.y) && GameData.instance.playerData.currentScenenId == 40001)
         {
            if(GameData.instance.playerData.isInChange != 0)
            {
               sendMessage(MsgDoc.OP_CLIENT_SEND_ACTION.send,0,[GlobalConfig.userId,0,0,0,1,0]);
            }
            GameSpriteAction.instance.changeAndMove(MapView.instance.masterPerson,220,212,-3);
         }
         else
         {
            new Alert().show("在傲来海岸的小溪碎石上才能使用哦 ");
         }
      }
      
      private function onSendQuanPing(evt:MessageEvent) : void
      {
         var id:int = int(evt.body.id);
         var type:int = int(evt.body.type);
         var userId:int = GlobalConfig.userId;
         if(type == 2)
         {
            this.sendMessage(MsgDoc.OP_CLIENT_SEND_ACTION.send,1,[userId,id,0,0,2,userId]);
         }
         else
         {
            this.sendMessage(MsgDoc.OP_CLIENT_SEND_ACTION.send,1,[userId,id,0,0,1,userId]);
         }
      }
      
      private function getMagicIndex(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_GETMAGICINDEX.send);
      }
      
      private function getMagicIndexBack(evt:MessageEvent) : void
      {
         var params:Object = null;
         if(Boolean(this.view))
         {
            params = evt.body;
            this.view.setMagicIndex(params.magicArr,params.changeArr);
         }
      }
      
      private function updateMagicNum(evt:MessageEvent) : void
      {
         this.view.updatMagicNum(evt.body);
      }
   }
}

