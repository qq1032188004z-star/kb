package com.game.modules.view.person.label
{
   import com.publiccomponent.ui.NameLabelLoader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   
   public class NameBaseLabel extends Sprite
   {
      
      protected var label:MovieClip;
      
      protected var data:Object;
      
      private var targetName:String;
      
      public function NameBaseLabel($xCoord:Number, $yCoord:Number)
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.x = $xCoord;
         this.y = $yCoord;
         this.initialize();
      }
      
      protected function initialize() : void
      {
      }
      
      protected function setLabel($name:String) : void
      {
         this.targetName = $name;
         this.deleteLabel();
         var url:String = "assets/nameboder/" + this.targetName + ".swf";
         NameLabelLoader.instance.load(url,this.getLabel,this.targetName);
      }
      
      private function getLabel(value:Object) : void
      {
         this.label = value as MovieClip;
         if(Boolean(this.label))
         {
            this.showLabel();
         }
      }
      
      protected function updateP() : void
      {
         this.label.x = int(-this.label.width / 2);
         this.label.y = 0;
      }
      
      protected function showLabel() : void
      {
         addChild(this.label);
      }
      
      protected function deleteLabel() : void
      {
         if(Boolean(this.label))
         {
            if(Boolean(this.label.parent))
            {
               this.label.parent.removeChild(this.label);
            }
            this.label = null;
         }
      }
      
      protected function getNameString($name:String, $color:int) : String
      {
         var color:String = null;
         switch($color)
         {
            case 1:
               color = "#FF0000";
               break;
            case 2:
               color = "#FFFF00";
               break;
            case 3:
               color = "#CC66FF";
               break;
            case 4:
               color = "#0000FF";
               break;
            case 5:
               color = "#CCFF33";
               break;
            case 6:
               color = "#FFFFFF";
               break;
            default:
               color = "#FFFFFF";
         }
         return this.toHtmlString($name,color);
      }
      
      protected function toHtmlString($name:String, $color:String) : String
      {
         return "<font color=\'" + $color + "\'>" + $name + "</font>";
      }
      
      protected function getFilters($index:int) : Array
      {
         var color:uint = 0;
         switch($index)
         {
            case 1:
               color = 3355443;
               break;
            case 2:
               color = 16737792;
               break;
            case 3:
               color = 6684774;
               break;
            case 4:
               color = 5881829;
               break;
            case 5:
               color = 3368499;
               break;
            case 6:
               color = 6710886;
               break;
            default:
               color = 6710886;
         }
         if(color == 0)
         {
            return null;
         }
         return [new GlowFilter(color,1,3,3,370)];
      }
      
      public function disport() : void
      {
         this.deleteLabel();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

