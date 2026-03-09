package com.game.util
{
   import com.game.modules.control.task.TaskList;
   
   public class ResetPersonPosition
   {
      
      public static var instance:ResetPersonPosition = new ResetPersonPosition();
      
      public function ResetPersonPosition()
      {
         super();
      }
      
      public function birthPointFilter(sceneid:int) : Object
      {
         var obj:Object = null;
         switch(sceneid)
         {
            case 2102:
               if(TaskList.getInstance().hasBeenComplete(2004001) && !TaskList.getInstance().hasBeenComplete(2004002))
               {
                  obj = {};
                  obj.x = 904;
                  obj.y = 211;
               }
               return obj;
            case 8003:
               if(TaskList.getInstance().hasBeenComplete(4006005) && !TaskList.getInstance().hasBeenComplete(4006006))
               {
                  obj = {};
                  obj.x = 901;
                  obj.y = 450;
               }
               return obj;
            case 3003:
               if(TaskList.getInstance().hasBeenComplete(2013002) && !TaskList.getInstance().hasBeenComplete(2013003))
               {
                  obj = {};
                  obj.x = 940;
                  obj.y = 315;
               }
               return obj;
            default:
               return null;
         }
      }
   }
}

