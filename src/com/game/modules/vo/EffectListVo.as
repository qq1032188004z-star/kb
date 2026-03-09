package com.game.modules.vo
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.global.GlobalConfig;
   
   public class EffectListVo
   {
      
      private var list:Array = [];
      
      private var oldLength:int;
      
      public var isOpen:Boolean = false;
      
      public var hasCollectId:int = 0;
      
      public function EffectListVo()
      {
         super();
      }
      
      public function get effectList() : Array
      {
         return this.list;
      }
      
      public function insertEffect(eff:Object) : void
      {
         this.effectList.push(eff);
      }
      
      public function updateList(obj:Object) : void
      {
         var index:int = 0;
         var luopan:Object = null;
         for(var i:int = 0; i < this.list.length; i++)
         {
            if(this.list[i].itemId == 103014)
            {
               luopan = this.list[i];
               index = i;
               break;
            }
         }
         if(luopan != null)
         {
            if(obj.itemNum > 0)
            {
               luopan.itemNum = obj.itemNum;
            }
            else
            {
               this.effectList.splice(index,1);
               if(this.list.length > 0)
               {
                  this.isOpen = true;
               }
               else
               {
                  this.isOpen = false;
               }
            }
         }
         else if(obj.itemNum > 0)
         {
            this.effectList.unshift(obj);
            this.isOpen = true;
         }
      }
      
      public function updateCollect(obj:Object, isChange:Boolean = false) : void
      {
         var i:int = 0;
         if(Boolean(this.hasCollectId))
         {
            for(i = 0; i < this.effectList.length; i++)
            {
               if(this.effectList[i].itemId == this.hasCollectId)
               {
                  this.effectList[i] = obj;
               }
            }
            this.hasCollectId = obj.itemId;
         }
         else
         {
            this.hasCollectId = obj.itemId;
            this.effectList.unshift(obj);
            this.effectList.sort(this.sortPos);
            this.isOpen = true;
         }
         if(isChange && this.hasCollectId && !GlobalConfig.is_show_collect_auto_alert)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.OPEN_MODULE,{
               "url":"assets/module/CollectAutoAlert/CollectAutoAlert.swf",
               "xCoord":0,
               "yCoord":0,
               "params":{"id":this.hasCollectId}
            });
         }
      }
      
      private function sortPos(p1:Object, p2:Object) : int
      {
         if(p2["itemId"] == 103014)
         {
            return 1;
         }
         if(p1["itemId"] == 103014)
         {
            return -1;
         }
         if(p2["itemId"] == this.hasCollectId)
         {
            return 1;
         }
         if(p1["itemId"] == this.hasCollectId)
         {
            return -1;
         }
         return 0;
      }
      
      public function deleteCollect() : void
      {
         var i:int = 0;
         for(i = 0; i < this.effectList.length; i++)
         {
            if(this.effectList[i].itemId == this.hasCollectId)
            {
               this.effectList.splice(i,1);
               this.hasCollectId = 0;
               if(this.list.length > 0)
               {
                  this.isOpen = true;
               }
               else
               {
                  this.isOpen = false;
               }
               return;
            }
         }
      }
      
      public function setLenth() : void
      {
         if(this.effectList.length > this.oldLength)
         {
            this.isOpen = true;
         }
         else
         {
            this.isOpen = false;
         }
         this.oldLength = this.effectList.length;
      }
      
      public function updateEffect(itemid:int, itemSwitch:int) : void
      {
         var item:Object = null;
         for each(item in this.list)
         {
            if(item.type == itemid)
            {
               item.itemSwitch = itemSwitch;
               break;
            }
         }
      }
      
      public function getTotalExpNum() : int
      {
         var eff:Object = null;
         var needNum:int = 0;
         if(this.effectList == null)
         {
            return needNum;
         }
         for each(eff in this.effectList)
         {
            if(eff.itemSwitch == 1)
            {
               if(eff.type == 112)
               {
                  needNum = 2;
               }
               else if(eff.type == 113)
               {
                  needNum = 3;
               }
            }
         }
         return needNum;
      }
      
      public function getTotalCulNum() : int
      {
         var eff:Object = null;
         var needNum:int = 0;
         if(this.effectList == null)
         {
            return needNum;
         }
         for each(eff in this.effectList)
         {
            if(eff.itemSwitch == 1)
            {
               if(eff.type == 0)
               {
                  needNum = 0;
               }
               else if(eff.type == 102)
               {
                  needNum = 2;
               }
            }
         }
         return needNum;
      }
      
      public function clear() : void
      {
         this.hasCollectId = 0;
         if(this.list == null)
         {
            this.list = [];
         }
         else
         {
            this.list.length = 0;
         }
      }
   }
}

