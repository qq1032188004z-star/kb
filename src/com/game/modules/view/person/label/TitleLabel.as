package com.game.modules.view.person.label
{
   import com.game.locators.CacheData;
   import com.game.modules.vo.TitleVo;
   
   public class TitleLabel extends NameBaseLabel
   {
      
      private var title:TitleVo;
      
      private var index:int;
      
      public function TitleLabel($xCoord:Number, $yCoord:Number)
      {
         super($xCoord,$yCoord);
      }
      
      override protected function initialize() : void
      {
      }
      
      public function build($index:int) : void
      {
         this.index = $index;
         if(CacheData.instance.titleList.isLoadComplete)
         {
            this.showTitle();
         }
         else
         {
            CacheData.instance.titleList.addSingleResponse({
               "id":$index,
               "response":this.showTitle
            });
         }
      }
      
      public function showTitle() : void
      {
         var targetName:String = null;
         this.title = CacheData.instance.titleList.getTitle(this.index);
         if(Boolean(this.title))
         {
            if(this.title.hasBoard == 0)
            {
               targetName = "title0";
            }
            else
            {
               targetName = "title" + this.title.id;
            }
            setLabel(targetName);
         }
      }
      
      override protected function showLabel() : void
      {
         super.showLabel();
         if(this.title.hasBoard == 0)
         {
            label.nameTxt.width = 200;
            label.nameTxt.htmlText = getNameString(this.title.name,this.title.color);
            label.width = label.bg.width = label.nameTxt.width = int(label.nameTxt.textWidth + 4);
            label.nameTxt.filters = getFilters(this.title.color);
         }
         else
         {
            label.play();
         }
         updateP();
      }
      
      override public function disport() : void
      {
         if(Boolean(label))
         {
            label.stop();
            if(Boolean(label.parent))
            {
               label.parent.removeChild(this.label);
            }
            label = null;
         }
         super.disport();
      }
   }
}

