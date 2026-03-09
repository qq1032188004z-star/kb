package com.game.modules.ai
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.view.person.GamePerson;
   import com.game.modules.vo.ShowData;
   import com.publiccomponent.alert.Alert;
   import flash.display.Stage;
   import org.engine.core.Scene;
   import org.green.server.manager.SocketManager;
   
   public class NewHandJudge
   {
      
      public static var instance:NewHandJudge = new NewHandJudge();
      
      public function NewHandJudge()
      {
         super();
      }
      
      public function judge(masterPerson:GamePerson, stage:Stage) : void
      {
         var sid:int = 0;
         var code:int = 0;
         try
         {
            sid = GameData.instance.playerData.sceneId;
            code = GameData.instance.playerData.isNewHand;
            if(sid == 1003 && code == 4)
            {
               SocketManager.getGreenSocket().sendCmd(MsgDoc.OP_CLIENT_NEWHAND.send,4,[0,""]);
            }
            if(sid == 1003 && code == 5)
            {
               ApplicationFacade.getInstance().dispatch(EventConst.FRESHMANGUIDETOTASK,{
                  "step":100600108,
                  "id":11001
               });
            }
         }
         catch(e:*)
         {
            new Alert().show(e);
         }
      }
      
      public function robotJudeg(role:GamePerson, scene:Scene) : void
      {
         var showData:ShowData = null;
         var robot:GamePerson = null;
         if(GameData.instance.playerData.nextSceneId == 901 || GameData.instance.playerData.nextSceneId == 902)
         {
            if(role.sequenceID != GlobalConfig.userId)
            {
               return;
            }
            role.x = 645;
            role.y = 436;
            if(GameData.instance.playerData.isNewHand < 4)
            {
               showData = new ShowData();
               showData.userId = -1;
               showData.userName = "机舱小助手";
               robot = new GamePerson(showData);
               robot.x = 318;
               robot.y = 434;
               scene.add(robot);
               robot.update(showData);
               robot.setDirection(2);
               if(GameData.instance.playerData.isNewHand == 3)
               {
                  role.addFollower(robot);
               }
            }
         }
      }
   }
}

