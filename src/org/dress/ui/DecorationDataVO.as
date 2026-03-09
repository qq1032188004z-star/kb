package org.dress.ui
{
   import flash.utils.ByteArray;
   
   public class DecorationDataVO
   {
      
      private var _timesCited:int;
      
      public var pStep:int;
      
      public var pWidth:int;
      
      public var pHeight:int;
      
      public var bitmapDataArr:Array;
      
      public var tempByteBuf:ByteArray;
      
      private var temp_data:MyBitmapData;
      
      public function DecorationDataVO()
      {
         super();
      }
      
      public function build(bitData:ByteArray) : void
      {
         if(Boolean(bitData))
         {
            bitData.position = 0;
            this.tempByteBuf = bitData;
            this.bitmapDataArr = new Array();
            this.pStep = bitData.readInt();
            this.pWidth = bitData.readInt();
            this.pHeight = bitData.readInt();
            if(this.pStep > 0)
            {
               this.splitBuf();
            }
         }
         else
         {
            this.dispose();
         }
      }
      
      public function dispose() : void
      {
         var len:int = 0;
         var dataList:Array = null;
         var i:int = 0;
         if(Boolean(this.bitmapDataArr) && this.bitmapDataArr.length > 0)
         {
            len = int(this.bitmapDataArr.length);
            for(i = 0; i < len; i++)
            {
               dataList = this.bitmapDataArr[i];
               while(Boolean(dataList) && dataList.length > 0)
               {
                  dataList.pop().dispos();
               }
            }
            this.bitmapDataArr.length = 0;
            this.bitmapDataArr = null;
         }
      }
      
      public function splitBuf() : void
      {
         var len:int = 0;
         var ba:ByteArray = null;
         var tempArr:Array = [];
         var i:int = 0;
         while(i < this.pStep && Boolean(this.tempByteBuf.bytesAvailable))
         {
            len = this.tempByteBuf.readInt();
            ba = new ByteArray();
            if(this.tempByteBuf.bytesAvailable < len)
            {
               break;
            }
            this.tempByteBuf.readBytes(ba,0,len);
            ba.uncompress();
            this.temp_data = new MyBitmapData();
            this.temp_data.build(ba);
            tempArr.push(this.temp_data);
            i++;
         }
         this.bitmapDataArr.push(tempArr);
         if(Boolean(this.tempByteBuf.bytesAvailable))
         {
            this.splitBuf();
         }
         else
         {
            this.tempByteBuf.clear();
            this.tempByteBuf = null;
         }
      }
      
      public function checkIn() : void
      {
         ++this._timesCited;
      }
      
      public function checkOut() : void
      {
         if(this._timesCited > 0)
         {
            --this._timesCited;
         }
      }
      
      public function canDispose() : Boolean
      {
         return this._timesCited == 0;
      }
   }
}

