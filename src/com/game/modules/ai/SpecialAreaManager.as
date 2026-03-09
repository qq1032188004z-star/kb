package com.game.modules.ai
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.control.task.TaskList;
   import com.game.modules.view.MapView;
   import com.game.modules.view.VIPPrivilegeView;
   import com.game.modules.view.person.GamePerson;
   import com.game.modules.view.person.SpecialArea;
   import com.game.util.GamePersonControl;
   import com.game.util.SceneAIFactory;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import flash.geom.Rectangle;
   import org.engine.core.Scene;
   import org.engine.frame.FrameTimer;
   
   public class SpecialAreaManager
   {
      
      public static var instance:SpecialAreaManager = new SpecialAreaManager();
      
      private var noShowBeibeiSceneList:Array = [1013,1023,1024,2000,3000,4000,5000,1018,14000,14001,80002,9005,200005,200006,200007,200008];
      
      public var eatBool:Boolean;
      
      private var vipSceneList:Array = [{
         "level":1,
         "id":1027
      }];
      
      public function SpecialAreaManager()
      {
         super();
      }
      
      public function initAlphaArea(scene:Scene) : void
      {
         var param:Object = null;
         var sceneMaterial:SpecialArea = null;
         var areaXMLList:XMLList = scene.config.child("area");
         if(areaXMLList == null)
         {
            return;
         }
         var len:int = int(areaXMLList.length());
         for(var a:int = 0; a < len; a++)
         {
            param = {};
            param.special = areaXMLList[a].@special;
            param.sequenceID = areaXMLList[a].@sequenceID;
            param.x = areaXMLList[a].@x;
            param.y = areaXMLList[a].@y;
            param.watchURL = areaXMLList[a].@watchURL;
            param.mapid = areaXMLList[a].@mapid;
            param.url = areaXMLList[a].@url;
            sceneMaterial = SceneAIFactory.instance.produce(9,param);
            sceneMaterial.load();
            scene.add(sceneMaterial);
         }
      }
      
      public function enterJudge(masterPerson:GamePerson) : void
      {
         if(GamePersonControl.instance.isInPetArearList())
         {
            masterPerson.retakeMM();
         }
         else if(GameData.instance.playerData.sceneId == 7003)
         {
            FrameTimer.getInstance().addCallBack(this.cheakFlowerEat);
         }
         else
         {
            FrameTimer.getInstance().removeCallBack(this.cheakFlowerEat);
         }
         var code:int = GameData.instance.playerData.currentScenenId;
         if(this.noShowBeibeiSceneList.indexOf(code) == -1)
         {
            if(GameData.instance.playerData.isNewHand >= 9)
            {
               VIPPrivilegeView.getInstance().visible = true;
            }
         }
         else
         {
            VIPPrivilegeView.getInstance().visible = false;
         }
      }
      
      private function cheakFlowerEat() : void
      {
         var rect:Rectangle = new Rectangle(566,382,60,60);
         if(rect.contains(MapView.instance.masterPerson.x,MapView.instance.masterPerson.y) && this.eatBool == false)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.SCENEAREAAI,{"id":7003});
            this.eatBool = true;
         }
      }
      
      public function loadAlphaClip(lastSceneId:int) : void
      {
         AlphaArea.instance.unLoadAlpha();
         if(GameData.instance.playerData.currentScenenId == 2102)
         {
            if(lastSceneId == 2103 || lastSceneId == 2104)
            {
               if(TaskList.getInstance().hasBeenComplete(2004001) && !TaskList.getInstance().hasBeenComplete(2004002))
               {
                  AlphaArea.instance.loadAlpha("assets/ai/2102left.swf");
               }
               else
               {
                  AlphaArea.instance.loadAlpha("assets/ai/2102right.swf");
               }
            }
            else
            {
               AlphaArea.instance.loadAlpha("assets/ai/2102left.swf");
            }
         }
         if(GameData.instance.playerData.currentScenenId == 8003)
         {
            if(lastSceneId == 8002 || lastSceneId == 8004)
            {
               AlphaArea.instance.loadAlpha("assets/ai/8003left.swf");
            }
            else if(TaskList.getInstance().hasBeenComplete(4006005) && !TaskList.getInstance().hasBeenComplete(4006006))
            {
               AlphaArea.instance.loadAlpha("assets/ai/8003left.swf");
            }
            else
            {
               AlphaArea.instance.loadAlpha("assets/ai/8003right.swf");
            }
         }
         if(GameData.instance.playerData.currentScenenId == 40001)
         {
         }
         if(GameData.instance.playerData.currentScenenId == 22012)
         {
            AlphaArea.instance.loadAlpha("assets/ai/22012right.swf");
         }
      }
      
      public function checkVip(sceneId:int) : Boolean
      {
         var item:Object = null;
         var result:Boolean = true;
         for each(item in this.vipSceneList)
         {
            if(item.id == sceneId)
            {
               if(GameData.instance.playerData.vipLevel < item.level)
               {
                  result = false;
                  new Alert().showOne("只有VIP等级达到" + item.level + "级才可以进入此场景哦");
               }
               break;
            }
         }
         return result;
      }
      
      public function loadNewHandMask(maskName:String) : void
      {
         var url:String = URLUtil.getSvnVer("assets/material/" + maskName + ".swf");
         AlphaArea.instance.unLoadAlpha();
         AlphaArea.instance.loadAlpha(url);
      }
      
      public function removeNewHandMask() : void
      {
         AlphaArea.instance.unLoadAlpha();
      }
      
      public function getHouseDy(smallHouseId:int) : int
      {
         var item:Object = null;
         var dyList:Array = [{
            "id":800432,
            "dy":150
         },{
            "id":800020,
            "dy":120
         },{
            "id":800050,
            "dy":150
         },{
            "id":800211,
            "dy":230
         },{
            "id":800212,
            "dy":210
         },{
            "id":800221,
            "dy":210
         },{
            "id":800252,
            "dy":210
         },{
            "id":800266,
            "dy":210
         },{
            "id":800275,
            "dy":210
         },{
            "id":800319,
            "dy":210
         },{
            "id":800339,
            "dy":150
         },{
            "id":800368,
            "dy":130
         },{
            "id":800371,
            "dy":150
         },{
            "id":800398,
            "dy":150
         },{
            "id":800404,
            "dy":150
         },{
            "id":800446,
            "dy":210
         },{
            "id":800470,
            "dy":230
         },{
            "id":800486,
            "dy":210
         },{
            "id":800498,
            "dy":200
         },{
            "id":800506,
            "dy":200
         },{
            "id":800532,
            "dy":200
         },{
            "id":800540,
            "dy":200
         },{
            "id":800548,
            "dy":150
         },{
            "id":800565,
            "dy":200
         }];
         var result:int = 85;
         for each(item in dyList)
         {
            if(item.id == smallHouseId)
            {
               result = int(item.dy);
               break;
            }
         }
         return result;
      }
      
      public function checkHouhuaYuan(scene:Scene) : void
      {
         var url:String = null;
         var params:Object = null;
         var code:int = GameData.instance.playerData.currentScenenId;
         if(code == 1024)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
               "url":"assets/module/GardonDress.swf",
               "xCoord":0,
               "yCoord":0
            });
         }
         if(code == 1023)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.BOBSTATECLICK,{
               "url":"assets/module/GardonDress.swf",
               "xCoord":0,
               "yCoord":0
            });
         }
         if(code == 1023)
         {
            if(GameData.instance.playerData.houhuayuanID != 0)
            {
               url = URLUtil.getSvnVer("assets/basedress/dress/gardon/bg/houhua" + GameData.instance.playerData.houhuayuanID + ".swf");
               scene.changeBg(url);
            }
            url = URLUtil.getSvnVer("assets/build/xiaowu" + GameData.instance.playerData.smallHouseID + ".swf");
            params = {};
            params.url = url;
            params.name = "";
            params.id = 123456;
            params.x = 593;
            params.y = 226;
            params.dy = this.getHouseDy(GameData.instance.playerData.smallHouseID);
            scene.loadSingleBuild(params);
         }
         if(code == 1024)
         {
            if(GameData.instance.playerData.smallHouseID != 0)
            {
               url = URLUtil.getSvnVer("assets/basedress/dress/home/bg/home" + GameData.instance.playerData.smallHouseID + ".swf");
               scene.changeBg(url);
               url = URLUtil.getSvnVer("assets/basedress/dress/home/bgconfig/config" + GameData.instance.playerData.smallHouseID);
               scene.changeConfig(url);
            }
         }
      }
   }
}

