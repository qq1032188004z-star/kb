package com.game.modules.view.family
{
   import com.game.util.ColorUtil;
   import com.publiccomponent.list.TileList;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class FamilyBar
   {
      
      private var tileList:TileList;
      
      private var provider:Array;
      
      private var btn1:SimpleButton;
      
      private var btn2:SimpleButton;
      
      private var btn3:MovieClip;
      
      private var flag:Boolean;
      
      private var low:Number;
      
      private var high:Number;
      
      private var speed:Number;
      
      private var index:int;
      
      private var number:int;
      
      private var length:int;
      
      private var originalY:Number;
      
      public function FamilyBar($_tileList:TileList, _provider:Array, $_btn1:SimpleButton, $_btn3:MovieClip, $_btn2:SimpleButton, _flag:Boolean)
      {
         super();
         this.tileList = $_tileList;
         this.provider = _provider;
         this.btn1 = $_btn1;
         this.btn2 = $_btn2;
         this.btn3 = $_btn3;
         this.btn3.buttonMode = true;
         this.flag = _flag;
         if(this.flag)
         {
            this.initActionX();
         }
         else
         {
            this.initActionY();
         }
      }
      
      private function initActionX() : void
      {
         this.low = this.btn1.x + this.btn1.width + this.btn3.width;
         this.high = this.btn2.x - this.btn2.width;
         this.btn3.x = this.low;
         this.index = 0;
         this.number = this.tileList.columnCount * this.tileList.rowCount;
         if(this.number >= this.provider.length)
         {
            this.btn1.mouseEnabled = false;
            this.btn2.mouseEnabled = false;
            this.btn3.mouseEnabled = false;
            this.btn1.filters = ColorUtil.getColorMatrixFilterGray();
            this.btn2.filters = ColorUtil.getColorMatrixFilterGray();
            this.btn3.filters = ColorUtil.getColorMatrixFilterGray();
            return;
         }
         this.length = (this.provider.length - this.number) % this.tileList.rowCount == 0 ? 0 : 1;
         this.length += (this.provider.length - this.number) / this.tileList.rowCount;
         if(this.length == 0)
         {
            return;
         }
         this.speed = (this.high - this.low) / this.length;
         if(this.speed <= 0)
         {
            this.btn1.mouseEnabled = false;
            this.btn2.mouseEnabled = false;
            this.btn3.mouseEnabled = false;
            this.btn1.filters = ColorUtil.getColorMatrixFilterGray();
            this.btn2.filters = ColorUtil.getColorMatrixFilterGray();
            this.btn3.filters = ColorUtil.getColorMatrixFilterGray();
            return;
         }
         this.btn1.addEventListener(MouseEvent.CLICK,this.onBtn1);
         this.btn2.addEventListener(MouseEvent.CLICK,this.onBtn2);
         this.btn3.addEventListener(MouseEvent.MOUSE_DOWN,this.onBtn3_down);
      }
      
      private function onBtn1(evt:MouseEvent) : void
      {
         if(this.btn3.x - this.speed / 2 < this.low || this.index <= 0)
         {
            return;
         }
         this.btn3.x -= this.speed;
         this.index -= this.tileList.rowCount;
         this.tileList.dataProvider = this.provider.slice(this.index,this.index + this.number);
      }
      
      private function onBtn2(evt:MouseEvent) : void
      {
         if(this.btn3.x + this.speed / 2 > this.high)
         {
            return;
         }
         this.btn3.x += this.speed;
         this.index += this.tileList.rowCount;
         this.tileList.dataProvider = this.provider.slice(this.index,this.index + this.number);
      }
      
      private function onBtn3_down(evt:MouseEvent) : void
      {
         this.originalY = this.btn3.y;
         var dragRect:Rectangle = new Rectangle(this.low,this.btn3.y,this.high - this.low,0.1);
         this.btn3.startDrag(false,dragRect);
         this.btn3.stage.addEventListener(MouseEvent.MOUSE_UP,this.onBtn3_up);
      }
      
      private function onBtn3_up(evt:MouseEvent) : void
      {
         this.btn3.stopDrag();
         this.btn3.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onBtn3_up);
         this.btn3.y = this.originalY;
         if(this.btn3.x < this.low)
         {
            this.btn3.x = this.low;
         }
         if(this.btn3.x > this.high)
         {
            this.btn3.x = this.high;
         }
         var temp:int = Math.round(this.btn3.x - this.low + this.speed / 2) / Math.round(this.speed);
         this.btn3.x = this.low + temp * this.speed;
         this.index = temp * this.tileList.rowCount;
         this.tileList.dataProvider = this.provider.slice(this.index,this.index + this.number);
      }
      
      private function initActionY() : void
      {
         this.low = this.btn1.y + this.btn1.height + this.btn3.height;
         this.high = this.btn2.y - this.btn2.height;
         this.btn3.y = this.low;
         this.index = 0;
         this.number = this.tileList.columnCount * this.tileList.rowCount;
         if(this.number >= this.provider.length)
         {
            this.btn1.mouseEnabled = false;
            this.btn2.mouseEnabled = false;
            this.btn3.mouseEnabled = false;
            this.btn1.filters = ColorUtil.getColorMatrixFilterGray();
            this.btn2.filters = ColorUtil.getColorMatrixFilterGray();
            this.btn3.filters = ColorUtil.getColorMatrixFilterGray();
            return;
         }
         this.length = (this.provider.length - this.number) % this.tileList.columnCount == 0 ? 0 : 1;
         this.length += (this.provider.length - this.number) / this.tileList.columnCount;
         if(this.length == 0)
         {
            return;
         }
         this.speed = (this.high - this.low) / this.length;
         if(this.speed <= 0)
         {
            this.btn1.mouseEnabled = false;
            this.btn2.mouseEnabled = false;
            this.btn3.mouseEnabled = false;
            this.btn1.filters = ColorUtil.getColorMatrixFilterGray();
            this.btn2.filters = ColorUtil.getColorMatrixFilterGray();
            this.btn3.filters = ColorUtil.getColorMatrixFilterGray();
            return;
         }
         this.btn1.addEventListener(MouseEvent.CLICK,this.onBtn1_Y);
         this.btn2.addEventListener(MouseEvent.CLICK,this.onBtn2_Y);
         this.btn3.addEventListener(MouseEvent.MOUSE_DOWN,this.onBtn3_down_Y);
      }
      
      private function onBtn1_Y(evt:MouseEvent) : void
      {
         if(this.btn3.y - this.speed / 2 < this.low || this.index <= 0)
         {
            return;
         }
         this.btn3.y -= this.speed;
         this.index -= this.tileList.columnCount;
         this.tileList.dataProvider = this.provider.slice(this.index,this.index + this.number);
      }
      
      private function onBtn2_Y(evt:MouseEvent) : void
      {
         if(this.btn3.y + this.speed / 2 > this.high || this.index + this.number >= this.provider.length)
         {
            return;
         }
         this.btn3.y += this.speed;
         this.index += this.tileList.columnCount;
         this.tileList.dataProvider = this.provider.slice(this.index,this.index + this.number);
      }
      
      private function onBtn3_down_Y(evt:MouseEvent) : void
      {
         this.originalY = this.btn3.x;
         var dragRect:Rectangle = new Rectangle(this.btn3.x,this.low,0.1,this.high - this.low);
         this.btn3.startDrag(false,dragRect);
         this.btn3.stage.addEventListener(MouseEvent.MOUSE_UP,this.onBtn3_up_Y);
      }
      
      private function onBtn3_up_Y(evt:MouseEvent) : void
      {
         this.btn3.stopDrag();
         this.btn3.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onBtn3_up_Y);
         this.btn3.x = this.originalY;
         if(this.btn3.y < this.low)
         {
            this.btn3.y = this.low;
         }
         if(this.btn3.y > this.high)
         {
            this.btn3.y = this.high;
         }
         var temp:int = Math.round(this.btn3.y - this.low + this.speed / 2) / Math.round(this.speed);
         this.btn3.y = this.low + temp * this.speed;
         this.index = temp * this.tileList.columnCount;
         this.tileList.dataProvider = this.provider.slice(this.index,this.index + this.number);
      }
      
      public function dipos() : void
      {
         if(this.flag)
         {
            this.btn1.removeEventListener(MouseEvent.CLICK,this.onBtn1);
            this.btn2.removeEventListener(MouseEvent.CLICK,this.onBtn2);
            this.btn3.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBtn3_down);
         }
         else
         {
            this.btn1.removeEventListener(MouseEvent.CLICK,this.onBtn1_Y);
            this.btn2.removeEventListener(MouseEvent.CLICK,this.onBtn2_Y);
            this.btn3.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBtn3_down_Y);
         }
      }
   }
}

