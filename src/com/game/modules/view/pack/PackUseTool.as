package com.game.modules.view.pack
{
   import com.game.event.EventConst;
   import com.game.facade.ApplicationFacade;
   import com.game.modules.view.MapView;
   import com.game.util.FloatAlert;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.alert.Alert;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class PackUseTool
   {
      
      public static var Instance:PackUseTool = new PackUseTool();
      
      private var myBody:Object;
      
      private var myXmlList:XML;
      
      private var loader:URLLoader;
      
      public function PackUseTool()
      {
         super();
      }
      
      private function onLoaded(evt:Event) : void
      {
         var bytes:ByteArray = this.loader.data as ByteArray;
         bytes.uncompress();
         bytes.position = 0;
         var str:String = bytes.readUTFBytes(bytes.bytesAvailable);
         var xmllist:XMLList = new XMLList(str);
         this.myXmlList = xmllist[0] as XML;
         this.showAlert();
      }
      
      public function useTool(body:Object) : void
      {
         this.myBody = body;
         if(!this.myXmlList)
         {
            this.loader = new URLLoader();
            this.loader.dataFormat = URLLoaderDataFormat.BINARY;
            this.loader.addEventListener(Event.COMPLETE,this.onLoaded);
            this.loader.load(new URLRequest(URLUtil.getSvnVer("config/tooltips")));
         }
         else
         {
            this.showAlert();
         }
      }
      
      private function showAlert() : void
      {
         var xml:XML = null;
         var str:String = "";
         var type:int = 0;
         for each(xml in this.myXmlList.children())
         {
            if(xml.@id == this.myBody.prosid)
            {
               str = String(xml.tips);
               type = int(xml.type);
               break;
            }
         }
         if(str == "")
         {
            ApplicationFacade.getInstance().dispatch(EventConst.USEPROPS,this.myBody);
         }
         else if(type == 0)
         {
            new Alert().showSureOrCancel(str,this.useToolHandler);
         }
         else
         {
            new FloatAlert().show(MapView.instance.stage,320,300,str);
            this.useToolHandler("确定");
         }
      }
      
      private function useToolHandler(... rest) : void
      {
         if(rest[0] == "确定")
         {
            ApplicationFacade.getInstance().dispatch(EventConst.USEPROPS,this.myBody);
         }
      }
   }
}

