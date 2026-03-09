package com.game.modules.vo.team
{
   import com.game.util.ChatUtil;
   
   public class PlayerVo
   {
      
      public var playerId:int;
      
      private var _playerName:String;
      
      public var sex:int;
      
      public var isHead:Boolean;
      
      public var hasTeam:Boolean;
      
      public var isBattle:Boolean = false;
      
      public var clanId:int;
      
      public var clanName:String;
      
      public var isSameScene:Boolean;
      
      public var teamId:int;
      
      public var teamName:String;
      
      public function PlayerVo()
      {
         super();
      }
      
      public function get playerName() : String
      {
         return this._playerName;
      }
      
      public function set playerName(value:String) : void
      {
         this._playerName = ChatUtil.onCheckStr(value);
      }
   }
}

