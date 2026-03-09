package com.game.modules.view.person.label
{
   import com.game.util.PropertyPool;
   
   public class FamilyLabel extends NameBaseLabel
   {
      
      private var familyData:Object;
      
      private var icoIndex:int;
      
      private var _hasSetInCallBack:Boolean = false;
      
      public function FamilyLabel($xCoord:Number, $yCoord:Number)
      {
         super($xCoord,$yCoord);
      }
      
      public function build($familyData:Object) : void
      {
         this._hasSetInCallBack = false;
         this.familyData = $familyData;
         if(this.familyData.hasOwnProperty("id"))
         {
            PropertyPool.instance.getXML("config/","arenaRankList",this.xmlLoader);
         }
      }
      
      private function xmlLoader(xml:XML) : void
      {
         var targetName:String;
         var tempxml:XMLList = null;
         if(Boolean(xml))
         {
            tempxml = xml.children().(@id == familyData.id);
            if(Boolean(tempxml) && tempxml.length() > 0)
            {
               this.icoIndex = tempxml[0].@styleid;
            }
            else
            {
               this.icoIndex = 0;
            }
         }
         else
         {
            this.icoIndex = 0;
         }
         targetName = "family" + this.icoIndex;
         setLabel(targetName);
      }
      
      override protected function showLabel() : void
      {
         var targetName:String = null;
         super.showLabel();
         label.nameTxt.width = 200;
         label.nameTxt.htmlText = getNameString("【" + this.familyData.name + "】",6);
         if(label.hasOwnProperty("nameClip"))
         {
            label.nameClip.x = 0;
            label.nameTxt.width = int(label.nameTxt.textWidth + 15);
            label.nameTxt.x = label.nameClip.width + label.nameClip.x;
            label.nameTxt.width + label.nameClip.width;
         }
         else
         {
            label.width = label.nameTxt.width = int(label.nameTxt.textWidth + 15);
         }
         label.nameTxt.filters = getFilters(6);
         updateP();
      }
   }
}

