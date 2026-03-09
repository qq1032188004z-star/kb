package com.game.modules.view.task
{
   import com.game.util.CacheUtil;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class TaskAlert
   {
      
      public function TaskAlert()
      {
         super();
      }
      
      public static function show(parent:DisplayObjectContainer, title:String, content:String, url:String, callback:Function = null, sceneId:int = 0) : void
      {
         var display:DisplayObject = CacheUtil.getObject(TaskTips) as DisplayObject;
         if(Boolean(display))
         {
            parent.addChild(display);
            display["showTips"](title,content,url,callback,sceneId);
            display.x = 0;
            display.y = 0;
         }
      }
   }
}

