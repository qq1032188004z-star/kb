package com.game.modules.view
{
   import com.game.modules.control.task.TaskList;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.loading.GreenLoading;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class DomainView extends HLoaderSprite
   {
      
      private var _callback:Function;
      
      public var moduleParams:Object = null;
      
      private var d:Boolean = false;
      
      public function DomainView()
      {
         super();
      }
      
      public function domainurl(value:String, domain:Boolean = true, showloading:Boolean = true, isEncryption:Boolean = false) : void
      {
         GreenLoading.loading.visible = showloading;
         _isEncryption = isEncryption;
         if(domain)
         {
            this.context = new LoaderContext(false,ApplicationDomain.currentDomain);
         }
         this.url = value;
      }
      
      override public function setShow() : void
      {
         GreenLoading.loading.visible = false;
         if(loader.content && loader.content.hasOwnProperty("moduleParams") && this.moduleParams != null)
         {
            loader.content["moduleParams"] = this.moduleParams;
         }
         TaskList.getInstance().checkUrlAndFreshManTask(url);
      }
      
      public function set callback(back:Function) : void
      {
         this._callback = back;
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStageHandler);
      }
      
      override public function disport() : void
      {
         WindowLayer.instance.mouseEnabled = false;
         if(!this.d)
         {
            this.d = true;
            this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStageHandler);
            GreenLoading.loading.visible = false;
            try
            {
               loader.loader.content["disport"]();
            }
            catch(e:*)
            {
            }
            if(this._callback != null)
            {
               this._callback.apply(null,[null]);
            }
            this._callback = null;
            this.moduleParams = null;
            super.disport();
         }
      }
      
      private function onRemoveFromStageHandler(evt:Event) : void
      {
         this.disport();
      }
   }
}

