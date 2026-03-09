package com.game.modules.archives.data.hbtask
{
   import com.publiccomponent.loading.XMLLocator;
   
   public class HBAwardVO
   {
      
      public var coin:int;
      
      public var exp:int;
      
      public var cultive:int;
      
      public var cultiveType:int;
      
      public var kbCoin:int;
      
      public var kbMoney:int;
      
      public var goodID:int;
      
      public var goodNum:int;
      
      public var goodName:String;
      
      public var content:String = "";
      
      private var blankStr:String = "   ";
      
      public function HBAwardVO()
      {
         super();
      }
      
      public function serialize() : void
      {
         var xml:XML = null;
         if(this.coin > 0)
         {
            this.content += this.coin + "铜钱" + this.blankStr;
         }
         if(this.exp > 0)
         {
            this.content += this.exp + "历练" + this.blankStr;
         }
         if(this.cultive > 0)
         {
            this.content += this.cultive + this.parseCultive(this.cultiveType) + this.blankStr;
         }
         if(this.kbCoin > 0)
         {
            this.content += this.kbCoin + "卡布币" + this.blankStr;
         }
         if(this.kbMoney > 0)
         {
            this.content += this.kbMoney + "未知货币" + this.blankStr;
         }
         if(this.goodID != 0)
         {
            this.goodName = this.getGoodName(this.goodID);
         }
      }
      
      private function parseCultive(type:int) : String
      {
         var str:String = "";
         return "点随机修为";
      }
      
      private function getGoodName(id:int) : String
      {
         var str:String = "";
         var xml:XML = XMLLocator.getInstance().getTool(id);
         if(xml != null)
         {
            str = xml.name.toString();
         }
         return str;
      }
   }
}

