package com.game.util
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class DisplayObjectMyUtil
   {
      
      private static var _dic:Dictionary = new Dictionary();
      
      public function DisplayObjectMyUtil()
      {
         super();
      }
      
      public static function mouseChildrenAll(sp:Sprite, flg:Boolean) : void
      {
         var curD:Sprite = null;
         for(var i:int = 0; i < sp.numChildren; i++)
         {
            curD = sp.getChildAt(i) as Sprite;
            if(Boolean(curD))
            {
               curD.mouseEnabled = flg;
               curD.mouseChildren = flg;
            }
         }
      }
      
      public static function disableBtn(source:DisplayObject, tip:String = "") : void
      {
         _dic[source]["enabled"] = false;
         if(tip != null && tip != "")
         {
            _dic[source]["disableTip"] = tip;
         }
      }
      
      public static function setVisible(source:DisplayObject, value:Boolean) : void
      {
         source.visible = value;
         _dic[source]["visible"] = value;
      }
      
      public static function enableBtn(source:DisplayObject) : void
      {
         _dic[source]["enabled"] = true;
      }
      
      public static function removeBtn(source:DisplayObject) : void
      {
         if(!_dic[source])
         {
            return;
         }
         _dic[source]["freeBindBtn"]();
         delete _dic[source];
      }
      
      public static function setVerticalCenter(initPoint:Point, initHeight:Number, dis:DisplayObject) : void
      {
         dis.y = initPoint.y - dis.height / 2 + initHeight / 2;
      }
      
      public static function setGray(obj:DisplayObject, bob:Boolean) : void
      {
         if(bob)
         {
            DisplayUtil.ungrayDisplayObject(obj);
         }
         else
         {
            DisplayUtil.grayDisplayObject(obj);
         }
         if(obj.hasOwnProperty("mouseChildren"))
         {
            obj["mouseChildren"] = bob;
         }
         if(obj.hasOwnProperty("enabled"))
         {
            obj["enabled"] = bob;
         }
         if(obj.hasOwnProperty("buttonMode"))
         {
            obj["buttonMode"] = bob;
         }
      }
      
      public static function tranBtnGray(obj:DisplayObject, bob:Boolean) : void
      {
         if(bob)
         {
            DisplayUtil.ungrayDisplayObject(obj);
         }
         else
         {
            DisplayUtil.grayDisplayObject(obj);
         }
      }
      
      public static function removeObject(d:DisplayObject) : void
      {
         if(Boolean(d))
         {
            if(d.hasOwnProperty("stop"))
            {
               d["stop"]();
            }
            if(Boolean(d.parent))
            {
               d.parent.removeChild(d);
            }
            d = null;
         }
      }
   }
}

