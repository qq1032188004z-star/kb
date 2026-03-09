package org.dress.ui
{
   public class BaseWing extends BaseDecoration
   {
      
      public function BaseWing(rowCount:int = 4, decorationType:int = 8)
      {
         super(rowCount,decorationType);
      }
      
      override public function load(url:String, mapkey:String, callBack:Function = null) : void
      {
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
   }
}

