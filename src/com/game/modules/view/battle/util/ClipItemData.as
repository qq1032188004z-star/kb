package com.game.modules.view.battle.util
{
   import flash.display.DisplayObject;
   
   public class ClipItemData
   {
      
      public var eles:Vector.<ClipItemEleData> = new Vector.<ClipItemEleData>();
      
      protected var _count:int = 0;
      
      public function ClipItemData()
      {
         super();
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function pushEle(ele:DisplayObject) : void
      {
         var data:ClipItemEleData = new ClipItemEleData();
         data.obj = ele;
         data.transMatrix = ele.transform.matrix;
         this.eles.push(data);
         this._count = this.eles.length;
      }
      
      public function getEle(idx:int) : DisplayObject
      {
         var obj:DisplayObject = this.eles[idx].obj;
         obj.transform.matrix = this.eles[idx].transMatrix;
         return obj;
      }
   }
}

