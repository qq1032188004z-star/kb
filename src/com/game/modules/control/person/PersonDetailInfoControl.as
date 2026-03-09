package com.game.modules.control.person
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.MsgDoc;
   import com.game.manager.AlertManager;
   import com.game.manager.EventManager;
   import com.game.modules.view.person.PersonInfoDetailView;
   import flash.events.Event;
   
   public class PersonDetailInfoControl extends ViewConLogic
   {
      
      public static const NAME:String = "personinfodet";
      
      public function PersonDetailInfoControl(viewComponent:Object)
      {
         super(NAME,viewComponent);
         EventManager.attachEvent(this.view,Event.ADDED_TO_STAGE,this.onAddToStage);
         EventManager.attachEvent(this.view,PersonInfoDetailView.SHOWTITLE,this.onshowtitle);
         EventManager.attachEvent(this.view,PersonInfoDetailView.CHANGNAME,this.onChagePlayerName);
         EventManager.attachEvent(this.view,PersonInfoDetailView.CHANGEBEIZHU,this.onChangeBeiZhu);
         EventManager.attachEvent(this.view,EventConst.GET_BADGE_DATA,this.onGetBadgeData);
         this.onAddToStage(null);
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.GETPERSONINFOBACK,this.getDetailInfoBack],[EventConst.SHOWTITLEBACK,this.onshowtitleback],[EventConst.CHANGEPLAYERNAMEBACK,this.onChangePlayerNameBack],[EventConst.MODYFY_BEZHU_BACK,this.onModifyBeiZhuBack],[EventConst.GET_BADGE_DATA_BACK,this.onGetBadgeDataBack],[EventConst.S_TITLE_UPDATE_SHOW,this.onUpdateShowHandler]];
      }
      
      private function onAddToStage(evt:Event) : void
      {
         this.view.initEvents();
         EventManager.attachEvent(this.view,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         if(this.view.checkParams != null)
         {
            if(this.view.checkParams.userId == 0)
            {
               return;
            }
            sendMessage(MsgDoc.OP_CLIENT_REQ_PLAYERINFO.send,uint(this.view.checkParams.userId),[this.view.checkParams.isOnline]);
         }
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         this.view.removeEvents();
         EventManager.removeEvent(this.view,Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      public function get view() : PersonInfoDetailView
      {
         return this.getViewComponent() as PersonInfoDetailView;
      }
      
      private function getDetailInfoBack(evt:MessageEvent) : void
      {
         this.view.setData(evt.body);
      }
      
      private function onshowtitle(evt:MessageEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_SHOWTITLE.send);
      }
      
      private function onUpdateShowHandler(e:MessageEvent) : void
      {
         var uid:int = 0;
         var index:int = 0;
         var params:Object = e.body;
         if(params.index == 1 || params.index == 3)
         {
            uid = int(params.uid);
            index = int(params.id);
            this.view.setShowTitle(uid,index);
         }
      }
      
      private function onshowtitleback(evt:MessageEvent) : void
      {
         this.view.showtitleback(evt.body);
      }
      
      private function onChagePlayerName(event:MessageEvent) : void
      {
         var userName:String = event.body.userName;
         this.sendMessage(MsgDoc.OP_CLIENT_CHANGNAME.send,0,[0,userName]);
      }
      
      private function onChangeBeiZhu(event:MessageEvent) : void
      {
         var userBeiZhu:String = event.body.userBeizhu;
         this.sendMessage(MsgDoc.OP_CLIENT_SET_FRIEND_NAME.send,event.body.uid,[userBeiZhu]);
      }
      
      private function onModifyBeiZhuBack(evt:MessageEvent) : void
      {
         this.view.onModifyBeiZhuBack();
      }
      
      private function onChangePlayerNameBack(event:MessageEvent) : void
      {
         if(event.body.param == 0)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1055,
               "flag":5
            });
         }
         else if(event.body.param == -1)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1055,
               "flag":6
            });
         }
         else if(event.body.param == -2)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1055,
               "flag":7
            });
         }
         if(Boolean(this.view))
         {
            this.view.changNameBack(event.body.param);
         }
      }
      
      private function onGetBadgeData(evt:MessageEvent) : void
      {
         sendMessage(MsgDoc.OP_CLIENT_REQ_BADGE_DATA.send,int(evt.body));
      }
      
      private function onGetBadgeDataBack(evt:MessageEvent) : void
      {
         this.view.onGetBadgeDataBack(evt.body);
      }
   }
}

