package com.game.modules.view.family
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.list.ItemRender;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol698")]
   public class FamilyCheckItem extends ItemRender
   {
      
      public var txt1:TextField;
      
      public var txt2:TextField;
      
      public var txt3:TextField;
      
      public var txt4:TextField;
      
      public var txt5:TextField;
      
      public var txt6:TextField;
      
      public var txt7:TextField;
      
      public var bg:MovieClip;
      
      public var mc:MovieClip;
      
      private var loader:Loader;
      
      private const Level:Array = ["游民","族长","副族长","护法","精英","族员"];
      
      public function FamilyCheckItem()
      {
         super();
         this.mouseEnabled = false;
         this.removeChild(this.txt1);
         this.removeChild(this.txt2);
         this.removeChild(this.txt3);
         this.removeChild(this.txt4);
         this.removeChild(this.txt5);
         this.removeChild(this.txt6);
         this.removeChild(this.txt7);
         this.bg.visible = false;
         this.bg.mouseEnabled = false;
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaded);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this.loader.load(new URLRequest(URLUtil.getSvnVer("assets/family/family_checkin_item.swf")));
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      override public function set data(params:Object) : void
      {
         super.data = params;
      }
      
      private function onLoaded(evt:Event) : void
      {
         this.mc = (this.loader.content as MovieClip).getChildAt(0) as MovieClip;
         this.mc.x = -256;
         this.mc.y = -9;
         this.mc.txt1.text = this.data.uname + "";
         this.mc.txt2.text = this.Level[this.data.level] + "";
         this.mc.txt3.text = this.data.times + "";
         for(var j:int = 1; j < 8; j++)
         {
            this.mc["mc" + j].gotoAndStop((data.record & Math.pow(2,j - 1)) + 1);
         }
         this.mc.upbtn.addEventListener(MouseEvent.CLICK,this.on_upbtn);
         this.mc.downbtn.addEventListener(MouseEvent.CLICK,this.on_downbtn);
         this.addChild(this.mc);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaded);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         var flag:Boolean = Boolean(GameData.instance.playerData.family_level == 1);
         this.mc.upbtn.visible = flag;
         this.mc.upbtn.mouseEnabled = flag;
         this.mc.downbtn.visible = flag;
         this.mc.downbtn.mouseEnabled = flag;
         this.mouseEnabled = flag;
      }
      
      private function onError(evt:IOErrorEvent) : void
      {
         this.loader.unloadAndStop(false);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaded);
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
      }
      
      private function onRemoved(evt:Event) : void
      {
         super.dispos();
         if(this.mc != null)
         {
            this.mc.upbtn.removeEventListener(MouseEvent.CLICK,this.on_upbtn);
            this.mc.upbtn.removeEventListener(MouseEvent.CLICK,this.on_downbtn);
            if(this.contains(this.mc))
            {
               this.removeChild(this.mc);
            }
            this.mc = null;
         }
         if(this.loader != null)
         {
            this.loader.unload();
            this.loader = null;
         }
      }
      
      private function on_upbtn(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.family_level != 1 || GameData.instance.playerData.family_base_id != GameData.instance.playerData.family_id)
         {
            return;
         }
         if(this.data.level <= 2)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1057,
               "flag":8
            });
         }
         else
         {
            --this.data.level;
            this.mc.txt2.text = this.Level[this.data.level];
            ApplicationFacade.getInstance().dispatch(EventConst.RECORD_CHANGE_LEVEL,this.data);
         }
      }
      
      private function on_downbtn(evt:MouseEvent) : void
      {
         if(GameData.instance.playerData.family_level != 1 || GameData.instance.playerData.family_base_id != GameData.instance.playerData.family_id)
         {
            return;
         }
         if(this.data.level >= 5)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1057,
               "flag":9
            });
         }
         else if(this.data.level == 1)
         {
            AlertManager.instance.showTipAlert({
               "systemid":1057,
               "flag":10
            });
         }
         else
         {
            ++this.data.level;
            this.mc.txt2.text = this.Level[this.data.level];
            ApplicationFacade.getInstance().dispatch(EventConst.RECORD_CHANGE_LEVEL,this.data);
         }
      }
   }
}

