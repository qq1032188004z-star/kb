package org.dress.ui
{
   import com.publiccomponent.URLUtil;
   import flash.display.Bitmap;
   import org.dress.util.MaterialLimiteLoader;
   
   public class BaseDecoration extends Bitmap
   {
      
      protected var rowCount:int;
      
      public var url:String;
      
      protected var decorationType:int;
      
      private var callBack:Function;
      
      protected var decorationVo:DecorationDataVO;
      
      private var temp_data:MyBitmapData;
      
      private var currentId:int;
      
      public var xtemp:int = 55;
      
      public var ytemp:int = 40;
      
      public var bxtemp:int = 55;
      
      public var bytemp:int = 40;
      
      public var ux:int = 55;
      
      public var uy:int = 40;
      
      protected var _lastData:Array;
      
      private var tempMy:MyBitmapData;
      
      private var tempd:int = 0;
      
      private var tempp:int = 0;
      
      public function BaseDecoration(rowCount:int = 4, decorationType:int = 0)
      {
         super();
         this.rowCount = rowCount;
         this.decorationType = decorationType;
         this.onForceUpdates();
      }
      
      public function load(url:String, mapkey:String, callBack:Function = null) : void
      {
         this.url = URLUtil.getSvnVer(url);
         this.callBack = callBack;
         MaterialLimiteLoader.getInstance().excuteLoad(this);
      }
      
      private function getId() : int
      {
         var startIndex:int = int(this.url.lastIndexOf("/"));
         var endIndex:int = int(this.url.lastIndexOf("."));
         return int(this.url.substring(startIndex + 1,endIndex));
      }
      
      public function onLoadComplement(decorationData:DecorationDataVO) : void
      {
         if(Boolean(this.decorationVo))
         {
            this.decorationVo.checkOut();
         }
         this.decorationVo = decorationData;
         this.decorationVo.checkIn();
         this.splitOver();
      }
      
      public function splitOver() : void
      {
         this.temp_data = this.decorationVo.bitmapDataArr[0][0];
         if(this.callBack != null)
         {
            this.callBack.apply(null,[{
               "step":this.decorationVo.pStep,
               "height":this.temp_data.height,
               "width":this.temp_data.width
            }]);
         }
         this.callBack = null;
         if(this.decorationVo.pStep == 1 && (this.tempp == 0 || this.tempp == 4))
         {
            this.ux = this.bxtemp;
            this.uy = this.bytemp;
         }
         else
         {
            this.ux = this.xtemp;
            this.uy = this.ytemp;
         }
         this.onForceUpdates();
         if(this.decorationVo.pStep <= this.tempp)
         {
            this.render();
         }
         else
         {
            this.render(this.tempd,this.tempp);
         }
      }
      
      public function dispos() : void
      {
         if(Boolean(this.decorationVo))
         {
            this.decorationVo.checkOut();
            this.decorationVo = null;
         }
         if(Boolean(this.bitmapData))
         {
            this.bitmapData = null;
         }
         this.url = "";
         MaterialLimiteLoader.getInstance().deleteDecor(this);
         if(this.parent != null)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function onForceUpdates() : void
      {
         this._lastData = [-1,-1];
      }
      
      public function render(direction:int = 0, pointer:int = 0) : void
      {
         if(this._lastData[0] == direction && this._lastData[1] == pointer)
         {
            return;
         }
         this._lastData[0] = direction;
         this._lastData[1] = pointer;
         if((this.tempd | this.tempp) == 0 && (direction != 0 || pointer != 0))
         {
            this.tempd = direction;
            this.tempp = pointer;
         }
         if(direction == 2)
         {
            direction = 0;
            this.scaleX = -1;
         }
         else if(direction == 3)
         {
            direction = 1;
            this.scaleX = -1;
         }
         else
         {
            this.scaleX = 1;
         }
         if(Boolean(this.decorationVo) && this.decorationVo.bitmapDataArr[direction] != null)
         {
            this.tempMy = this.decorationVo.bitmapDataArr[direction][pointer];
            if(this.tempMy != null)
            {
               if(this.scaleX == -1)
               {
                  this.x = -this.tempMy.x + this.ux;
               }
               else
               {
                  this.x = -(this.decorationVo.pWidth - this.tempMy.x) + this.ux;
               }
               if(this.decorationType == 7)
               {
                  this.y = -(this.decorationVo.pHeight - this.tempMy.y) + this.uy;
               }
               else
               {
                  this.y = -(this.decorationVo.pHeight - this.tempMy.y) + (this.uy - 40);
               }
               bitmapData = this.tempMy.bit_data;
            }
         }
      }
   }
}

