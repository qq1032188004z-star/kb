package com.game.modules.vo.list
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.modules.vo.TitleVo;
   import com.game.util.PropertyPool;
   
   public class TitleList
   {
      
      private var loadComplete:Array = [];
      
      private var titles:Array = [];
      
      private var filters:Array;
      
      public var isLoadComplete:Boolean = false;
      
      private var showSingleTitles:Array = [];
      
      private var showAllTitles:Array = [];
      
      public function TitleList()
      {
         super();
      }
      
      public function initialize() : void
      {
         this.isLoadComplete = false;
         PropertyPool.instance.getXML("config/","title",this.analysis);
      }
      
      private function analysis($xml:XML) : void
      {
         var node:XML = null;
         var title:TitleVo = null;
         if(Boolean($xml))
         {
            for each(node in $xml.children())
            {
               title = new TitleVo();
               title.id = int(node.@id);
               title.name = String(node.name);
               title.color = int(node.color);
               title.dueType = int(node.dueType);
               title.dueTxt = String(node.dueTxt);
               title.flicker = int(node.flicker);
               title.type = int(node.type);
               title.awardDesc = String(node.awardDesc);
               title.iconIndex = int(node.iconIndex);
               title.hasBoard = int(node.hasBoard);
               this.titles.push(title);
            }
            this.titles.sortOn("id",Array.NUMERIC);
            this.isLoadComplete = true;
            this.response();
         }
      }
      
      public function updateState() : void
      {
         var titleVo:TitleVo = null;
         for each(titleVo in this.titles)
         {
            titleVo.updateState = false;
         }
      }
      
      public function updateAwardState($value:Object) : void
      {
         var day:int = 0;
         var title:TitleVo = this.getTitle($value.id);
         if(Boolean(title))
         {
            title.awardState = $value;
            if($value.endTime > 0 && title.isObtain == 1)
            {
               day = Math.ceil(($value.endTime - GameData.instance.playerData.systemTimes) / 60 / 60 / 24);
               title.dueTxt = "" + day;
            }
            ApplicationFacade.getInstance().dispatch(EventConst.S_TITLE_UPDATE_STATE);
         }
      }
      
      public function addSingleResponse($value:Object) : void
      {
         this.showSingleTitles.push($value);
      }
      
      private function doResponseHandler($item:Object) : void
      {
         var title:TitleVo = null;
         if(Boolean($item))
         {
            title = this.getTitle($item.id);
            $item.response.apply();
            $item.response = null;
            $item = null;
         }
      }
      
      public function getTitle($id:int) : TitleVo
      {
         var index:int = this.indexOf($id);
         return index == -1 ? null : this.titles[index];
      }
      
      public function getTitleName($id:int) : String
      {
         var title:TitleVo = this.getTitle($id);
         var targetName:String = "";
         if(Boolean(title))
         {
            targetName = title.name;
         }
         return targetName;
      }
      
      public function updateObtain($id:int, $isObtain:int = 0) : void
      {
         var title:TitleVo = this.getTitle($id);
         if(Boolean(title))
         {
            title.isObtain = $isObtain;
         }
      }
      
      public function filterTitles($filters:Array) : Array
      {
         this.filters = $filters;
         return this.titles.filter(this.isNeed);
      }
      
      private function isNeed(element:*, index:int, arr:Array) : Boolean
      {
         var state1:Boolean = this.filters[0] == 0 ? true : element.type == this.filters[0];
         var state2:Boolean = this.filters[1] == 0 ? true : element.isObtain == 1;
         return state1 && state2;
      }
      
      public function addLoadComlete($function:Function) : void
      {
         if(this.loadComplete.indexOf($function) == -1)
         {
            this.loadComplete.push($function);
         }
      }
      
      private function response() : void
      {
         var func:Function = null;
         var item:Object = null;
         while(this.loadComplete.length > 0)
         {
            func = this.loadComplete.shift() as Function;
            if(func != null)
            {
               func.apply();
               func = null;
            }
         }
         while(this.showSingleTitles.length > 0)
         {
            item = this.showSingleTitles.shift();
            this.doResponseHandler(item);
         }
      }
      
      public function indexOf($id:int) : int
      {
         var mid:int = 0;
         var low:int = 0;
         var upper:int = this.titles.length - 1;
         if(this.titles.length > 0)
         {
            while(low <= upper)
            {
               mid = (low + upper) / 2;
               if(this.titles[mid].id < $id)
               {
                  low = mid + 1;
               }
               else
               {
                  if(this.titles[mid].id <= $id)
                  {
                     return mid;
                  }
                  upper = mid - 1;
               }
            }
         }
         return -1;
      }
   }
}

