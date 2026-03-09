package com.game.modules.model.actUpdate.A600
{
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.view.FaceView;
   import com.game.modules.vo.ActivityVo;
   import com.publiccomponent.ui.ButtonEffect;
   import com.publiccomponent.util.ButtonEffectUtil;
   import org.green.server.core.GreenSocket;
   import org.green.server.events.MsgEvent;
   
   public class A655
   {
      
      private static var _ins:A655;
      
      public function A655()
      {
         super();
      }
      
      public static function get ins() : A655
      {
         return _ins = _ins || new A655();
      }
      
      public function handlerRegression(vo:ActivityVo, evt:MsgEvent, con:GreenSocket) : void
      {
         var mbody:Object = null;
         var cangetFlag2:int = 0;
         var getAwardFlag2:int = 0;
         var cangetxx:int = 0;
         var cangetFlag4:int = 0;
         var getAwardFlag4:int = 0;
         var cangetoo:int = 0;
         var i2:int = 0;
         var i4:int = 0;
         O.traceSocket(evt);
         if(GameData.instance.playerData.isNewHand < 8)
         {
            return;
         }
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         mbody = {};
         switch(oper)
         {
            case "ui_info":
               mbody.result = evt.msg.body.readInt();
               mbody.awardFlag = evt.msg.body.readInt();
               mbody.getAwardFlag = evt.msg.body.readInt();
               if(mbody.awardFlag == 1 && mbody.getAwardFlag == 0)
               {
                  ButtonEffectUtil.registerEffect(FaceView.clip.getTopButton("regressBtn"),ButtonEffect.EFFECT_AWARD1,false);
               }
               else
               {
                  con.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,655,["old_callup_info"]);
               }
               break;
            case "old_callup_info":
               mbody.result = evt.msg.body.readInt();
               mbody.callCount = evt.msg.body.readInt();
               mbody.canGetAwardFlag = evt.msg.body.readInt();
               mbody.getAwardFlag = evt.msg.body.readInt();
               cangetFlag2 = int(mbody.canGetAwardFlag);
               getAwardFlag2 = int(mbody.getAwardFlag);
               cangetxx = 0;
               for(i2 = 1; i2 <= 3; i2++)
               {
                  mbody["canget" + i2] = cangetFlag2 >> i2 - 1 & 1;
                  mbody["get" + i2] = getAwardFlag2 >> i2 - 1 & 1;
                  if(mbody["canget" + i2] == 1 && mbody["get" + i2] == 0)
                  {
                     cangetxx = 1;
                     break;
                  }
               }
               if(cangetxx == 1)
               {
                  ButtonEffectUtil.registerEffect(FaceView.clip.getTopButton("regressBtn"),ButtonEffect.EFFECT_AWARD1,false);
               }
               else
               {
                  ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("regressBtn"));
                  con.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,655,["new_callup_info"]);
               }
               break;
            case "old_callup_award":
               mbody.result = evt.msg.body.readInt();
               if(mbody.result == 0)
               {
                  ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("regressBtn"));
                  con.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,655,["old_callup_info"]);
               }
               break;
            case "new_callup_info":
               mbody.result = evt.msg.body.readInt();
               mbody.callCount = evt.msg.body.readInt();
               mbody.vipcount = evt.msg.body.readInt();
               mbody.canGetAwardFlag = evt.msg.body.readInt();
               mbody.getAwardFlag = evt.msg.body.readInt();
               cangetFlag4 = int(mbody.canGetAwardFlag);
               getAwardFlag4 = int(mbody.getAwardFlag);
               cangetoo = 0;
               for(i4 = 1; i4 <= 4; i4++)
               {
                  mbody["canget" + i4] = cangetFlag4 >> i4 - 1 & 1;
                  mbody["get" + i4] = getAwardFlag4 >> i4 - 1 & 1;
                  if(mbody["canget" + i4] == 1 && mbody["get" + i4] == 0)
                  {
                     cangetoo = 1;
                     break;
                  }
               }
               if(cangetoo == 1)
               {
                  ButtonEffectUtil.registerEffect(FaceView.clip.getTopButton("regressBtn"),ButtonEffect.EFFECT_AWARD1,false);
               }
               break;
            case "new_callup_award":
               mbody.result = evt.msg.body.readInt();
               if(mbody.result == 0)
               {
                  ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("regressBtn"));
                  con.sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG_NEW.send,655,["old_callup_info"]);
               }
         }
      }
   }
}

