package com.game.modules.vo
{
   import com.game.locators.MsgDoc;
   import org.green.server.manager.SocketManager;
   
   public class TitleVo
   {
      
      public var id:int;
      
      public var name:String;
      
      public var iconIndex:int;
      
      public var type:int;
      
      public var color:int;
      
      public var flicker:int;
      
      public var dueType:int;
      
      public var dueTxt:String;
      
      public var awardDesc:String;
      
      public var hasBoard:int = 0;
      
      public var isObtain:int = 0;
      
      public var updateState:Boolean = false;
      
      private var _awardState:Object;
      
      public function TitleVo()
      {
         super();
      }
      
      public function set awardState($value:Object) : void
      {
         this._awardState = $value;
         this.updateState = true;
      }
      
      public function get awardState() : Object
      {
         return this._awardState;
      }
      
      public function reqeustState() : void
      {
         if(!this.updateState)
         {
            SocketManager.getGreenSocket().sendCmd(MsgDoc.OP_CLIENT_SHOWTITLE.send,this.id);
         }
      }
   }
}

