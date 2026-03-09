package com.game.modules.view.monster
{
   import com.game.modules.view.WindowLayer;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import mx.utils.StringUtil;
   
   public class SymmTip
   {
      
      private static var _instance:SymmTip;
      
      private var m_arrDOTips:Array;
      
      private var _symm:SymmTipView;
      
      public function SymmTip()
      {
         super();
         if(this.m_arrDOTips == null)
         {
            this.m_arrDOTips = [];
         }
      }
      
      public static function hideCurrentTip() : void
      {
         if(Boolean(instance) && Boolean(instance.symm))
         {
            instance.symm.visible = false;
         }
      }
      
      public static function TestDOBinging(DO:DisplayObject) : int
      {
         var i:int = 0;
         var flag:Boolean = false;
         i = 0;
         while(i < instance.DOTips.length)
         {
            if(instance.DOTips[i].DO == DO)
            {
               flag = true;
               break;
            }
            i++;
         }
         O.o("TestDOBinging",i);
         return flag ? i : -1;
      }
      
      public static function BindDO(DO:DisplayObject, info:String) : void
      {
         var doTip:Object = null;
         info = StringUtil.trim(info);
         if(TestDOBinging(DO) == -1)
         {
            doTip = {
               "DO":DO,
               "info":info
            };
            instance.DOTips.push(doTip);
            DO.addEventListener(MouseEvent.ROLL_OVER,showTip);
            DO.addEventListener(MouseEvent.ROLL_OUT,hidetip);
            DO.addEventListener(MouseEvent.MOUSE_MOVE,movetip);
         }
      }
      
      public static function LooseDO(DO:DisplayObject) : void
      {
         var index:int = TestDOBinging(DO);
         if(index != -1)
         {
            instance.symm.visible = false;
            instance.DOTips.splice(index,1);
            DO.removeEventListener(MouseEvent.ROLL_OVER,showTip);
            DO.removeEventListener(MouseEvent.ROLL_OUT,hidetip);
            DO.removeEventListener(MouseEvent.MOUSE_MOVE,movetip);
         }
      }
      
      private static function movetip(evt:MouseEvent) : void
      {
         if(evt.target == null)
         {
            return;
         }
         setStage(evt.stageX,evt.stageY);
      }
      
      private static function get instance() : SymmTip
      {
         if(_instance == null)
         {
            _instance = new SymmTip();
         }
         return _instance;
      }
      
      private static function hidetip(evt:MouseEvent) : void
      {
         if(evt.target == null)
         {
            return;
         }
         instance.symm.visible = false;
      }
      
      public static function setDOInfo(DO:DisplayObject, info:String) : void
      {
         info = StringUtil.trim(info);
         var index:int = TestDOBinging(DO);
         if(index == -1)
         {
            BindDO(DO,info);
         }
         else
         {
            instance.DOTips[index].info = info;
         }
      }
      
      private static function setStage(xCoode:Number, yCoode:Number) : void
      {
         instance.symm.x = xCoode;
         instance.symm.y = yCoode - 20;
      }
      
      private static function showTip(evt:MouseEvent) : void
      {
         evt = evt;
         if(evt.target == null)
         {
            return;
         }
         setStage(evt.stageX,evt.stageY);
         try
         {
            instance.symm.setMsg(instance.DOTips[TestDOBinging(evt.target as DisplayObject)].info);
            instance.symm.visible = true;
         }
         catch(error:Error)
         {
         }
      }
      
      public static function removeToolTip() : void
      {
         var i:int = 0;
         while(i < instance.m_arrDOTips.length)
         {
            instance.DOTips[i].DO.removeEventListener(MouseEvent.ROLL_OVER,showTip);
            instance.DOTips[i].DO.removeEventListener(MouseEvent.ROLL_OUT,hidetip);
            instance.DOTips[i].DO.removeEventListener(MouseEvent.MOUSE_MOVE,movetip);
            instance.DOTips[i] = null;
            i++;
         }
         if(Boolean(_instance._symm))
         {
            _instance.m_arrDOTips = null;
            if(Boolean(_instance._symm.parent))
            {
               _instance._symm.parent.removeChild(_instance._symm);
            }
            _instance = null;
         }
      }
      
      public function get DOTips() : Array
      {
         return this.m_arrDOTips;
      }
      
      private function get symm() : SymmTipView
      {
         if(this._symm == null)
         {
            this._symm = new SymmTipView();
            this._symm.mouseChildren = false;
            this._symm.mouseEnabled = false;
            WindowLayer.instance.stage.addChild(this._symm);
         }
         return this._symm;
      }
   }
}

