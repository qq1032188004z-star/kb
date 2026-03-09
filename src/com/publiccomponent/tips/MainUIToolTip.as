package com.publiccomponent.tips
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class MainUIToolTip extends Sprite
   {
      
      private static var _tipView:ToolTipView;
      
      private static var _tipList:Vector.<Object>;
      
      private static var _instance:MainUIToolTip;
      
      private static var _posType:int = 0;
      
      public function MainUIToolTip()
      {
         super();
         if(_instance != null)
         {
            throw new Error("提示类是单例类,他已经实例化了.");
         }
      }
      
      private static function get instance() : MainUIToolTip
      {
         if(_instance == null)
         {
            _instance = new MainUIToolTip();
         }
         return _instance;
      }
      
      public static function disport() : void
      {
         if(Boolean(_instance))
         {
            _instance.destory();
            _instance = null;
         }
      }
      
      public static function init(parent:DisplayObjectContainer) : void
      {
         _tipList = new Vector.<Object>();
         _tipView = new ToolTipView();
         _tipView.visible = false;
         parent.addChild(_tipView);
      }
      
      public static function showTips(DO:DisplayObject, tips:String, type:int = 1, posType:int = 0) : void
      {
         var dotip:Object = null;
         if(checkDOBinding(DO) == -1)
         {
            dotip = {
               "DO":DO,
               "info":tips,
               "type":type
            };
            _tipList.push(dotip);
            _tipView.setTipsInfo(dotip.info,type);
            DO.addEventListener(MouseEvent.ROLL_OUT,onTipsRollOver);
            DO.addEventListener(MouseEvent.ROLL_OVER,onTipsRollOut);
            _posType = posType;
         }
         else
         {
            instance.DOTips[checkDOBinding(DO)].info = tips;
         }
      }
      
      public static function checkDOBinding(DO:DisplayObject) : int
      {
         var len:int = 0;
         var i:int = 0;
         var flag:Boolean = false;
         if(Boolean(instance.DOTips))
         {
            len = int(instance.DOTips.length);
            for(i = 0; i < len; i++)
            {
               if(instance.DOTips[i].DO == DO)
               {
                  flag = true;
                  break;
               }
            }
         }
         return flag ? i : -1;
      }
      
      private static function onTipsRollOver(evt:MouseEvent) : void
      {
         _tipView.visible = false;
      }
      
      private static function onTipsRollOut(evt:MouseEvent) : void
      {
         var info:String = null;
         var type:int = 0;
         var index:int = checkDOBinding(evt.target as DisplayObject);
         if(index != -1)
         {
            info = instance.DOTips[index].info;
            type = int(instance.DOTips[index].type);
            if(Boolean(info))
            {
               _tipView.setTipsInfo(info,type);
               if(_posType == 0)
               {
                  _tipView.x = evt.stageX + evt.target.width / 2;
                  _tipView.y = evt.stageY + evt.target.height / 3;
               }
               else
               {
                  _tipView.x = evt.stageX;
                  _tipView.y = evt.stageY + evt.target.height / 3;
               }
               _tipView.visible = true;
            }
         }
      }
      
      public static function removeToolTip() : void
      {
         var len:int = int(instance.DOTips.length);
         trace("========= 清空NewTooltips=============",len);
         for(var i:int = 0; i < len; i++)
         {
            instance.DOTips[i].DO.removeEventListener(MouseEvent.ROLL_OVER,onTipsRollOver);
            instance.DOTips[i].DO.removeEventListener(MouseEvent.ROLL_OUT,onTipsRollOut);
            instance.DOTips[i] = null;
         }
         _tipList = new Vector.<Object>();
         _tipView.maxTipsWidth = 200;
      }
      
      private function get DOTips() : Vector.<Object>
      {
         return _tipList;
      }
      
      private function destory() : void
      {
         removeToolTip();
         _tipList = null;
         if(Boolean(_tipView))
         {
            _tipView.disport();
            _tipView = null;
         }
         if(this.parent != null)
         {
            this.parent.removeChild(this);
         }
      }
   }
}

