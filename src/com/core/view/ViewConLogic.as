package com.core.view
{
   import org.green.server.core.GreenSocket;
   import org.green.server.manager.SocketManager;
   
   public class ViewConLogic extends ViewLogic
   {
      
      public static const NAME:String = "ViewConLogic";
      
      private var _con:GreenSocket;
      
      public function ViewConLogic(name:String = null, viewComponent:Object = null)
      {
         name = name != null ? name : NAME;
         super(name,viewComponent);
      }
      
      public function sendMessage(opcode:int, param:uint = 0, body:Array = null) : void
      {
         this.con.sendCmd(opcode,param,body);
      }
      
      protected function get con() : GreenSocket
      {
         if(this._con == null)
         {
            this._con = SocketManager.getGreenSocket();
         }
         return this._con;
      }
   }
}

