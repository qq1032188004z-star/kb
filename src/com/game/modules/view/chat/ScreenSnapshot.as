package com.game.modules.view.chat
{
   import com.game.manager.MouseManager;
   import com.game.util.JPGEncoder;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   
   public class ScreenSnapshot extends Sprite
   {
      
      public static var phpurl:String;
      
      public static var style:Array = [null,255];
      
      public static const POINT:int = 0;
      
      public static const COLOR:uint = 1;
      
      public static const BAR:uint = 2;
      
      public static var TAG:String = "[unknown]";
      
      private var points:Array = [];
      
      public var target:Sprite;
      
      private var ltPoint:Point = new Point();
      
      private var rbPoint:Point = new Point();
      
      private var p1:Point = new Point();
      
      private var p2:Point = new Point();
      
      private var startPoint:Point = new Point();
      
      private var startX:int;
      
      private var startY:int;
      
      private var bar:Sprite;
      
      private var paintPanel:Sprite;
      
      private var drawStartPoint:Point = new Point();
      
      private var draws:Array = [];
      
      public function ScreenSnapshot(w:int, h:int)
      {
         super();
         this.initListeners();
         this.initFace();
         this.p1.x = 0;
         this.p1.y = 0;
         this.p2.x = w;
         this.p2.y = h;
         this.draw(this.p1,this.p2);
         this.resetPoint();
         this.resetPointsPos();
         this.resetBar();
      }
      
      private function resetBar() : void
      {
         this.bar.x = this.rbPoint.x - this.bar.width;
         this.bar.y = this.rbPoint.y + 5;
      }
      
      private function initFace() : void
      {
         for(var i:int = 0; i < 8; i++)
         {
            this.points[i] = new style[POINT]();
            Sprite(this.points[i]).addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownPoint);
            Sprite(this.points[i]).addEventListener(MouseEvent.ROLL_OVER,this.onRollOverPoint);
            Sprite(this.points[i]).addEventListener(MouseEvent.ROLL_OUT,this.onRollOutPoint);
            this.addChild(this.points[i]);
         }
         this.bar = new style[BAR]();
         this.bar.getChildByName("okBtn").addEventListener(MouseEvent.CLICK,this.onOk);
         this.bar.getChildByName("closeBtn").addEventListener(MouseEvent.CLICK,this.onClose);
         this.bar.getChildByName("saveBtn").addEventListener(MouseEvent.CLICK,this.onSave);
         this.bar.getChildByName("cancelBtn").addEventListener(MouseEvent.CLICK,this.onCancel);
         this.bar.getChildByName("textBtn").addEventListener(MouseEvent.CLICK,this.onText);
         this.bar.getChildByName("arrowBtn").addEventListener(MouseEvent.CLICK,this.onArrow);
         this.bar.getChildByName("circleBtn").addEventListener(MouseEvent.CLICK,this.onCircle);
         this.bar.getChildByName("rectBtn").addEventListener(MouseEvent.CLICK,this.onRect);
         this.addChild(this.bar);
      }
      
      private function onClose(e:MouseEvent) : void
      {
         this.dispatchEvent(new SnapShotEvent(SnapShotEvent.CLOSE));
      }
      
      private function onSave(e:MouseEvent) : void
      {
         var bd:BitmapData = this.savebitmapdata();
         var encoder:JPGEncoder = new JPGEncoder();
         var stream:ByteArray = encoder.encode(bd);
         var loader:URLLoader = new URLLoader();
         var header:URLRequestHeader = new URLRequestHeader("Content-type","application/octet-stream");
         var request:URLRequest = new URLRequest(phpurl + "?tag=" + TAG);
         request.requestHeaders.push(header);
         request.method = URLRequestMethod.POST;
         request.data = stream;
         loader.addEventListener(Event.COMPLETE,this.onSaveComplete);
         loader.addEventListener(IOErrorEvent.IO_ERROR,this.onSaveError);
         loader.load(request);
      }
      
      private function onSaveComplete(e:Event) : void
      {
         var loader:URLLoader = e.target as URLLoader;
         navigateToURL(new URLRequest(loader.data));
      }
      
      private function onSaveError(e:Event) : void
      {
         O.o("ScreenSnapshot - onSaveError");
      }
      
      private function onCancel(e:MouseEvent) : void
      {
         if(this.draws.length <= 0)
         {
            return;
         }
         for(var last:DisplayObject = this.draws.pop(); last == null; )
         {
            last = this.draws.pop();
         }
         this.paintPanel.removeChild(last);
      }
      
      private function savebitmapdata() : BitmapData
      {
         var bd:BitmapData = new BitmapData(this.rbPoint.x - this.ltPoint.x,this.rbPoint.y - this.ltPoint.y);
         var dest:DisplayObject = this.target;
         if(dest == null)
         {
            dest = this.parent as DisplayObject;
         }
         if(dest == null)
         {
            return null;
         }
         var m:Matrix = new Matrix();
         m.tx = -(this.ltPoint.x + this.x);
         m.ty = -(this.ltPoint.y + this.y);
         this.visible = false;
         bd.draw(dest,m);
         this.visible = true;
         if(this.paintPanel != null)
         {
            bd.draw(this.paintPanel);
         }
         return bd;
      }
      
      private function onOk(e:MouseEvent) : void
      {
         var bd:BitmapData = this.savebitmapdata();
         var encoder:JPGEncoder = new JPGEncoder();
         var stream:ByteArray = encoder.encode(bd);
         var loader:URLLoader = new URLLoader();
         var header:URLRequestHeader = new URLRequestHeader("Content-type","application/octet-stream");
         var request:URLRequest = new URLRequest(phpurl + "?tag=" + TAG);
         request.requestHeaders.push(header);
         request.method = URLRequestMethod.POST;
         request.data = stream;
         loader.addEventListener(Event.COMPLETE,this.onSaveOk);
         loader.addEventListener(IOErrorEvent.IO_ERROR,this.onSaveError);
         loader.load(request);
      }
      
      private function onSaveOk(e:Event) : void
      {
         var loader:URLLoader = e.target as URLLoader;
         var url:String = loader.data;
         url = "event:" + url.substr(7,url.length);
         this.dispatchEvent(new SnapShotEvent(SnapShotEvent.SAVE,url));
      }
      
      private function onText(e:MouseEvent) : void
      {
         this.setPaintPanel();
         this.paintPanel.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDrawRect);
         this.paintPanel.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDrawCircle);
         this.paintPanel.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDrawArrow);
         this.paintPanel.addEventListener(MouseEvent.MOUSE_DOWN,this.onDrawText);
      }
      
      private function onDrawText(e:MouseEvent) : void
      {
         var text:TextField = new TextField();
         text.type = TextFieldType.INPUT;
         text.addEventListener(MouseEvent.CLICK,this.onClickText);
         text.addEventListener(Event.CHANGE,this.onChangeText);
         text.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOutText);
         text.addEventListener(MouseEvent.MOUSE_DOWN,this.onClickText);
         this.paintPanel.addChild(text);
         text.x = this.paintPanel.mouseX;
         text.y = this.paintPanel.mouseY;
         text.border = true;
         text.multiline = true;
         text.wordWrap = true;
         text.height = 30;
         text.text = "在这里输入";
         text.textColor = 16711680;
         text.setSelection(0,text.length);
         text.background = true;
         text.backgroundColor = 16777215;
         text.width = text.textWidth + 10;
         if(text.width + text.x >= this.rbPoint.x)
         {
            text.x = this.rbPoint.x - text.width;
         }
         if(text.height + text.y >= this.rbPoint.y)
         {
            text.y = this.rbPoint.y - text.height;
         }
         this.stage.focus = text;
         if(this.draws.length == 0 || this.draws[this.draws.length - 1] != null)
         {
            this.draws.push(text);
         }
         else
         {
            this.draws[this.draws.length - 1] = text;
         }
      }
      
      private function onFocusOutText(e:FocusEvent) : void
      {
         var text:TextField = e.target as TextField;
         text.border = false;
         text.background = false;
         if(text.text == "在这里输入")
         {
            this.paintPanel.removeChild(text);
            this.draws.pop();
         }
         text.removeEventListener(MouseEvent.CLICK,this.onClickText);
         text.removeEventListener(Event.CHANGE,this.onChangeText);
         text.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOutText);
         text.removeEventListener(MouseEvent.MOUSE_DOWN,this.onClickText);
      }
      
      private function onChangeText(e:Event) : void
      {
         var text:TextField = e.target as TextField;
         if(text.textWidth + 20 > text.width)
         {
            text.width = text.textWidth + 40;
            if(text.width + text.x >= this.rbPoint.x)
            {
               text.width = this.rbPoint.x - text.x;
            }
         }
         text.height = text.textHeight + 10;
         if(text.y + text.height > this.rbPoint.y)
         {
            text.height = this.rbPoint.y - text.y;
         }
         text.scrollV = 0;
      }
      
      private function onClickText(e:MouseEvent) : void
      {
         e.stopPropagation();
      }
      
      private function onArrow(e:MouseEvent) : void
      {
         this.setPaintPanel();
         this.paintPanel.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDrawRect);
         this.paintPanel.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDrawCircle);
         this.paintPanel.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDrawText);
         this.paintPanel.addEventListener(MouseEvent.MOUSE_DOWN,this.onDrawArrow);
      }
      
      private function onDrawArrow(e:MouseEvent) : void
      {
         var last:DisplayObject = this.draws[this.draws.length - 1];
         if(last != null || this.draws.length == 0)
         {
            this.draws.push(null);
         }
         this.drawStartPoint.x = this.paintPanel.mouseX;
         this.drawStartPoint.y = this.paintPanel.mouseY;
         this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDrawArrowMove);
         this.stage.addEventListener(MouseEvent.MOUSE_UP,this.onDrawArrowUp);
      }
      
      private function onDrawArrowMove(e:MouseEvent) : void
      {
         var last:Sprite = this.draws[this.draws.length - 1];
         if(last == null)
         {
            last = new Sprite();
            this.draws[this.draws.length - 1] = last;
            this.paintPanel.addChild(last);
         }
         var mx:Number = Math.max(0,this.paintPanel.mouseX);
         var my:Number = Math.max(0,this.paintPanel.mouseY);
         mx = Math.min(mx,this.rbPoint.x);
         my = Math.min(my,this.rbPoint.y);
         var dx:Number = mx - this.drawStartPoint.x;
         var dy:Number = my - this.drawStartPoint.y;
         var a:Number = Math.atan2(dy,dx);
         var r:Number = Math.sqrt(dx * dx + dy * dy);
         last.graphics.clear();
         last.graphics.lineStyle(1,16711680);
         last.graphics.moveTo(0,0);
         last.graphics.lineTo(0,-r);
         last.graphics.beginFill(16711680);
         last.graphics.moveTo(0,-r);
         last.graphics.lineTo(3,-r + 8);
         last.graphics.lineTo(-3,-r + 8);
         last.graphics.lineTo(0,-r);
         last.graphics.endFill();
         last.x = this.drawStartPoint.x;
         last.y = this.drawStartPoint.y;
         last.rotation = a * 180 / Math.PI + 90;
      }
      
      private function onDrawArrowUp(e:MouseEvent) : void
      {
         this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDrawArrowMove);
         this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDrawArrowUp);
      }
      
      private function onCircle(e:MouseEvent) : void
      {
         this.setPaintPanel();
         this.paintPanel.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDrawRect);
         this.paintPanel.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDrawArrow);
         this.paintPanel.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDrawText);
         this.paintPanel.addEventListener(MouseEvent.MOUSE_DOWN,this.onDrawCircle);
      }
      
      private function onDrawCircle(e:MouseEvent) : void
      {
         var last:DisplayObject = this.draws[this.draws.length - 1];
         if(last != null || this.draws.length == 0)
         {
            this.draws.push(null);
         }
         this.drawStartPoint.x = this.paintPanel.mouseX;
         this.drawStartPoint.y = this.paintPanel.mouseY;
         this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDrawCircleMove);
         this.stage.addEventListener(MouseEvent.MOUSE_UP,this.onDrawCircleUp);
      }
      
      private function onDrawCircleMove(e:MouseEvent) : void
      {
         var last:Sprite = this.draws[this.draws.length - 1];
         if(last == null)
         {
            last = new Sprite();
            this.draws[this.draws.length - 1] = last;
            this.paintPanel.addChild(last);
         }
         var mx:Number = Math.max(0,this.paintPanel.mouseX);
         var my:Number = Math.max(0,this.paintPanel.mouseY);
         mx = Math.min(mx,this.rbPoint.x);
         my = Math.min(my,this.rbPoint.y);
         last.graphics.clear();
         last.graphics.lineStyle(1,16711680);
         last.graphics.beginFill(16711680,0);
         last.graphics.drawEllipse(this.drawStartPoint.x,this.drawStartPoint.y,mx - this.drawStartPoint.x,my - this.drawStartPoint.y);
         last.graphics.endFill();
      }
      
      private function onDrawCircleUp(e:MouseEvent) : void
      {
         this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDrawCircleMove);
         this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDrawCircleUp);
      }
      
      private function onRect(e:MouseEvent) : void
      {
         this.setPaintPanel();
         this.paintPanel.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDrawCircle);
         this.paintPanel.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDrawRect);
         this.paintPanel.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDrawText);
         this.paintPanel.addEventListener(MouseEvent.MOUSE_DOWN,this.onDrawRect);
      }
      
      private function onDrawRect(e:MouseEvent) : void
      {
         var last:DisplayObject = this.draws[this.draws.length - 1];
         if(last != null || this.draws.length == 0)
         {
            this.draws.push(null);
         }
         this.drawStartPoint.x = this.paintPanel.mouseX;
         this.drawStartPoint.y = this.paintPanel.mouseY;
         this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDrawRectMove);
         this.stage.addEventListener(MouseEvent.MOUSE_UP,this.onDrawRectUp);
      }
      
      private function onDrawRectMove(e:MouseEvent) : void
      {
         var last:Sprite = this.draws[this.draws.length - 1];
         if(last == null)
         {
            last = new Sprite();
            this.draws[this.draws.length - 1] = last;
            this.paintPanel.addChild(last);
         }
         var mx:Number = Math.max(0,this.paintPanel.mouseX);
         var my:Number = Math.max(0,this.paintPanel.mouseY);
         mx = Math.min(mx,this.rbPoint.x);
         my = Math.min(my,this.rbPoint.y);
         last.graphics.clear();
         last.graphics.lineStyle(1,16711680);
         last.graphics.beginFill(16711680,0);
         last.graphics.drawRect(this.drawStartPoint.x,this.drawStartPoint.y,mx - this.drawStartPoint.x,my - this.drawStartPoint.y);
         last.graphics.endFill();
      }
      
      private function onDrawRectUp(e:MouseEvent) : void
      {
         this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDrawRectMove);
         this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDrawRectUp);
      }
      
      private function setPaintPanel() : void
      {
         if(!this.paintPanel)
         {
            this.paintPanel = new Sprite();
            this.paintPanel.graphics.beginFill(16711680,0);
            this.paintPanel.graphics.drawRect(0,0,this.rbPoint.x - this.ltPoint.x,this.rbPoint.y - this.ltPoint.y);
            this.paintPanel.graphics.endFill();
            this.addChild(this.paintPanel);
            this.paintPanel.x = this.ltPoint.x;
            this.paintPanel.y = this.ltPoint.y;
            this.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         }
      }
      
      private function onMouseDownPaint(e:MouseEvent) : void
      {
         e.stopPropagation();
      }
      
      private function onRollOverPoint(evt:MouseEvent) : void
      {
         if(evt.target == this.points[1] || evt.target == this.points[6])
         {
            MouseManager.getInstance().setCursor("cursortd");
         }
         if(evt.target == this.points[3] || evt.target == this.points[4])
         {
            MouseManager.getInstance().setCursor("cursorlr");
         }
         if(evt.target == this.points[0] || evt.target == this.points[7])
         {
            MouseManager.getInstance().setCursor("cursorangle");
         }
         if(evt.target == this.points[2] || evt.target == this.points[5])
         {
            MouseManager.getInstance().setCursor("cursorangle1");
         }
      }
      
      private function onRollOutPoint(evt:MouseEvent) : void
      {
         MouseManager.getInstance().setCursor("");
      }
      
      private function onMouseDownPoint(e:MouseEvent) : void
      {
         if(e.target == this.points[0])
         {
            this.startPoint.x = DisplayObject(this.points[7]).x;
            this.startPoint.y = DisplayObject(this.points[7]).y;
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovePoint);
         }
         else if(e.target == this.points[2])
         {
            this.startPoint.x = DisplayObject(this.points[5]).x;
            this.startPoint.y = DisplayObject(this.points[5]).y;
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovePoint);
         }
         else if(e.target == this.points[5])
         {
            this.startPoint.x = DisplayObject(this.points[2]).x;
            this.startPoint.y = DisplayObject(this.points[2]).y;
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovePoint);
         }
         else if(e.target == this.points[7])
         {
            this.startPoint.x = DisplayObject(this.points[0]).x;
            this.startPoint.y = DisplayObject(this.points[0]).y;
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovePoint);
         }
         else if(e.target == this.points[1])
         {
            this.startPoint.x = DisplayObject(this.points[5]).x;
            this.startPoint.y = DisplayObject(this.points[5]).y;
            this.startX = DisplayObject(this.points[2]).x;
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveYPoint);
         }
         else if(e.target == this.points[6])
         {
            this.startPoint.x = DisplayObject(this.points[0]).x;
            this.startPoint.y = DisplayObject(this.points[0]).y;
            this.startX = DisplayObject(this.points[7]).x;
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveYPoint);
         }
         else if(e.target == this.points[3])
         {
            this.startPoint.x = DisplayObject(this.points[2]).x;
            this.startPoint.y = DisplayObject(this.points[2]).y;
            this.startY = DisplayObject(this.points[5]).y;
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveXPoint);
         }
         else if(e.target == this.points[4])
         {
            this.startPoint.x = DisplayObject(this.points[0]).x;
            this.startPoint.y = DisplayObject(this.points[0]).y;
            this.startY = DisplayObject(this.points[7]).y;
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveXPoint);
         }
         this.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUpPoint);
         e.stopPropagation();
      }
      
      private function onMouseUpPoint(e:MouseEvent) : void
      {
         this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovePoint);
         this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUpPoint);
         this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveYPoint);
         this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveXPoint);
      }
      
      private function onMouseMoveYPoint(e:MouseEvent) : void
      {
         this.p1.x = this.startPoint.x;
         this.p1.y = this.startPoint.y;
         this.p2.x = this.startX;
         this.p2.y = this.mouseY;
         this.draw(this.p1,this.p2);
         this.resetPoint();
         this.resetPointsPos();
         this.resetBar();
      }
      
      private function onMouseMoveXPoint(e:MouseEvent) : void
      {
         this.p1.x = this.startPoint.x;
         this.p1.y = this.startPoint.y;
         this.p2.x = this.mouseX;
         this.p2.y = this.startY;
         this.draw(this.p1,this.p2);
         this.resetPoint();
         this.resetPointsPos();
         this.resetBar();
      }
      
      private function onMouseMovePoint(e:MouseEvent) : void
      {
         this.p1.x = this.startPoint.x;
         this.p1.y = this.startPoint.y;
         this.p2.x = this.mouseX;
         this.p2.y = this.mouseY;
         this.draw(this.p1,this.p2);
         this.resetPoint();
         this.resetPointsPos();
         this.resetBar();
      }
      
      private function initListeners() : void
      {
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      private function resetPointsPos() : void
      {
         var x2:int = (this.ltPoint.x + this.rbPoint.x) / 2;
         var y2:int = (this.ltPoint.y + this.rbPoint.y) / 2;
         DisplayObject(this.points[0]).x = this.ltPoint.x;
         DisplayObject(this.points[0]).y = this.ltPoint.y;
         DisplayObject(this.points[1]).x = x2;
         DisplayObject(this.points[1]).y = this.ltPoint.y;
         DisplayObject(this.points[2]).x = this.rbPoint.x;
         DisplayObject(this.points[2]).y = this.ltPoint.y;
         DisplayObject(this.points[3]).x = this.ltPoint.x;
         DisplayObject(this.points[3]).y = y2;
         DisplayObject(this.points[4]).x = this.rbPoint.x;
         DisplayObject(this.points[4]).y = y2;
         DisplayObject(this.points[5]).x = this.ltPoint.x;
         DisplayObject(this.points[5]).y = this.rbPoint.y;
         DisplayObject(this.points[6]).x = x2;
         DisplayObject(this.points[6]).y = this.rbPoint.y;
         DisplayObject(this.points[7]).x = this.rbPoint.x;
         DisplayObject(this.points[7]).y = this.rbPoint.y;
      }
      
      private function resetPoint() : void
      {
         this.ltPoint.x = this.p1.x < this.p2.x ? this.p1.x : this.p2.x;
         this.ltPoint.y = this.p1.y < this.p2.y ? this.p1.y : this.p2.y;
         this.rbPoint.x = this.p1.x < this.p2.x ? this.p2.x : this.p1.x;
         this.rbPoint.y = this.p1.y < this.p2.y ? this.p2.y : this.p1.y;
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         this.startDrag();
         this.addEventListener(MouseEvent.MOUSE_UP,this.onMove);
      }
      
      private function onMove(e:MouseEvent) : void
      {
         this.stopDrag();
         this.removeEventListener(MouseEvent.MOUSE_UP,this.onMove);
      }
      
      private function draw(p1:Point, p2:Point) : void
      {
         var g:Graphics = this.graphics;
         g.clear();
         g.beginFill(16777215,0.1);
         g.lineStyle(1,style[COLOR]);
         g.moveTo(p1.x,p1.y);
         g.lineTo(p1.x,p2.y);
         g.lineTo(p2.x,p2.y);
         g.lineTo(p2.x,p1.y);
         g.lineTo(p1.x,p1.y);
         g.endFill();
         this.addChild(this.points[0]);
      }
   }
}

