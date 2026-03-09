package org.dress.util
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import org.dress.ui.BaseDecoration;
   import org.dress.ui.DecorationDataVO;
   
   public class MaterialLimiteLoader
   {
      
      private static var _instance:MaterialLimiteLoader;
      
      private var descorList:Array = [];
      
      private var urlLoader:URLLoader;
      
      private var currentBase:BaseDecoration;
      
      private var isLoading:Boolean;
      
      private var mcSprite:Sprite;
      
      private var loadingUrl:String;
      
      private var count:int;
      
      public function MaterialLimiteLoader()
      {
         super();
         this.urlLoader = new URLLoader();
         this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.urlLoader.addEventListener(Event.COMPLETE,this.onLoaded);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         this.urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         this.mcSprite = new Sprite();
      }
      
      public static function getInstance() : MaterialLimiteLoader
      {
         if(_instance == null)
         {
            _instance = new MaterialLimiteLoader();
         }
         return _instance;
      }
      
      private function onLoaded(evt:Event) : void
      {
         var tempByte:ByteArray = ByteArray(this.urlLoader.data);
         var decorationVo:DecorationDataVO = new DecorationDataVO();
         decorationVo.build(tempByte);
         MaterialCache.instance.pushDecorationData(this.loadingUrl,decorationVo);
         if(this.currentBase != null && this.loadingUrl == this.currentBase.url)
         {
            this.currentBase.onLoadComplement(decorationVo);
         }
         this.delayLoad(null);
      }
      
      private function ioError(evt:Event) : void
      {
         this.delayLoad(null);
      }
      
      private function onSecurityError(evt:Event) : void
      {
         this.delayLoad(null);
      }
      
      private function trigeerNewLoad() : void
      {
         this.mcSprite.removeEventListener(Event.ENTER_FRAME,this.delayLoad);
         this.mcSprite.addEventListener(Event.ENTER_FRAME,this.delayLoad);
      }
      
      private function delayLoad(evt:Event) : void
      {
         var returnData:DecorationDataVO = null;
         this.currentBase = this.getNextLoadDescor();
         if(Boolean(this.currentBase))
         {
            returnData = MaterialCache.instance.getDecorationData(this.currentBase.url);
            if(returnData == null)
            {
               this.loadingUrl = this.currentBase.url;
               this.urlLoader.load(new URLRequest(this.currentBase.url));
            }
            else
            {
               this.currentBase.onLoadComplement(returnData);
               this.delayLoad(null);
            }
         }
         else
         {
            this.isLoading = false;
         }
      }
      
      private function getNextLoadDescor() : BaseDecoration
      {
         var decor:BaseDecoration = null;
         while(this.descorList.length > 0)
         {
            decor = this.descorList.shift() as BaseDecoration;
            if(decor != null && decor.url != "")
            {
               return decor;
            }
         }
         return null;
      }
      
      public function excuteLoad(currentBase:BaseDecoration) : void
      {
         var returnData:DecorationDataVO = MaterialCache.instance.getDecorationData(currentBase.url);
         if(returnData == null)
         {
            if(this.isLoading)
            {
               this.descorList.push(currentBase);
            }
            else
            {
               this.isLoading = true;
               this.currentBase = currentBase;
               this.loadingUrl = currentBase.url;
               this.urlLoader.load(new URLRequest(currentBase.url));
            }
         }
         else
         {
            currentBase.onLoadComplement(returnData);
         }
      }
      
      public function deleteDecor(decor:BaseDecoration) : void
      {
         var index:int = int(this.descorList.indexOf(decor));
         if(index != -1)
         {
            this.descorList.splice(index,1);
            if(this.currentBase == decor)
            {
               this.delayLoad(null);
            }
         }
      }
   }
}

