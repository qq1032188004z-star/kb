package com.game.modules.model.actUpdate.A700
{
   import com.game.locators.CacheData;
   import com.game.modules.view.FaceView;
   import com.game.util.BynaryUtil;
   import org.green.server.events.MsgEvent;
   
   public class A750
   {
      
      private static var _ins:A750;
      
      public function A750()
      {
         super();
      }
      
      public static function get ins() : A750
      {
         return _ins = _ins || new A750();
      }
      
      public function onAct750Update(evt:MsgEvent) : void
      {
         var result:int = 0;
         var is_open:int = 0;
         var flag:int = 0;
         var isShow:Boolean = false;
         var i:int = 0;
         if(evt == null)
         {
            return;
         }
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         switch(oper)
         {
            case "progress":
               is_open = evt.msg.body.readInt();
               CacheData.instance.isNewBrave = is_open;
               if(is_open == 0)
               {
                  FaceView.clip.topClip.hideBtnByName("newBraveBtn");
                  return;
               }
               FaceView.clip.topClip.hideBtnByName("braveBtn");
               flag = evt.msg.body.readInt();
               isShow = false;
               for(i = 0; i < 8; i++)
               {
                  if(!BynaryUtil.checkIndex(i + 1,flag))
                  {
                     isShow = true;
                  }
               }
               if(isShow)
               {
                  FaceView.clip.topClip.showBtnByName("newBraveBtn");
               }
               else
               {
                  FaceView.clip.topClip.hideBtnByName("newBraveBtn");
               }
         }
      }
   }
}

