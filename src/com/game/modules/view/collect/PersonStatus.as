package com.game.modules.view.collect
{
   import com.publiccomponent.loading.MaterialLib;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class PersonStatus extends Sprite
   {
      
      public var statusMc:MovieClip;
      
      private var stateName:String;
      
      private var showData:Object;
      
      public function PersonStatus(xCoord:int, yCoord:int)
      {
         super();
         this.x = xCoord;
         this.y = yCoord;
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.cacheAsBitmap = true;
      }
      
      public function setStatus(str:String, $showData:Object = null) : void
      {
         this.stateName = str;
         this.showData = $showData;
         this.statusMc = MaterialLib.getInstance().getMaterial(str) as MovieClip;
         if(this.stateName == "gharryClip")
         {
            this.showName();
            this.updateBattle(false);
         }
         else if(str != "fight" && str != "temLeave")
         {
            this.statusMc.width = 60;
            this.statusMc.height = 60;
         }
         this.addChild(this.statusMc);
      }
      
      private function showName() : void
      {
         var colorStr:String = "";
         if(this.showData.bodyID == 111 || this.showData.bodyID == 121)
         {
            colorStr = "#FFFFFF";
         }
         else if(this.showData.bodyID == 112 || this.showData.bodyID == 122)
         {
            colorStr = "#00FFFF";
         }
         else if(this.showData.bodyID == 113 || this.showData.bodyID == 123)
         {
            colorStr = "#0000FF";
         }
         else if(this.showData.bodyID == 114 || this.showData.bodyID == 124)
         {
            colorStr = "#9900CC";
         }
         if(colorStr == "")
         {
            this.statusMc.nameTxt.htmlText = this.showData.userName;
         }
         else
         {
            this.statusMc.nameTxt.htmlText = "<font color=\'" + colorStr + "\'>" + this.showData.userName + "的马车</font>";
         }
      }
      
      public function updateBattle(flag:Boolean = false) : void
      {
         if(Boolean(this.statusMc) && Boolean(this.statusMc.hasOwnProperty("battleIcon")))
         {
            if(flag)
            {
               this.statusMc.battleIcon.play();
               this.statusMc.battleIcon.visible = true;
            }
            else
            {
               this.statusMc.battleIcon.stop();
               this.statusMc.battleIcon.visible = false;
            }
         }
      }
      
      public function removeStatus() : void
      {
         this.removeChild(this.statusMc);
         this.statusMc.stop();
         this.statusMc = null;
      }
      
      public function clear() : void
      {
         if(this.statusMc != null && this.contains(this.statusMc))
         {
            this.removeChild(this.statusMc);
            this.statusMc.stop();
            this.statusMc = null;
         }
      }
      
      public function dispos() : void
      {
         if(this.statusMc != null && this.contains(this.statusMc))
         {
            this.removeChild(this.statusMc);
            this.statusMc.stop();
            this.statusMc = null;
         }
         if(this.parent != null)
         {
            if(this.parent.contains(this))
            {
               this.parent.removeChild(this);
            }
         }
      }
   }
}

