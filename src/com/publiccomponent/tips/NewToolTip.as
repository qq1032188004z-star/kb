package com.publiccomponent.tips
{
   import com.game.util.ToolTipStringUtil;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import mx.utils.StringUtil;
   
   public class NewToolTip extends Sprite
   {
      
      private static var _tipView:ToolTipView;
      
      private static var _tipList:Vector.<Object>;
      
      private static var _instance:NewToolTip;
      
      private static var _posType:int = 0;
      
      public function NewToolTip()
      {
         super();
         if(_instance != null)
         {
            throw new Error("提示类是单例类,他已经实例化了.");
         }
      }
      
      private static function get instance() : NewToolTip
      {
         if(_instance == null)
         {
            _instance = new NewToolTip();
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
      
      public static function showToolTips(DO:DisplayObject, toolid:int, type:int = 1, posType:int = 0) : void
      {
         var dotip:Object = null;
         var tips:String = ToolTipStringUtil.toPackTipString(toolid);
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
      
      public static function showMonsterTips(DO:DisplayObject, monsterid:int, type:int = 1, posType:int = 0) : void
      {
         var dotip:Object = null;
         var tips:String = ToolTipStringUtil.toSpriteTipString(monsterid);
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
      
      public static function LooseDO(DO:DisplayObject) : void
      {
         var index:int = checkDOBinding(DO);
         if(index != -1)
         {
            instance.visible = false;
            instance.DOTips.splice(index,1);
            DO.removeEventListener(MouseEvent.ROLL_OUT,onTipsRollOver);
            DO.removeEventListener(MouseEvent.ROLL_OVER,onTipsRollOut);
         }
      }
      
      public static function ChangeDOInfo(DO:DisplayObject, info:String) : void
      {
         info = StringUtil.trim(info);
         if(checkDOBinding(DO) == -1)
         {
            showTips(DO,info);
         }
         else
         {
            instance.DOTips[checkDOBinding(DO)].info = info;
         }
      }
      
      public static function checkDOBinding(DO:DisplayObject) : int
      {
         var flag:Boolean = false;
         var len:int = int(instance.DOTips.length);
         for(var i:int = 0; i < len; i++)
         {
            if(instance.DOTips[i].DO == DO)
            {
               flag = true;
               break;
            }
         }
         return flag ? i : -1;
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
      
      public static function set MaxWidth(value:Number) : void
      {
         _tipView.maxTipsWidth = value;
      }
      
      public static function get MaxWidth() : Number
      {
         return _tipView.maxTipsWidth;
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
               if(Boolean(_tipView.parent))
               {
                  _tipView.parent.addChild(_tipView);
               }
               _tipView.visible = true;
            }
         }
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

