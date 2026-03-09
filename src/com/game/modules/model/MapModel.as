package com.game.modules.model
{
   import com.core.model.Model;
   import com.game.event.EventConst;
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import org.green.server.events.MsgEvent;
   
   public class MapModel extends Model
   {
      
      public static const NAME:String = "mapModel";
      
      public function MapModel(modelName:String = null)
      {
         super(NAME);
      }
      
      override public function onRegister() : void
      {
         registerListener(MsgDoc.OP_GATEWAY_BOB_STATE.back.toString(),this.onChangBobState);
         registerListener(MsgDoc.OP_GATEWAY_DBOB_STATE.back.toString(),this.onChangDBobState);
         registerListener(MsgDoc.CLIENT_COPY_LEAVE.back.toString(),this.onClintCopyLeave);
         registerListener(MsgDoc.OP_GATEWAY_FIRSTTIME.back.toString(),this.onFirstTimeback);
         registerListener(MsgDoc.OP_COIN_UPDATE.back.toString(),this.onCoinUpdate);
      }
      
      private function onChangBobState1(event:MsgEvent) : void
      {
         var obj:Object = new Object();
         obj.haveperson = event.msg.mParams;
         if(event.msg.mParams != 0)
         {
            obj.atker = event.msg.body.readInt();
            obj.defer = event.msg.body.readInt();
            obj.times = event.msg.body.readInt();
         }
         dispatch(EventConst.BOB_STATE_CHANG,obj);
      }
      
      private function onChangBobState(event:MsgEvent) : void
      {
         O.traceSocket(event);
         var obj:Object = {};
         obj.shaveperson = event.msg.mParams;
         if(event.msg.mParams != 0)
         {
            obj.sBobAtker = event.msg.body.readInt();
            obj.sBobDefer = event.msg.body.readInt();
            obj.sBobTimes = event.msg.body.readInt();
            obj.sbattleid = event.msg.body.readInt();
         }
         GameData.instance.playerData.leitaidata.sBobAtker = int(obj.sBobAtker);
         GameData.instance.playerData.leitaidata.sBobDefer = int(obj.sBobDefer);
         GameData.instance.playerData.leitaidata.sBobTimes = int(obj.sBobTimes);
         GameData.instance.playerData.leitaidata.sbattleid = int(obj.sbattleid);
         GameData.instance.playerData.leitaidata.shaveperson = obj.shaveperson;
         dispatch(EventConst.BOB_STATE_CHANG,obj);
      }
      
      private function onChangDBobState(event:MsgEvent) : void
      {
         O.traceSocket(event);
         var obj:Object = {};
         obj.dhaveperson = event.msg.mParams;
         if(event.msg.mParams != 0)
         {
            obj.dBobAtker = event.msg.body.readInt();
            obj.dBobDefer = event.msg.body.readInt();
            obj.dBobTimes = event.msg.body.readInt();
            obj.dbattleid = event.msg.body.readInt();
         }
         GameData.instance.playerData.leitaidata.dBobAtker = int(obj.dBobAtker);
         GameData.instance.playerData.leitaidata.dBobDefer = int(obj.dBobDefer);
         GameData.instance.playerData.leitaidata.dBobTimes = int(obj.dBobTimes);
         GameData.instance.playerData.leitaidata.dbattleid = int(obj.dbattleid);
         GameData.instance.playerData.leitaidata.dhaveperson = obj.dhaveperson;
         dispatch(EventConst.BOB_DSTATE_CHANG,obj);
      }
      
      private function onClintCopyLeave(event:MsgEvent) : void
      {
         O.traceSocket(event);
         O.o("MapModel/onClintCopyLeave/GameData.instance.playerData.currentScenenId:" + GameData.instance.playerData.currentScenenId);
         O.o("MapModel/onClintCopyLeave/CacheData.instance.isEnterSceneByCopy--------------------------：" + CacheData.instance.isEnterSceneByCopy);
         if(CacheData.instance.isEnterSceneByCopy)
         {
            dispatch(EventConst.ENTERSCENE,GameData.instance.playerData.currentScenenId);
         }
         else
         {
            CacheData.instance.isEnterSceneByCopy = true;
         }
      }
      
      private function onFirstTimeback(event:MsgEvent) : void
      {
         var index:int = 0;
         var value:int = 0;
         O.traceSocket(event);
         var ct:int = event.msg.mParams;
         if(ct < 500)
         {
            while(ct > 0)
            {
               index = event.msg.body.readInt();
               value = event.msg.body.readInt();
               GameData.instance.playerData.newvalue[index] = value;
               ct--;
            }
            dispatch(EventConst.VERYDAY_SHOWEFFECT);
         }
      }
      
      private function onCoinUpdate(event:MsgEvent) : void
      {
         O.traceSocket(event);
         GameData.instance.playerData.canCangCoin = true;
         GameData.instance.playerData.coin = event.msg.mParams;
      }
   }
}

