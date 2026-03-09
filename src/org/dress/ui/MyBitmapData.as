package org.dress.ui
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class MyBitmapData
   {
      
      public var x:int;
      
      public var y:int;
      
      public var width:int;
      
      public var height:int;
      
      private var bitStr:ByteArray;
      
      private var rect:Rectangle;
      
      private var _bit_data:BitmapData;
      
      public function MyBitmapData()
      {
         super();
      }
      
      public function build(byteArrary:ByteArray) : void
      {
         this.x = byteArrary.readInt();
         this.y = byteArrary.readInt();
         this.width = byteArrary.readInt();
         this.height = byteArrary.readInt();
         this.width = this.width == 0 ? 1 : this.width;
         this.height = this.height == 0 ? 1 : this.height;
         this.bitStr = new ByteArray();
         this.bitStr.writeBytes(byteArrary,byteArrary.position);
      }
      
      public function get bit_data() : BitmapData
      {
         if(this._bit_data == null)
         {
            this.setB_data(this.bitStr);
         }
         return this._bit_data;
      }
      
      public function setB_data(value:ByteArray) : void
      {
         if(value == null)
         {
            return;
         }
         value.position = 0;
         this._bit_data = new BitmapData(this.width,this.height,true,0);
         if(value.bytesAvailable != 0)
         {
            this._bit_data.setPixels(new Rectangle(0,0,this.width,this.height),value);
         }
         if(Boolean(value))
         {
            value.clear();
            value = null;
         }
      }
      
      public function dispos() : void
      {
         if(Boolean(this.bitStr))
         {
            if(this.bitStr.hasOwnProperty("clear"))
            {
               this.bitStr["clear"]();
            }
            this.bitStr = null;
         }
         if(Boolean(this._bit_data))
         {
            this._bit_data.dispose();
         }
         this._bit_data = null;
      }
   }
}

