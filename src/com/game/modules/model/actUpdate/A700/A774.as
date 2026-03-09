package com.game.modules.model.actUpdate.A700
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.view.FaceView;
   import com.game.util.BynaryUtil;
   import com.game.util.DateUtil;
   import org.green.server.events.MsgEvent;
   
   public class A774
   {
      
      private static var _ins:A774;
      
      private var _act774PopFlag:Boolean = false;
      
      public function A774()
      {
         super();
      }
      
      public static function get ins() : A774
      {
         return _ins = _ins || new A774();
      }
      
      public function onAct774Update(evt:MsgEvent) : void
      {
         var endTime:Number = NaN;
         var isOpenView:Boolean = false;
         var count:int = 0;
         var i:int = 0;
         if(evt == null)
         {
            return;
         }
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         var params:Object = {};
         switch(oper)
         {
            case "open_ui":
               params["day"] = evt.msg.body.readInt();
               params["time"] = evt.msg.body.readInt();
               params["baseFlag"] = evt.msg.body.readInt();
               params["flag"] = evt.msg.body.readInt();
               params["evoFlag"] = evt.msg.body.readInt();
               if(params["time"] > 0)
               {
                  if(GameData.instance.playerData.systemTimes > DateUtil.getTimestampAfterDaysAtMidnight(params["time"]))
                  {
                     return;
                  }
               }
               else if(DateUtil.isPassTime("20260305235959"))
               {
                  return;
               }
               isOpenView = false;
               count = 0;
               for(i = 0; i < 7; i++)
               {
                  if(i < params["day"])
                  {
                     if(params["time"] > 0)
                     {
                        isOpenView = !BynaryUtil.checkIndex(i + 1,params["flag"]) || !BynaryUtil.checkIndex(i + 1,params["baseFlag"]);
                     }
                     else
                     {
                        isOpenView = !BynaryUtil.checkIndex(i + 1,params["baseFlag"]);
                     }
                     if(BynaryUtil.checkIndex(i + 1,params["flag"]) && BynaryUtil.checkIndex(i + 1,params["baseFlag"]))
                     {
                        count++;
                     }
                     if(isOpenView)
                     {
                        break;
                     }
                  }
               }
               if(count >= 7 && params["evoFlag"] == 1)
               {
                  FaceView.clip.topClip.hideBtnByName("PineappleShopBtn");
                  return;
               }
               FaceView.clip.topClip.showBtnByName("PineappleShopBtn");
               if(this._act774PopFlag)
               {
                  return;
               }
               if(isOpenView && !this._act774PopFlag && GameData.instance.playerData.isNewHand >= 9)
               {
                  ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{"url":"assets/activity/zrk2026/Act774/Act774Entrance.swf"});
               }
               this._act774PopFlag = true;
         }
      }
   }
}

