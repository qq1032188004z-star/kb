package com.game.util
{
   import com.publiccomponent.loading.MaterialLib;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   public class GameDynamicUI
   {
      
      private static var uiList:Dictionary = new Dictionary();
      
      private static var notClearWenChangeSceneList:Array = [];
      
      private static var showTf:TextField = new TextField();
      
      public function GameDynamicUI()
      {
         super();
      }
      
      public static function addUI(parent:DisplayObjectContainer, x:Number, y:Number, uiName:String, scale:Number = 1, isClearWenChangeScene:Boolean = true) : void
      {
         var ui:MovieClip = uiList[uiName] as MovieClip;
         if(ui == null)
         {
            ui = MaterialLib.getInstance().getMaterial(uiName) as MovieClip;
         }
         ui.scaleX = scale;
         ui.scaleY = scale;
         ui.x = x - 8;
         ui.y = y;
         if(Boolean(parent) && !parent.contains(ui))
         {
            parent.addChild(ui);
         }
         uiList[uiName] = ui;
         if(!isClearWenChangeScene)
         {
            notClearWenChangeSceneList.push(uiName);
         }
      }
      
      public static function addFrameScritUI(parent:DisplayObjectContainer, x:Number, y:Number, uiName:String, removeFunction:Function, scale:Number = 1, isClearWenChangeScene:Boolean = true) : void
      {
         var ui:MovieClip = uiList[uiName] as MovieClip;
         if(ui == null)
         {
            ui = MaterialLib.getInstance().getMaterial(uiName) as MovieClip;
         }
         ui.scaleX = scale;
         ui.scaleY = scale;
         ui.x = x;
         ui.y = y;
         if(!parent.contains(ui))
         {
            parent.addChild(ui);
         }
         ui.addFrameScript(ui.totalFrames - 1,removeFunction);
         uiList[uiName] = ui;
         if(!isClearWenChangeScene)
         {
            notClearWenChangeSceneList.push(uiName);
         }
      }
      
      public static function addMouseEventUI(parent:DisplayObjectContainer, x:Number, y:Number, uiName:String, mouseEventName:String, callBack:Function, scale:Number = 1, isClearWenChangeScene:Boolean = true) : void
      {
         var ui:MovieClip = uiList[uiName] as MovieClip;
         if(ui == null)
         {
            ui = MaterialLib.getInstance().getMaterial(uiName) as MovieClip;
         }
         ui.buttonMode = true;
         ui.scaleX = scale;
         ui.scaleY = scale;
         ui.x = x;
         ui.y = y;
         if(!parent.contains(ui))
         {
            parent.addChild(ui);
         }
         ui.addEventListener(mouseEventName,callBack,false,0,true);
         uiList[uiName] = ui;
         if(!isClearWenChangeScene)
         {
            notClearWenChangeSceneList.push(uiName);
         }
      }
      
      public static function addMouseFrameScritUI(parent:DisplayObjectContainer, x:Number, y:Number, uiName:String, mouseEventName:String, callBack:Function, removeFunction:Function = null, scale:Number = 1, index:int = 0, midHandler:Function = null, isClearWenChangeScene:Boolean = true) : void
      {
         var ui:MovieClip = uiList[uiName] as MovieClip;
         if(ui == null)
         {
            ui = MaterialLib.getInstance().getMaterial(uiName) as MovieClip;
         }
         ui.buttonMode = true;
         ui.scaleX = scale;
         ui.scaleY = scale;
         ui.x = x;
         ui.y = y;
         if(!parent.contains(ui))
         {
            parent.addChild(ui);
         }
         if(mouseEventName != "")
         {
            ui.addEventListener(mouseEventName,callBack,false,0,true);
         }
         if(index != 0)
         {
            ui.addFrameScript(index,midHandler);
         }
         ui.addFrameScript(ui.totalFrames - 1,removeFunction);
         uiList[uiName] = ui;
         if(!isClearWenChangeScene)
         {
            notClearWenChangeSceneList.push(uiName);
         }
      }
      
      public static function excute(uiName:String, functionName:String, ope:int = 2, value:* = null) : void
      {
         var ui:MovieClip = uiList[uiName] as MovieClip;
         if(ui != null)
         {
            if(ope == 1)
            {
               if(value != null)
               {
                  ui[functionName] = value;
               }
            }
            else if(value != null)
            {
               ui[functionName](value);
            }
            else
            {
               ui[functionName]();
            }
         }
      }
      
      public static function removeUI(uiName:String) : void
      {
         var index:int = 0;
         var ui:MovieClip = uiList[uiName] as MovieClip;
         if(ui != null)
         {
            ui.stop();
            if(Boolean(ui.parent))
            {
               ui.parent.removeChild(ui);
               ui = null;
            }
            index = int(notClearWenChangeSceneList.indexOf(uiName));
            if(index != -1)
            {
               notClearWenChangeSceneList.splice(index,1);
            }
            delete uiList[uiName];
         }
         if(Boolean(showTf))
         {
            if(Boolean(showTf.parent) && showTf.parent.contains(showTf))
            {
               showTf.parent.removeChild(showTf);
            }
            showTf.visible = false;
         }
      }
      
      public static function clear() : void
      {
         var name:String = null;
         var clip:MovieClip = null;
         for(name in uiList)
         {
            if(notClearWenChangeSceneList.indexOf(name) != -1)
            {
               break;
            }
            clip = uiList[name] as MovieClip;
            if(clip != null)
            {
               clip.stop();
               if(Boolean(clip.parent))
               {
                  clip.parent.removeChild(clip);
               }
               clip = null;
            }
            if(Boolean(showTf) && Boolean(showTf.parent))
            {
               if(showTf.parent.contains(showTf))
               {
                  showTf.parent.removeChild(showTf);
               }
            }
            delete uiList[name];
         }
      }
      
      public static function showInfo(p:DisplayObjectContainer, sd:Object) : void
      {
      }
   }
}

