package com.game.util
{
   import com.game.modules.vo.monster.EggTipsData;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class EggTipsManager
   {
      
      private static var _instance:EggTipsManager;
      
      private var _tipsDataList:Array;
      
      private var _tipsDic:Dictionary;
      
      public function EggTipsManager()
      {
         super();
         this._tipsDataList = [];
         this._tipsDic = new Dictionary(true);
      }
      
      public static function get instance() : EggTipsManager
      {
         if(_instance == null)
         {
            _instance = new EggTipsManager();
         }
         return _instance;
      }
      
      public static function disport() : void
      {
         if(_instance != null)
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      private function destroy() : void
      {
         var tips:EggSpecTipAlert = null;
         var tipsData:EggTipsData = null;
         var key:String = null;
         if(this._tipsDataList != null)
         {
            for each(tipsData in this._tipsDataList)
            {
               if(this._tipsDic[tipsData.qName] != null)
               {
                  tips = this._tipsDic[tipsData.qName];
                  tips.dispos();
                  tips = null;
                  this._tipsDic[tipsData.qName] = null;
                  delete this._tipsDic[tipsData.qName];
               }
               tipsData.disport();
               tipsData = null;
            }
            this._tipsDataList = null;
            this._tipsDic = null;
         }
         if(this._tipsDic != null)
         {
            for(key in this._tipsDic)
            {
               tips = this._tipsDic[key];
               tips.dispos();
               tips = null;
               this._tipsDic[key] = null;
               delete this._tipsDic[key];
            }
         }
      }
      
      public function bindTips($target:DisplayObject, $value:Object, $tipsClass:Class) : void
      {
         if($target.stage == null)
         {
            return;
         }
         var qName:String = getQualifiedClassName($tipsClass);
         var tipsData:EggTipsData = new EggTipsData($target,$value,qName);
         var tips:EggSpecTipAlert = this.getTipsByClass(qName,$tipsClass);
         if(this.check($target) == null)
         {
            $target.stage.addChild(tips);
            this._tipsDataList.push(tipsData);
            $target.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
            $target.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
            tips.x += $target.x + $target.width / 2;
            tips.y += $target.y + $target.height / 2;
            tipsData.tx = $target.x;
            tipsData.ty = $target.y;
            tips.visibleStatus = false;
         }
         else
         {
            this.updateTipsData($target,$value);
         }
         tips.data = $value;
      }
      
      private function check($target:DisplayObject) : EggTipsData
      {
         var tipsData:EggTipsData = null;
         for each(tipsData in this._tipsDataList)
         {
            if(tipsData.target == $target)
            {
               return tipsData;
            }
         }
         return null;
      }
      
      private function updateTipsData($target:DisplayObject, $value:*) : void
      {
         var tipsData:EggTipsData = null;
         for each(tipsData in this._tipsDataList)
         {
            if(tipsData.target == $target)
            {
               tipsData.value = $value;
            }
         }
      }
      
      private function onMouseOver(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         var obj:EggTipsData = this.check(evt.currentTarget as DisplayObject);
         if(obj == null)
         {
            return;
         }
         var tips:EggSpecTipAlert = this.getTipsByName(obj.qName);
         if(tips == null)
         {
            return;
         }
         tips.parent.setChildIndex(tips,tips.parent.numChildren - 1);
         tips.data = obj.value;
         tips.visibleStatus = true;
         var targetX:Number = evt.currentTarget.x + evt.currentTarget.parent.x + evt.currentTarget.parent.parent.x + 40;
         var targetY:Number = evt.currentTarget.y + evt.currentTarget.parent.y + evt.currentTarget.parent.parent.y + 40;
         tips.x = targetX + tips.width > 970 ? 970 - tips.width : targetX;
         tips.y = targetY + tips.height > 570 ? 570 - tips.height - 90 : targetY;
         tips.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOverEx);
         tips.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOutEx);
      }
      
      private function onMouseOverEx(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         evt.stopPropagation();
         var tips:EggSpecTipAlert = evt.currentTarget as EggSpecTipAlert;
         if(tips == null)
         {
            return;
         }
         tips.parent.setChildIndex(tips,tips.parent.numChildren - 1);
         tips.visibleStatus = true;
      }
      
      private function onMouseOut(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         evt.stopPropagation();
         var obj:EggTipsData = this.check(evt.currentTarget as DisplayObject);
         if(obj == null)
         {
            return;
         }
         var tips:EggSpecTipAlert = this.getTipsByName(obj.qName);
         if(tips == null)
         {
            return;
         }
         tips.visibleStatus = false;
      }
      
      private function onMouseOutEx(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         var tips:EggSpecTipAlert = evt.currentTarget as EggSpecTipAlert;
         if(tips == null)
         {
            return;
         }
         tips.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
         tips.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         tips.visibleStatus = false;
      }
      
      private function onMouseMove(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         var obj:EggTipsData = this.check(evt.currentTarget as DisplayObject);
         if(obj == null)
         {
            return;
         }
         if(obj.value == null)
         {
            return;
         }
         var tips:EggSpecTipAlert = this.getTipsByName(obj.qName);
         if(tips == null)
         {
            return;
         }
      }
      
      public function looseBind($target:DisplayObject) : void
      {
         var obj:EggTipsData = this.check($target);
         if(obj == null)
         {
            return;
         }
         obj.value = null;
         var tips:EggSpecTipAlert = this.getTipsByName(obj.qName);
         if(tips != null)
         {
            tips.data = null;
         }
      }
      
      private function getTipsByClass($qName:String, $cls:Class) : EggSpecTipAlert
      {
         if(this._tipsDic[$qName] == null)
         {
            this._tipsDic[$qName] = new $cls() as EggSpecTipAlert;
         }
         return this._tipsDic[$qName];
      }
      
      private function getTipsByName($qName:String) : EggSpecTipAlert
      {
         return this._tipsDic[$qName];
      }
   }
}

