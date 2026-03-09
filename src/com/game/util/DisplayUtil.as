package com.game.util
{
   import com.game.Tools.RectButton;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.filters.ColorMatrixFilter;
   import flash.utils.getDefinitionByName;
   
   public class DisplayUtil
   {
      
      public function DisplayUtil()
      {
         super();
      }
      
      public static function getClass(classPath:String) : Class
      {
         return getDefinitionByName(classPath) as Class;
      }
      
      public static function dispos(disposList:Array) : void
      {
         var item:DisplayObject = null;
         for each(item in disposList)
         {
            if(item != null)
            {
               item["dispos"]();
               item = null;
            }
         }
      }
      
      public static function getRectButton(displayObj:DisplayObject) : RectButton
      {
         var rectBtn:RectButton = new RectButton();
         var disParent:DisplayObjectContainer = displayObj.parent;
         var childIdex:int = Boolean(disParent) ? disParent.getChildIndex(displayObj) : 0;
         var preX:Number = displayObj.x;
         var preY:Number = displayObj.y;
         rectBtn.setSkin(displayObj);
         rectBtn.x = preX;
         rectBtn.y = preY;
         if(Boolean(disParent))
         {
            disParent.addChildAt(rectBtn,childIdex);
         }
         return rectBtn;
      }
      
      public static function grayDisplayObject(item:DisplayObject) : void
      {
         var i:int = 0;
         if(item == null)
         {
            return;
         }
         var matrix:Array = new Array(1 / 3,1 / 3,1 / 3,0,0,1 / 3,1 / 3,1 / 3,0,0,1 / 3,1 / 3,1 / 3,0,0,0,0,0,1,0);
         var filters:Array = item.filters;
         if(filters == null)
         {
            filters = new Array();
         }
         else
         {
            for(i = 0; i < filters.length; i++)
            {
               if(filters[i] is ColorMatrixFilter)
               {
                  filters.splice(i,1);
                  break;
               }
            }
         }
         filters.push(new ColorMatrixFilter(matrix));
         item.filters = filters;
      }
      
      public static function ungrayDisplayObject(item:DisplayObject) : void
      {
         if(item == null)
         {
            return;
         }
         var filters:Array = item.filters;
         if(filters == null)
         {
            return;
         }
         var changed:Boolean = false;
         for(var i:int = 0; i < filters.length; i++)
         {
            if(filters[i] is ColorMatrixFilter)
            {
               filters.splice(i,1);
               changed = true;
               break;
            }
         }
         if(changed)
         {
            item.filters = filters;
         }
      }
   }
}

