package com.game.modules.view.task
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   
   public class SingleChoice extends Sprite
   {
      
      private var _loader:Loader;
      
      private var bg:MovieClip;
      
      private var clsItem:Class;
      
      private var titleName:String = "";
      
      private var descList:Array;
      
      private var ans:int;
      
      private var npcid:int;
      
      private var itemList:Array;
      
      private var wholeList:Array;
      
      private var currentIndex:int;
      
      public function SingleChoice()
      {
         super();
         this.descList = [];
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         this._loader.load(new URLRequest(URLUtil.getSvnVer("assets/material/singleChoice.swf")));
      }
      
      private function onLoadComplete(evt:Event) : void
      {
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         var clsClip:Class = domain.getDefinition("choiceClip") as Class;
         this.bg = new clsClip();
         this.clsItem = domain.getDefinition("choiceItem") as Class;
         this.addChild(this.bg);
         this.bg.cacheAsBitmap = true;
         if(this.wholeList != null)
         {
            this.init();
         }
      }
      
      public function setData(param:Object) : void
      {
         this.npcid = param.npcid;
         this.wholeList = param.desc;
         this.initQuestion();
      }
      
      private function initQuestion() : void
      {
         this.currentIndex = this.orderedByMyRule();
         if(this.currentIndex == -1)
         {
            this.disport();
            return;
         }
         var tempArr:Array = this.wholeList[this.currentIndex].desc as Array;
         this.titleName = tempArr[0];
         this.descList = tempArr.slice(1,tempArr.length);
         if(Boolean(this.bg))
         {
            this.init();
         }
      }
      
      private function init() : void
      {
         var item:SingleChoiceItem = null;
         if(this.descList == null)
         {
            this.disport();
            return;
         }
         var i:int = 0;
         var len:int = int(this.descList.length);
         this.itemList = [];
         this.bg.titletf.text = this.titleName;
         for(i = 0; i < len; i++)
         {
            item = new SingleChoiceItem(new this.clsItem() as MovieClip,this.descList[i],i,this.onMouseClickChild);
            this.bg.addChild(item);
            item.x = 300;
            item.y = 225 + i * item.height + 10;
            this.itemList.push(item);
         }
         this.bg.close.addEventListener(MouseEvent.CLICK,this.onMouseClickClose);
      }
      
      private function onMouseClickBtn(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         if(this.ans == 0)
         {
            new Alert().show("请选择一个选项");
            return;
         }
         if(this.wholeList.length > 1)
         {
            if(this.wholeList[this.currentIndex].ans != this.ans)
            {
               new Alert().show("不对呢，再给你一次机会吧。",this.onClickAlert);
               return;
            }
         }
         this.bg.surebtn.removeEventListener(MouseEvent.CLICK,this.onMouseClickBtn);
         if(this.npcid != 0)
         {
            ApplicationFacade.getInstance().dispatch(EventConst.MASTERISOUTSPECIALAREA,{
               "npcid":this.npcid,
               "dialogID":this.ans
            });
         }
         else
         {
            ApplicationFacade.getInstance().dispatch(EventConst.ONANSWERRIGHT);
         }
         this.disport();
      }
      
      private function onClickAlert(txt:String, ... rest) : void
      {
         if(txt == "确定")
         {
            this.releaseChildren();
            this.initQuestion();
         }
      }
      
      private function onMouseClickClose(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.bg.surebtn.removeEventListener(MouseEvent.CLICK,this.onMouseClickBtn);
         this.bg.close.removeEventListener(MouseEvent.CLICK,this.onMouseClickClose);
         ApplicationFacade.getInstance().dispatch(EventConst.MASTERISINSPECIALAREA,{
            "npcid":this.npcid,
            "dialogID":-1
         });
         this.disport();
      }
      
      private function onMouseClickChild(uid:int, beChoose:Boolean) : void
      {
         if(beChoose)
         {
            this.ans = uid;
            this.bg.surebtn.addEventListener(MouseEvent.CLICK,this.onMouseClickBtn);
         }
         else
         {
            this.ans = 0;
            this.bg.surebtn.removeEventListener(MouseEvent.CLICK,this.onMouseClickBtn);
         }
         var i:int = 0;
         var len:int = int(this.itemList.length);
         for(i = 0; i < len; i++)
         {
            if(i != uid - 1)
            {
               if(Boolean(this.itemList[i].beChoocen))
               {
                  (this.itemList[i] as SingleChoiceItem).changeState();
               }
            }
         }
      }
      
      private function onLoadError(evt:IOErrorEvent) : void
      {
         this._loader.unloadAndStop();
         this._loader = null;
         this.disport();
      }
      
      public function disport() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         if(Boolean(this._loader))
         {
            this._loader.unloadAndStop();
            this._loader = null;
         }
         this.releaseChildren();
         if(this.wholeList != null)
         {
            this.wholeList.length = 0;
            this.wholeList = null;
         }
      }
      
      private function releaseChildren() : void
      {
         if(this.itemList == null)
         {
            return;
         }
         var i:int = 0;
         var len:int = int(this.itemList.length);
         for(i = 0; i < len; i++)
         {
            this.bg.removeChild(this.itemList[i]);
         }
         this.itemList = null;
      }
      
      private function orderedByMyRule() : int
      {
         if(this.wholeList == null)
         {
            return -1;
         }
         if(this.wholeList.length == 1)
         {
            return 0;
         }
         return Math.random() * this.wholeList.length >> 0;
      }
   }
}

