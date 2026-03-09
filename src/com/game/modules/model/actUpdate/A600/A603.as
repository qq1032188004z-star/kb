package com.game.modules.model.actUpdate.A600
{
   import com.game.modules.view.FaceView;
   import org.green.server.events.MsgEvent;
   
   public class A603
   {
      
      private static var _ins:A603;
      
      private var _one_key:int;
      
      private var _two_key:int;
      
      public function A603()
      {
         super();
      }
      
      public static function get ins() : A603
      {
         return _ins = _ins || new A603();
      }
      
      public function onAct603Update(evt:MsgEvent) : void
      {
         var month:int = 0;
         var two_idx_key:int = 0;
         var index:int = 0;
         if(evt == null)
         {
            return;
         }
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         var code:int = 0;
         switch(oper)
         {
            case "ui_info":
               month = evt.msg.body.readInt();
               this._one_key = evt.msg.body.readInt();
               this._two_key = evt.msg.body.readInt();
               two_idx_key = evt.msg.body.readInt();
               break;
            case "receive_one":
               code = evt.msg.body.readInt();
               this._one_key = evt.msg.body.readInt();
               break;
            case "receive_two":
               code = evt.msg.body.readInt();
               index = evt.msg.body.readInt();
               this._two_key = evt.msg.body.readInt();
         }
         if(this._one_key == 2 && this._two_key == 2)
         {
            FaceView.clip.topClip.hideBtnByName("vipDoubleWeal");
         }
      }
   }
}

