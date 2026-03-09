package com.publiccomponent.ui
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import mx.utils.StringUtil;
   
   public class ToolTip extends Sprite
   {
      
      private static var m_stage:Stage;
      
      private static var m_uniqueInstance:ToolTip;
      
      private static var m_ntxtcolor:uint = 16750950;
      
      private static var m_ntxtsize:int = 12;
      
      private static var m_nbordercolor:uint = 16777215;
      
      private static var m_nbgcolor:uint = 14281964;
      
      private static var m_nmaxtxtwidth:Number = 500;
      
      private var m_arrDOTips:Array;
      
      private var m_tipTxt:TextField;
      
      private var p:Point = new Point();
      
      public function ToolTip()
      {
         super();
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.m_arrDOTips = new Array();
      }
      
      private static function getInstance() : ToolTip
      {
         if(m_uniqueInstance == null)
         {
            m_uniqueInstance = new ToolTip();
            m_uniqueInstance.visible = false;
            m_uniqueInstance.m_tipTxt = new TextField();
            m_uniqueInstance.m_tipTxt.autoSize = TextFieldAutoSize.LEFT;
            m_uniqueInstance.m_tipTxt.selectable = false;
            m_uniqueInstance.m_tipTxt.multiline = true;
            m_uniqueInstance.addChild(m_uniqueInstance.m_tipTxt);
         }
         m_stage.addChild(m_uniqueInstance);
         return m_uniqueInstance;
      }
      
      public static function removeToolTip() : void
      {
         for(var i:int = 0; i < getInstance().DOTips.length; i++)
         {
            getInstance().DOTips[i].DO.removeEventListener(MouseEvent.ROLL_OVER,showtip);
            getInstance().DOTips[i].DO.removeEventListener(MouseEvent.ROLL_OUT,hidetip);
            getInstance().DOTips[i] = null;
            m_stage.removeChild(getInstance());
            m_uniqueInstance = null;
         }
      }
      
      public static function hideToolTip() : void
      {
         if(m_stage.contains(getInstance()))
         {
            m_stage.removeChild(getInstance());
         }
      }
      
      public static function showToolTip() : void
      {
         m_stage.addChild(getInstance());
      }
      
      public static function BindDO(DO:DisplayObject, info:String) : void
      {
         var dotip:Object = null;
         info = StringUtil.trim(info);
         if(TestDOBinding(DO) == -1)
         {
            dotip = {
               "DO":DO,
               "info":info
            };
            getInstance().DOTips.push(dotip);
            DO.addEventListener(MouseEvent.ROLL_OVER,showtip);
            DO.addEventListener(MouseEvent.ROLL_OUT,hidetip);
         }
      }
      
      public static function LooseDO(DO:DisplayObject) : void
      {
         var index:int = TestDOBinding(DO);
         if(index != -1)
         {
            getInstance().visible = false;
            getInstance().DOTips.splice(index,1);
            DO.removeEventListener(MouseEvent.ROLL_OVER,showtip);
            DO.removeEventListener(MouseEvent.ROLL_OUT,hidetip);
         }
      }
      
      public static function setDOInfo(DO:DisplayObject, info:String) : void
      {
         info = StringUtil.trim(info);
         if(TestDOBinding(DO) == -1)
         {
            BindDO(DO,info);
         }
         else
         {
            getInstance().DOTips[TestDOBinding(DO)].info = info;
         }
      }
      
      public static function TestDOBinding(DO:DisplayObject) : int
      {
         var flag:Boolean = false;
         for(var i:int = 0; i < getInstance().DOTips.length; i++)
         {
            if(getInstance().DOTips[i].DO == DO)
            {
               flag = true;
               break;
            }
         }
         return flag ? i : -1;
      }
      
      private static function showtip(evt:MouseEvent) : void
      {
         if(evt.target == null)
         {
            return;
         }
         if(!m_stage.contains(getInstance()))
         {
            m_stage.addChild(m_uniqueInstance);
         }
         try
         {
            getInstance().m_tipTxt.htmlText = getInstance().DOTips[TestDOBinding(evt.target as DisplayObject)].info;
            getInstance().m_tipTxt.wordWrap = false;
            updatetip();
            getInstance().visible = true;
            getInstance().m_tipTxt.visible = true;
         }
         catch(e:*)
         {
         }
         var p:Point = getInstance().p;
         p = DisplayObject(evt.currentTarget.parent).localToGlobal(p);
         if(evt.currentTarget.hasOwnProperty("tipHeight"))
         {
            p.x = evt.currentTarget.x;
            p.y = evt.currentTarget.y + evt.currentTarget.tipHeight;
            p = DisplayObject(evt.currentTarget.parent).localToGlobal(p);
         }
         else if(Boolean(evt.currentTarget.hasOwnProperty("height")) && evt.currentTarget.height < 90 && evt.currentTarget.height > 50)
         {
            p.x = evt.currentTarget.x;
            p.y = evt.currentTarget.y + evt.currentTarget.height;
            p = DisplayObject(evt.currentTarget.parent).localToGlobal(p);
         }
         else
         {
            p.x = evt.stageX;
            p.y = evt.stageY;
         }
         var num:Number = getInstance().width;
         if(p.x + num > m_stage.stageWidth - 80)
         {
            p.x -= num - 80;
         }
         if(p.x < 0)
         {
            p.x = 10;
         }
         num = getInstance().height;
         if(p.y < num)
         {
            p.y = 10;
         }
         else if(p.y + num > m_stage.stageHeight)
         {
            p.y -= num;
         }
         getInstance().x = p.x;
         getInstance().y = p.y;
      }
      
      private static function hidetip(evt:MouseEvent) : void
      {
         if(evt.target == null)
         {
            return;
         }
         getInstance().visible = false;
      }
      
      private static function updatetip() : void
      {
         if(getInstance().m_tipTxt.width > m_nmaxtxtwidth)
         {
            getInstance().m_tipTxt.width = m_nmaxtxtwidth;
            m_uniqueInstance.m_tipTxt.wordWrap = true;
         }
         var gp:Graphics = getInstance().graphics;
         gp.clear();
         gp.lineStyle(0,m_nbordercolor);
         gp.beginFill(m_nbgcolor,0.75);
         gp.drawRect(0,0,getInstance().m_tipTxt.width,getInstance().m_tipTxt.height);
         gp.endFill();
         getInstance().filters = [new DropShadowFilter(2)];
      }
      
      public static function set stage(stage:Stage) : void
      {
         m_stage = stage;
      }
      
      public static function setTipProperty(txtcolor:uint = 0, txtsize:int = 12, maxtxtwidth:int = 500, bordercolor:uint = 0, bgcolor:uint = 16777164) : void
      {
         m_ntxtcolor = txtcolor;
         m_ntxtsize = txtsize;
         m_nmaxtxtwidth = maxtxtwidth;
         m_nbordercolor = bordercolor;
         m_nbgcolor = bgcolor;
      }
      
      private function get DOTips() : Array
      {
         return this.m_arrDOTips;
      }
   }
}

