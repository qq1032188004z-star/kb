package com.game.modules.view.challenge
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.view.MapView;
   import com.game.modules.view.person.PersonInfoPanel;
   import com.game.util.CacheUtil;
   import com.game.util.HLoaderSprite;
   import com.game.util.PhpInterFace;
   import com.publiccomponent.alert.Alert;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import org.dress.ui.RoleFace;
   import org.json.JSON;
   
   public class ChallengePkView extends HLoaderSprite
   {
      
      public var obj:Object = {};
      
      private var meRoleFace:RoleFace;
      
      private var youRoleFace:RoleFace;
      
      private var gameMapid:int;
      
      private var gameid:int;
      
      public function ChallengePkView()
      {
         super();
         this.url = "assets/material/littlegamePK.swf";
      }
      
      override public function setShow() : void
      {
         this.meRoleFace = new RoleFace(230,390,1);
         this.meRoleFace.mouseEnabled = false;
         this.bg.addChild(this.meRoleFace);
         bg.cacheAsBitmap = true;
         this.setPartData(this.obj);
         var rolecls:PersonInfoPanel = CacheUtil.getObject(PersonInfoPanel) as PersonInfoPanel;
         this.youRoleFace = new RoleFace(640,365,1);
         this.bg.addChild(this.youRoleFace);
         this.youRoleFace.mouseEnabled = false;
         trace("xy位置" + this.youRoleFace.x + "  " + this.youRoleFace.y);
         this.youRoleFace.x = 660;
         this.youRoleFace.y = 390;
         this.setMeHeadImage();
         this.setYouHeadImage();
         bg.startChallengeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.startClick);
         bg.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.closeWindow);
      }
      
      public function setPartData(obj:Object) : void
      {
         this.gameMapid = obj.gameMapid;
         this.gameid = obj.gameid;
         this.getLitGametypeScore(this.gameid);
         bg.gamenameTxt.text = obj.gamename;
         bg.menameTxt.text = GameData.instance.playerData.userName;
         bg.younameTxt.text = GameData.instance.friendData.userName;
         bg.meTxt.text = "";
         bg.youTxt.text = obj.score;
      }
      
      private function getLitGametypeScore(id:int) : void
      {
         var urlvar:URLVariables = new URLVariables();
         urlvar.uid = GameData.instance.playerData.userId;
         new PhpInterFace().getData("http://php.wanwan4399.com/smallgame/game_score.php",urlvar,this.onSendBack,"POST");
      }
      
      private function onSendBack(obj:Object) : void
      {
         if(obj == null)
         {
            return;
         }
         var obj2:Object = JSON.decode(String(obj));
         var arr:Array = obj2.list;
         for(var i:int = 0; i < arr.length; i++)
         {
            if(this.gameid == arr[i].gameid)
            {
               bg.meTxt.text = arr[i].score;
               break;
            }
         }
      }
      
      private function startClick(evt:Event = null) : void
      {
         if(GameData.instance.playerData.currentScenenId == 10005)
         {
            new Alert().showSureOrCancel("你确定退出盘丝洞？",this.leaveTeamCopyOrNotForPK);
            return;
         }
         GameData.instance.littlegameplayerid = GameData.instance.friendData.userId;
         GameData.instance.littlegameplayername = GameData.instance.friendData.userName;
         GameData.instance.littlegameplayerScore = int(bg.youTxt.text);
         GameData.instance.littlegamePkId = this.gameid;
         this.closeWindow(null);
         GameData.instance.playerData.currentScenenId = this.gameMapid;
         ApplicationFacade.getInstance().dispatch(EventConst.ENTERSCENE,this.gameMapid);
      }
      
      private function leaveTeamCopyOrNotForPK(str:String, data:Object) : void
      {
         if(str == "确定")
         {
            ApplicationFacade.getInstance().dispatch(EventConst.LEAVE_TEAMCOPY,{
               "callBack":this.startClick,
               "sceneId":this.gameMapid
            });
         }
      }
      
      private function closeWindow(evt:Event) : void
      {
         this.parent.removeChild(this);
      }
      
      private function setMeHeadImage(checkParams:Object = null) : void
      {
         checkParams = {};
         checkParams.roleType = MapView.instance.masterPerson.showData.roleType;
         checkParams.clothId = MapView.instance.masterPerson.showData.clothId;
         checkParams.footId = MapView.instance.masterPerson.showData.footId;
         checkParams.hatId = MapView.instance.masterPerson.showData.hatId;
         checkParams.faceId = MapView.instance.masterPerson.showData.faceId;
         this.meRoleFace.setRole(checkParams,"big");
      }
      
      private function setYouHeadImage(checkParams:Object = null) : void
      {
         checkParams = {};
         checkParams.roleType = GameData.instance.friendData.roleType;
         checkParams.clothId = GameData.instance.friendData.clothId;
         checkParams.footId = GameData.instance.friendData.footId;
         checkParams.hatId = GameData.instance.friendData.hatId;
         checkParams.faceId = GameData.instance.friendData.faceId;
         this.youRoleFace.setRole(checkParams,"big");
      }
   }
}

