package com.game.util
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.manager.EventManager;
   import com.game.modules.view.WindowLayer;
   import com.publiccomponent.alert.Alert;
   import flash.events.Event;
   import org.green.server.core.GreenSocket;
   import org.green.server.events.MsgEvent;
   import org.green.server.manager.SocketManager;
   
   public class FarmServerUtil
   {
      
      private static var _instance:FarmServerUtil;
      
      public static const REQ_MONSTER_HOLD:Object = {
         "send":3145779,
         "back":1331251
      };
      
      public static const REQ_MONSTER_INFO:Object = {
         "send":3145781,
         "back":1331253
      };
      
      private var shortSocket:GreenSocket;
      
      private var host:String = GlobalConfig.farmserver;
      
      private var port:int = GlobalConfig.farmport;
      
      private var mOpcode:uint;
      
      private var mParams:int;
      
      private var mBody:Array;
      
      private var callBackHandler:Function;
      
      public function FarmServerUtil()
      {
         super();
         this.init();
      }
      
      public static function get Instance() : FarmServerUtil
      {
         if(_instance == null)
         {
            _instance = new FarmServerUtil();
         }
         return _instance;
      }
      
      private function init() : void
      {
         if(!this.shortSocket)
         {
            this.shortSocket = SocketManager.getGreenSocket("farm0");
            EventManager.attachEvent(this.shortSocket,"connectted",this.onConnected);
            EventManager.attachEvent(this.shortSocket,"connection_error",this.onCloseSocket);
            EventManager.attachEvent(this.shortSocket,FarmServerUtil.REQ_MONSTER_HOLD.back.toString(),this.onReqMonsterHoldBack);
            EventManager.attachEvent(this.shortSocket,FarmServerUtil.REQ_MONSTER_INFO.back.toString(),this.onReqMonsterInfoBack);
         }
      }
      
      public function sendCmd(code:uint, body:Array = null, callback:Function = null) : void
      {
         this.mOpcode = code;
         this.mParams = GameData.instance.playerData.userId;
         this.mBody = body;
         this.callBackHandler = callback;
         O.o("FarmServerUtil/sendCmd()","host = " + this.host,"port = " + this.port,"code = " + this.mOpcode.toString(16));
         this.shortSocket.connect(this.host,this.port);
      }
      
      private function onConnected(evt:Event) : void
      {
         O.o("FarmServerUtil/onConnected()","code = " + this.mOpcode.toString(16));
         this.shortSocket.sendCmd(this.mOpcode,this.mParams,this.mBody);
         this.mOpcode = 0;
      }
      
      private function onCloseSocket(event:Event) : void
      {
         O.o("FarmServerUtil/onCloseSocket()");
      }
      
      public function depos() : void
      {
         if(Boolean(this.shortSocket))
         {
            EventManager.removeEvent(this.shortSocket,"connectted",this.onConnected);
            EventManager.removeEvent(this.shortSocket,"connection_error",this.onCloseSocket);
            EventManager.removeEvent(this.shortSocket,FarmServerUtil.REQ_MONSTER_HOLD.back.toString(),this.onReqMonsterHoldBack);
            EventManager.removeEvent(this.shortSocket,FarmServerUtil.REQ_MONSTER_INFO.back.toString(),this.onReqMonsterInfoBack);
            this.shortSocket = null;
         }
         _instance = null;
      }
      
      private function onReqMonsterHoldBack(evt:MsgEvent) : void
      {
         var params:Object = {};
         params.id = evt.msg.body.readInt();
         params.result = evt.msg.body.readInt();
         if(params.result == 0)
         {
            new FloatAlert().show(WindowLayer.instance,300,350,"派遣驻守成功！",4,200);
            ApplicationFacade.getInstance().dispatch(EventConst.TELLTRIPODCHANGE,{"storeId":params.id});
         }
         else if(params.result == 2)
         {
            new Alert().showOne("庄园已经驻守了妖怪，请先去庄园收回哦！");
         }
         else
         {
            new FloatAlert().show(WindowLayer.instance,300,350,"错误码 = " + params.result,4,200);
         }
      }
      
      private function onReqMonsterInfoBack(evt:MsgEvent) : void
      {
         var params:Object = {};
         params.destUID = evt.msg.body.readInt();
         params.result = evt.msg.body.readInt();
         if(params.result != 0)
         {
            params.iid = evt.msg.body.readInt();
            params.level = evt.msg.body.readInt();
            params.time = evt.msg.body.readInt();
            params.exp0 = evt.msg.body.readInt();
            params.exp1 = evt.msg.body.readInt();
            params.times = evt.msg.body.readInt();
            params.name = evt.msg.body.readUTF();
         }
         ApplicationFacade.getInstance().dispatch("farm_ui_monster_info_back",params);
         if(this.callBackHandler != null)
         {
            this.callBackHandler.apply(null,[null]);
         }
      }
   }
}

