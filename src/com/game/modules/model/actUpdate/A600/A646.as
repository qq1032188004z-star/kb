package com.game.modules.model.actUpdate.A600
{
   import com.core.observer.Dispatcher;
   import com.game.event.EventConst;
   import org.green.server.events.MsgEvent;
   
   public class A646
   {
      
      private static var _ins:A646;
      
      public function A646()
      {
         super();
      }
      
      public static function get ins() : A646
      {
         return _ins = _ins || new A646();
      }
      
      public function onAct646Update(evt:MsgEvent, dis:Dispatcher) : void
      {
         var uid:int = 0;
         var name:String = null;
         var num:int = 0;
         var rank:int = 0;
         var score:int = 0;
         var arr:Array = null;
         var i:int = 0;
         if(evt == null)
         {
            return;
         }
         var strTrace:String = "";
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         var rankId:int = evt.msg.body.readInt();
         var page:int = 0;
         var len:int = 0;
         var list:Array = [];
         var obj:Object = {};
         switch(oper)
         {
            case "get_revrange":
               page = evt.msg.body.readInt();
               len = evt.msg.body.readInt();
               strTrace += "P：" + 646 + "\nB：" + oper + "\n" + rankId + "\n" + page + "\n" + len;
               obj.rankId = rankId;
               obj.page = page;
               obj.len = len;
               num = 10;
               arr = [];
               for(i = 0; i < len; i++)
               {
                  uid = evt.msg.body.readInt();
                  name = evt.msg.body.readUTF();
                  score = evt.msg.body.readDouble();
                  strTrace += "\n" + uid + "\n" + name + "\n" + score;
                  rank = (page - 1) * num + i + 1;
                  list.push({
                     "rank":rank,
                     "uname":name,
                     "uid":uid,
                     "score":score
                  });
               }
               obj.list = list;
               O.out(strTrace);
               dis.dispatch(EventConst.ACHIEVEMENT_RANK_BACK,obj);
         }
      }
   }
}

