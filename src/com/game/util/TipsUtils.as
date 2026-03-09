package com.game.util
{
   import com.game.modules.view.WindowLayer;
   
   public class TipsUtils
   {
      
      private static var _instance:TipsSprite;
      
      public function TipsUtils()
      {
         super();
      }
      
      public static function showTips(msg:String, x:int, y:int) : void
      {
         if(_instance == null)
         {
            _instance = new TipsSprite();
         }
         _instance.setTips(msg);
         _instance.x = x + 20;
         _instance.y = y + 20;
         WindowLayer.instance.stage.addChild(_instance);
      }
      
      public static function setTipsPosition(x:int, y:int) : void
      {
         if(Boolean(_instance))
         {
            _instance.x = x + 20;
            _instance.y = y + 20;
         }
      }
      
      private static function initView() : void
      {
         _instance = new TipsSprite();
      }
      
      public static function hideTips() : void
      {
         if(Boolean(_instance))
         {
            _instance.removedFromParent();
         }
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class TipsSprite extends Sprite
{
   
   private var _msgTxt:TextField;
   
   private var m_nbordercolor:uint = 16777215;
   
   private var m_nbgcolor:uint = 14281964;
   
   public function TipsSprite()
   {
      super();
      this.init();
   }
   
   private function init() : void
   {
      this._msgTxt = new TextField();
      this._msgTxt.autoSize = TextFieldAutoSize.LEFT;
      this._msgTxt.selectable = false;
      this._msgTxt.multiline = true;
      addChild(this._msgTxt);
   }
   
   public function setTips(msg:String) : void
   {
      if(this._msgTxt.htmlText != msg)
      {
         this._msgTxt.htmlText = msg;
         this.redrawBackground();
      }
   }
   
   private function redrawBackground() : void
   {
      graphics.clear();
      graphics.lineStyle(0,this.m_nbordercolor);
      graphics.beginFill(this.m_nbgcolor,0.75);
      graphics.drawRect(0,0,this._msgTxt.width,this._msgTxt.height);
      graphics.endFill();
   }
   
   public function removedFromParent() : void
   {
      if(Boolean(this.parent))
      {
         this.parent.removeChild(this);
      }
   }
}
