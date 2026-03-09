package org.dress.ui
{
   public class BaseWingTeXiao extends BaseDecoration
   {
      
      private var myPointer:int;
      
      private var renderMode:int = 0;
      
      public function BaseWingTeXiao(rowCount:int = 4, decorationType:int = 8)
      {
         super(rowCount,decorationType);
      }
      
      override public function load(url:String, mapkey:String, callBack:Function = null) : void
      {
         this.renderMode = 1;
         if(url.indexOf("big") != -1)
         {
            ux = bxtemp;
            uy = bytemp;
         }
         else
         {
            ux = xtemp;
            uy = ytemp;
         }
         super.load(url,mapkey,callBack);
      }
      
      override public function splitOver() : void
      {
         super.splitOver();
         if(url.indexOf("big") != -1)
         {
            ux = bxtemp;
            uy = bytemp;
         }
         this.render();
      }
      
      override public function render(direction:int = 0, pointer:int = 0) : void
      {
         if(Boolean(decorationVo) && this.renderMode == 1)
         {
            if(this.myPointer < decorationVo.pStep - 1)
            {
               ++this.myPointer;
            }
            else
            {
               this.myPointer = 0;
            }
            super.render(direction,this.myPointer);
         }
         else
         {
            super.render(direction,pointer);
         }
      }
   }
}

