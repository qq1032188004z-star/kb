package com.publiccomponent.ui
{
   import com.game.locators.GameData;
   import flash.filters.ColorMatrixFilter;
   import flash.utils.Dictionary;
   
   public class NewHandControl
   {
      
      private var f:ColorMatrixFilter = new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0]);
      
      public var topList:Dictionary = new Dictionary();
      
      public var topMiddleList:Dictionary = new Dictionary();
      
      public var bottomList:Dictionary = new Dictionary();
      
      private var bottomClip:BottomClip;
      
      private var topMiddleClip:TopMiddleClip;
      
      public function NewHandControl(list:Dictionary, bottomClip:BottomClip, topMiddleClip:TopMiddleClip)
      {
         super();
         this.topList = list;
         this.bottomClip = bottomClip;
         this.topMiddleClip = topMiddleClip;
         this.topMiddleList = topMiddleClip.topMiddleList;
         this.bottomList = bottomClip.bottomList;
      }
      
      public function controlUI(phares:int) : void
      {
         this.showControByPhares(phares,this.topList,1);
         this.showControByPhares(phares,this.bottomList,0);
      }
      
      private function showControByPhares(phares:int, showList:Dictionary, tob:int = 0) : void
      {
         var controlItem:Object = null;
         for each(controlItem in showList)
         {
            if(Boolean(controlItem.item) && Boolean(controlItem.hasOwnProperty("showPhares")))
            {
               if(phares < controlItem.showPhares)
               {
                  if(Boolean(controlItem.item.hasOwnProperty("currentFrame")))
                  {
                     controlItem.item["mouseEnabled"] = false;
                     controlItem.item["mouseChildren"] = false;
                     if(tob == 1 || controlItem.item.name == "shopBtn")
                     {
                        controlItem.item["visible"] = false;
                     }
                     else
                     {
                        controlItem.item["filters"] = [this.f];
                     }
                  }
                  else
                  {
                     if(tob == 1)
                     {
                        controlItem.item["visible"] = false;
                     }
                     else
                     {
                        controlItem.item["filters"] = [this.f];
                     }
                     controlItem.item["mouseEnabled"] = false;
                  }
               }
               else
               {
                  if(GameData.instance.playerData.isNewHand >= 9)
                  {
                     controlItem.item["mouseEnabled"] = true;
                     if(Boolean(controlItem.item) && Boolean(controlItem.item.hasOwnProperty("mouseChildren")))
                     {
                        controlItem.item["mouseChildren"] = true;
                     }
                  }
                  else
                  {
                     controlItem.item["mouseEnabled"] = false;
                     if(Boolean(controlItem.item) && Boolean(controlItem.item.hasOwnProperty("mouseChildren")))
                     {
                        controlItem.item["mouseChildren"] = false;
                     }
                  }
                  if(controlItem.item.name != "vsBtn" && controlItem.item.name != "teamVsBtn" && controlItem.item.name != "familyBattleBtn")
                  {
                     if(Boolean(controlItem.item.hasOwnProperty("currentFrame")))
                     {
                        if(tob == 1 || controlItem.item.name == "shopBtn")
                        {
                           controlItem.item["visible"] = true;
                        }
                        else
                        {
                           controlItem.item["filters"] = null;
                        }
                        if(controlItem.item != this.bottomClip.mcclip.shopBtn)
                        {
                           controlItem.item["gotoAndStop"](1);
                        }
                     }
                     else if(tob == 1)
                     {
                        controlItem.item["visible"] = true;
                     }
                     else
                     {
                        controlItem.item["filters"] = null;
                     }
                  }
               }
            }
         }
      }
      
      public function getTipByName(name:String) : Object
      {
         var need:Object = {};
         if(this.topList[name] != null && Boolean(this.topList[name].hasOwnProperty("tips")))
         {
            need = this.topList[name];
         }
         else if(this.bottomList[name] != null && Boolean(this.bottomList[name].hasOwnProperty("tips")))
         {
            need = this.bottomList[name];
         }
         return need;
      }
   }
}

