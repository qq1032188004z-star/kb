package com.game.util
{
   import com.channel.ChannelPool;
   import com.channel.Message;
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.modules.view.FaceView;
   import com.game.modules.view.MapView;
   import com.game.modules.view.person.GamePerson;
   import com.game.modules.vo.ShowData;
   import flash.utils.getTimer;
   import org.engine.frame.FrameTimer;
   
   public class DelayShowUtil
   {
      
      public static var instance:DelayShowUtil = new DelayShowUtil();
      
      private var playerList:Array = [];
      
      private var _systemControl:Boolean = true;
      
      private var _playerControl:Boolean = true;
      
      private var _beibeiControl:Boolean = true;
      
      private var dealingshow:Boolean = false;
      
      private var somenodeal:Boolean = false;
      
      private var lasttime:int = 0;
      
      public function DelayShowUtil()
      {
         super();
      }
      
      public function set systemControl(value:Boolean) : void
      {
         this._systemControl = value;
         if(this.dealingshow)
         {
            this.somenodeal = true;
         }
         else if(this.systemControl && this.playerControl)
         {
            this.showPlayers();
         }
         else
         {
            this.hidePlayers();
         }
         FaceView.clip.topMiddleClip.showPlayer(this._playerControl && this.systemControl);
      }
      
      public function get systemControl() : Boolean
      {
         return this._systemControl;
      }
      
      public function set playerControl(value:Boolean) : void
      {
         this._playerControl = value;
         if(this.dealingshow)
         {
            this.somenodeal = true;
         }
         else if(this.systemControl && this.playerControl)
         {
            this.showPlayers();
         }
         else
         {
            this.hidePlayers();
         }
         FaceView.clip.topMiddleClip.showPlayer(this._playerControl && this.systemControl);
      }
      
      public function get playerControl() : Boolean
      {
         return this._playerControl;
      }
      
      public function get beibeiControl() : Boolean
      {
         return this._beibeiControl;
      }
      
      public function set beibeiControl(value:Boolean) : void
      {
         this._beibeiControl = value;
      }
      
      public function get isShowPlayer() : Boolean
      {
         return this.systemControl && this.playerControl;
      }
      
      public function clear() : void
      {
         this.playerList.length = 0;
         FrameTimer.getInstance().removeCallBack(this.show);
      }
      
      public function setListAndShow(list:Array) : void
      {
         this.clear();
         this.playerList = list;
         FrameTimer.getInstance().addCallBack(this.show);
      }
      
      private function show() : void
      {
         var nowtime:int = 0;
         var obj:ShowData = null;
         var role:GamePerson = null;
         this.dealingshow = true;
         if(this.systemControl && this.playerControl)
         {
            nowtime = getTimer();
            if(nowtime - this.lasttime > 10)
            {
               this.lasttime = nowtime;
               if(this.playerList.length > 0)
               {
                  obj = this.playerList.shift() as ShowData;
                  if(obj.userId != GlobalConfig.userId)
                  {
                     if(obj.roleType >= 1 && obj.roleType <= 30)
                     {
                        if(Boolean(MapView.instance.scene) && MapView.instance.scene.findBySequenceId(obj.userId) == null)
                        {
                           role = new GamePerson(obj);
                           MapView.instance.addGamePerson(role,obj);
                        }
                     }
                  }
               }
               else
               {
                  FrameTimer.getInstance().removeCallBack(this.show);
                  this.dealingshow = false;
                  if(this.somenodeal && (!this._systemControl || !this._playerControl))
                  {
                     this.somenodeal = false;
                     this.hidePlayers();
                  }
                  ApplicationFacade.getInstance().dispatch(EventConst.ALLPERSONINSCENE);
                  if(GameData.instance.playerData.sceneId == 1028)
                  {
                     ChannelPool.getChannel("achievement").sendMessage(new Message(EventConst.ACTIVITY_CHANNEL_EVENT,null));
                  }
               }
            }
         }
         else
         {
            FrameTimer.getInstance().removeCallBack(this.show);
            this.dealingshow = false;
            if(this.somenodeal && (!this._systemControl || !this._playerControl))
            {
               this.somenodeal = false;
               this.hidePlayers();
            }
         }
      }
      
      private function stopShow() : void
      {
         FrameTimer.getInstance().removeCallBack(this.show);
         this.playerList.length = 0;
      }
      
      private function hidePlayers() : void
      {
         var i:int = 0;
         this.dealingshow = true;
         this.stopShow();
         var l:int = int(GameData.instance.playerLists.length);
         for(i = 0; i < l; i++)
         {
            if(int(GameData.instance.playerLists[i].userId) != GlobalConfig.userId)
            {
               MapView.instance.delGameSpirit(int(GameData.instance.playerLists[i].userId));
            }
         }
         this.dealingshow = false;
         if(this._systemControl && this._playerControl && this.somenodeal)
         {
            this.somenodeal = false;
            this.showPlayers();
         }
         ApplicationFacade.getInstance().dispatch(EventConst.HIDE_SCENE_PLAYER);
      }
      
      public function showPlayers() : void
      {
         this.hidePlayers();
         this.setListAndShow(GameData.instance.playerLists.concat());
      }
      
      public function hidePlayersBeiBei() : void
      {
         var i:int = 0;
         var role:GamePerson = null;
         if(!(this.playerControl && this._systemControl))
         {
            return;
         }
         this.dealingshow = true;
         var l:int = int(GameData.instance.playerLists.length);
         for(i = 0; i < l; i++)
         {
            if(int(GameData.instance.playerLists[i].userId) != GlobalConfig.userId)
            {
               role = MapView.instance["findGameSprite"]((GameData.instance.playerLists[i] as ShowData).userId) as GamePerson;
               if(Boolean(role) && (role.showData.state == 3 || role.showData.state == 2))
               {
                  role.reTakeFabao();
               }
            }
         }
         this.dealingshow = false;
         if(this._systemControl && this._playerControl && this.somenodeal)
         {
            this.somenodeal = false;
            this.showPlayers();
         }
         ApplicationFacade.getInstance().dispatch(EventConst.HIDE_SCENE_PLAYER);
      }
      
      public function showPlayersBeiBei() : void
      {
         var i:int = 0;
         var role:GamePerson = null;
         if(!(this.playerControl && this._systemControl))
         {
            return;
         }
         this.dealingshow = true;
         var l:int = int(GameData.instance.playerLists.length);
         for(i = 0; i < l; i++)
         {
            if(int(GameData.instance.playerLists[i].userId) != GlobalConfig.userId)
            {
               role = MapView.instance["findGameSprite"]((GameData.instance.playerLists[i] as ShowData).userId) as GamePerson;
               if(role && (role.showData.isVip || role.showData.isSupertrump) && (role.showData.state == 3 || role.showData.state == 2))
               {
                  role.releaseFabao();
               }
            }
         }
         this.dealingshow = false;
      }
      
      public function f_addPlayer(showdata:ShowData) : void
      {
         var i:int = 0;
         var l:int = int(GameData.instance.playerLists.length);
         for(i = 0; i < l; i++)
         {
            if(GameData.instance.playerLists[i].userId == showdata.userId)
            {
               return;
            }
         }
         MapView.instance.delGameSpirit(int(showdata.userId));
         this.playerList.push(showdata);
         GameData.instance.playerLists.push(showdata);
         FrameTimer.getInstance().removeCallBack(this.show);
         FrameTimer.getInstance().addCallBack(this.show);
      }
      
      public function f_delPlayer(playerid:int) : void
      {
         var i:int = 0;
         MapView.instance.delGameSpirit(playerid);
         var l:int = int(this.playerList.length);
         for(i = 0; i < l; i++)
         {
            if(this.playerList[i].userId == playerid)
            {
               this.playerList.splice(i,1);
               break;
            }
         }
         l = int(GameData.instance.playerLists.length);
         for(i = 0; i < l; i++)
         {
            if(GameData.instance.playerLists[i].userId == playerid)
            {
               GameData.instance.playerLists.splice(i,1);
               break;
            }
         }
      }
   }
}

