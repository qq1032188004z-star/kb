package com.game.modules.vo.team
{
   import com.game.locators.GameData;
   import com.game.util.ChatUtil;
   
   public class TeamVo
   {
      
      public var teamIndex:int;
      
      private var _teamHeadPlayer:PlayerVo;
      
      public var teamTotalNum:int = 6;
      
      public var teamPlayerList:Array = [];
      
      private var _teamName:String;
      
      public var apply:int;
      
      public function TeamVo()
      {
         super();
      }
      
      public function set teamName(value:String) : void
      {
         this._teamName = value;
      }
      
      public function isTeamHead(playerId:int) : Boolean
      {
         if(this.teamHeadPlayer == null)
         {
            return false;
         }
         if(this.teamHeadPlayer.playerId == playerId)
         {
            return true;
         }
         return false;
      }
      
      public function get teamName() : String
      {
         if(this._teamName == null || this._teamName == "")
         {
            if(this.teamHeadPlayer == null)
            {
               return "";
            }
            return this.teamHeadPlayer.playerName + "的队伍";
         }
         return ChatUtil.onCheckStr(this._teamName);
      }
      
      public function get teamHeadPlayer() : PlayerVo
      {
         var thp:PlayerVo = null;
         if(this._teamHeadPlayer == null)
         {
            for each(thp in this.teamPlayerList)
            {
               if(thp.isHead)
               {
                  this._teamHeadPlayer = thp;
                  break;
               }
            }
         }
         return this._teamHeadPlayer;
      }
      
      public function set teamHeadPlayer(value:PlayerVo) : void
      {
         this._teamHeadPlayer = value;
      }
      
      public function updateHead(playerId:int) : void
      {
         if(this.teamHeadPlayer != null && this.teamHeadPlayer.playerId == playerId)
         {
            return;
         }
         var newPlayer:PlayerVo = this.getTeamPlayerById(playerId);
         if(newPlayer == null)
         {
            return;
         }
         if(this.teamHeadPlayer != null)
         {
            this.teamHeadPlayer.isHead = false;
         }
         newPlayer.isHead = true;
         this.teamHeadPlayer = newPlayer;
      }
      
      public function get currentLength() : uint
      {
         return this.teamPlayerList.length;
      }
      
      public function removeTeamPlayer(playerId:int) : Boolean
      {
         var tpVo:PlayerVo = null;
         var len:int = int(this.teamPlayerList.length);
         for(var i:int = 0; i < len; i++)
         {
            tpVo = this.teamPlayerList[i] as PlayerVo;
            if(tpVo.playerId == playerId)
            {
               this.teamPlayerList.splice(i,1);
               return true;
            }
         }
         return false;
      }
      
      public function addTeamPlayer(teamPlayer:PlayerVo) : void
      {
         if(this.hasPlayer(teamPlayer.playerId))
         {
            O.o("【已经存在该队员了！】",teamPlayer.playerName);
         }
         else
         {
            this.teamPlayerList.push(teamPlayer);
         }
      }
      
      public function hasPlayer(playerId:int) : Boolean
      {
         var tpVo:PlayerVo = null;
         for each(tpVo in this.teamPlayerList)
         {
            if(tpVo.playerId == playerId)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getTeamPlayerById(playerId:int) : PlayerVo
      {
         var needPlayer:PlayerVo = null;
         var teamPlayer:PlayerVo = null;
         for each(teamPlayer in this.teamPlayerList)
         {
            if(teamPlayer.playerId == playerId)
            {
               needPlayer = teamPlayer;
               break;
            }
         }
         return needPlayer;
      }
      
      public function updateSaveScene(playerId:int, flag:Boolean, isInit:Boolean = false) : Boolean
      {
         var teamPlayer:PlayerVo = null;
         for each(teamPlayer in this.teamPlayerList)
         {
            if(teamPlayer.playerId == playerId)
            {
               if(flag)
               {
                  if(!teamPlayer.isSameScene)
                  {
                     teamPlayer.isSameScene = true;
                     return true;
                  }
                  return false;
               }
               if(teamPlayer.isSameScene)
               {
                  teamPlayer.isSameScene = false;
                  return true;
               }
               return false;
            }
         }
         return false;
      }
      
      public function setNotSaveScene() : void
      {
         var teamPlayer:PlayerVo = null;
         for each(teamPlayer in this.teamPlayerList)
         {
            if(teamPlayer.playerId == GameData.instance.playerData.userId)
            {
               teamPlayer.isSameScene = false;
            }
            else
            {
               teamPlayer.isSameScene = false;
            }
         }
      }
      
      public function updateBattle(playerId:int, isCombat:int = 0) : Boolean
      {
         var teamPlayer:PlayerVo = null;
         var flag:Boolean = isCombat == 0 ? true : false;
         for each(teamPlayer in this.teamPlayerList)
         {
            if(teamPlayer.playerId == playerId)
            {
               if(teamPlayer.isBattle == flag)
               {
                  return false;
               }
               teamPlayer.isBattle = flag;
               return true;
            }
         }
         return false;
      }
      
      public function getTeamPlayerNameById(playerId:int) : String
      {
         var teamPlayer:PlayerVo = null;
         for each(teamPlayer in this.teamPlayerList)
         {
            if(teamPlayer.playerId == playerId)
            {
               return teamPlayer.playerName;
            }
         }
         return null;
      }
      
      public function disport() : void
      {
         this.teamPlayerList = null;
      }
   }
}

