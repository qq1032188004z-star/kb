package com.game.modules.model.actUpdate.A000
{
   import com.game.locators.CacheData;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.manager.AlertManager;
   import com.game.modules.view.FaceView;
   import com.game.modules.vo.ActivityVo;
   import org.green.server.events.MsgEvent;
   import org.green.server.manager.SocketManager;
   
   public class A294
   {
      
      private static var _ins:A294;
      
      public function A294()
      {
         super();
      }
      
      public static function get ins() : A294
      {
         return _ins = _ins || new A294();
      }
      
      public function onTopLimitOpen(vo:ActivityVo, evt:MsgEvent) : void
      {
         var isTip:Boolean = false;
         var i:int = 0;
         var isMax:int = 0;
         var data:Object = null;
         var type:int = 0;
         var gap:int = 0;
         if(vo == null || evt == null)
         {
            return;
         }
         if(vo.protocolID == 1)
         {
            vo.valueobject.result = evt.msg.body.readInt();
            vo.valueobject.type = evt.msg.body.readInt();
            if(vo.valueobject.result == 0)
            {
               SocketManager.getGreenSocket().sendCmd(MsgDoc.OP_CLIENT_REQ_KB_COIN_INFO.send,GameData.instance.playerData.userId);
            }
         }
         else if(vo.protocolID == 2)
         {
            vo.valueobject.count = evt.msg.body.readInt();
            isTip = false;
            for(i = 0; i < vo.valueobject.count; i++)
            {
               data = {};
               type = evt.msg.body.readInt();
               data.curLen = evt.msg.body.readInt();
               data.maxLen = evt.msg.body.readInt();
               if(type >= 2 && !isTip)
               {
                  if(type != 3)
                  {
                     gap = data.maxLen - data.curLen;
                     if(gap > 5)
                     {
                        FaceView.clip.bottomClip.setPackTip(3);
                     }
                     else if(gap > 0 && gap <= 5)
                     {
                        FaceView.clip.bottomClip.setPackTip(1);
                        isTip = true;
                     }
                     else if(gap == 0)
                     {
                        FaceView.clip.bottomClip.setPackTip(2);
                        isTip = true;
                     }
                  }
               }
               CacheData.instance.topLimitOpenList[type] = data;
            }
            isMax = evt.msg.body.readInt();
            if(isMax == 1)
            {
               AlertManager.instance.addTipAlert({
                  "tip":"您的妖怪仓库已经满员啦！快点放掉几只，以免无法在后续活动中获取心仪妖怪噢！",
                  "type":2
               });
            }
         }
      }
   }
}

