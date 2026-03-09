package com.game.modules.action
{
   import com.game.manager.MouseManager;
   import com.game.util.FloatAlert;
   import flash.display.DisplayObjectContainer;
   
   public class MouseActionControl
   {
      
      public static var instance:MouseActionControl = new MouseActionControl();
      
      public function MouseActionControl()
      {
         super();
      }
      
      public function check(disPlay:DisplayObjectContainer, actionId:int, data:Object) : Boolean
      {
         var result:Boolean = true;
         data.flag = 1;
         if(actionId >= 100 && actionId < 200)
         {
            if(data.hasOwnProperty("destid"))
            {
               data.flag = 2;
               result = true;
            }
            else
            {
               new FloatAlert().show(disPlay,300,300,"变身术只对玩家有效哦(*^__^*)");
               result = false;
            }
         }
         else
         {
            switch(actionId)
            {
               case 15:
               case 17:
               case 19:
               case 20:
               case 26:
               case 29:
                  if(data.hasOwnProperty("destid"))
                  {
                     result = true;
                  }
                  else if(!(MouseManager.getInstance().cursorName == "CursorTool200020" || MouseManager.getInstance().cursorName == "CursorTool200021"))
                  {
                     new FloatAlert().show(disPlay,300,300,"该法术只对玩家有效哦(*^__^*)");
                     result = false;
                  }
            }
         }
         return result;
      }
   }
}

