package com.game.modules.model.actUpdate.A500
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.CacheData;
   import com.game.modules.vo.ActivityVo;
   import org.green.server.data.ByteArray;
   import org.green.server.events.MsgEvent;
   
   public class A500
   {
      
      private static var _ins:A500;
      
      public function A500()
      {
         super();
      }
      
      public static function get ins() : A500
      {
         return _ins = _ins || new A500();
      }
      
      public function onAct500Update(vo:ActivityVo, evt:MsgEvent) : void
      {
         var len:int = 0;
         var curMailNum:int = 0;
         var mailList:Array = null;
         var emailInfo:Object = null;
         var idArr:Array = null;
         var i:int = 0;
         var rewardObj:Object = null;
         if(vo == null || evt == null)
         {
            return;
         }
         var param:Object = {};
         switch(vo.protocolID)
         {
            case 1:
               len = evt.msg.body.readInt();
               curMailNum = evt.msg.body.readInt();
               curMailNum = Math.min(curMailNum,100);
               mailList = [];
               for(i = 0; i < curMailNum; i++)
               {
                  emailInfo = this.getNewEmailInfo(evt.msg.body);
                  mailList.push(emailInfo);
                  CacheData.instance.addEmail(emailInfo);
               }
               break;
            case 2:
               param["result"] = evt.msg.body.readInt();
               param["id"] = evt.msg.body.readInt();
               param["status"] = evt.msg.body.readInt();
               CacheData.instance.updateEmail(param);
               break;
            case 3:
               param["result"] = evt.msg.body.readInt();
               if(param["result"] == 0)
               {
                  param["id"] = evt.msg.body.readInt();
                  param["status"] = evt.msg.body.readInt();
                  CacheData.instance.updateEmail(param);
               }
               else if(param["result"] == 1)
               {
                  rewardObj = {};
                  rewardObj["type"] = evt.msg.body.readInt();
                  rewardObj["id"] = evt.msg.body.readInt();
                  rewardObj["num"] = evt.msg.body.readInt();
                  param["rewardObj"] = rewardObj;
               }
               break;
            case 4:
               param["idsLen"] = evt.msg.body.readInt();
               idArr = [];
               for(i = 0; i < int(param["idsLen"]); i++)
               {
                  idArr.push(evt.msg.body.readInt());
               }
               param["idArr"] = idArr;
               CacheData.instance.deleteEmail(idArr);
               break;
            case 5:
               param["curMailNum"] = evt.msg.body.readInt();
               for(i = 0; i < param.curMailNum; i++)
               {
                  CacheData.instance.addEmail(this.getNewEmailInfo(evt.msg.body));
               }
               break;
            case 6:
               param["result"] = evt.msg.body.readInt();
               param["id"] = evt.msg.body.readInt();
               param["status"] = evt.msg.body.readInt();
               CacheData.instance.deleteEmail([param["id"]]);
               break;
            case 7:
         }
         ApplicationFacade.getInstance().dispatch(EventConst.NEWEMAILCOME);
      }
      
      private function getNewEmailInfo(body:ByteArray) : Object
      {
         var rewardObj:Object = null;
         var emailInfo:Object = {};
         emailInfo["id"] = body.readInt();
         emailInfo["type"] = body.readInt();
         emailInfo["status"] = body.readInt();
         emailInfo["send_time"] = body.readInt();
         emailInfo["expire_time"] = body.readInt();
         emailInfo["rewardNum"] = body.readInt();
         var rewardList:Array = [];
         for(var i:int = 0; i < emailInfo.rewardNum; i++)
         {
            rewardObj = {};
            rewardObj["type"] = body.readInt();
            rewardObj["id"] = body.readInt();
            rewardObj["num"] = body.readInt();
            rewardList.push(rewardObj);
         }
         emailInfo["rewardList"] = rewardList;
         emailInfo["sender"] = body.readUTF();
         emailInfo["title"] = body.readUTF();
         emailInfo["content"] = body.readUTF();
         return emailInfo;
      }
   }
}

