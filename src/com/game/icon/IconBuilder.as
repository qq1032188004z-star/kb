package com.game.icon
{
   import com.publiccomponent.URLUtil;
   
   public class IconBuilder
   {
      
      private static var _iconLoaderProxy:IconLoaderProxy;
      
      public function IconBuilder()
      {
         super();
      }
      
      public static function buildIconById(iconId:int, sourceIcon:IconBitMap = null) : IconBitMap
      {
         if(sourceIcon == null)
         {
            sourceIcon = new IconBitMap();
         }
         if(_iconLoaderProxy == null)
         {
            initIconLoader();
         }
         sourceIcon.clear();
         sourceIcon.iconPath = URLUtil.getSvnVer("assets/tool/" + iconId + ".swf");
         _iconLoaderProxy.loadBitmap(sourceIcon);
         return sourceIcon;
      }
      
      private static function initIconLoader() : void
      {
         _iconLoaderProxy = new IconLoaderProxy();
         _iconLoaderProxy.loaderMaxCount = 3;
      }
      
      public static function buildIconByPath(iconPath:String, sourceIcon:IconBitMap = null) : IconBitMap
      {
         if(sourceIcon == null)
         {
            sourceIcon = new IconBitMap();
         }
         if(_iconLoaderProxy == null)
         {
            initIconLoader();
         }
         sourceIcon.clear();
         sourceIcon.iconPath = URLUtil.getSvnVer(iconPath);
         _iconLoaderProxy.loadBitmap(sourceIcon);
         return sourceIcon;
      }
      
      public static function builEmptyIcon() : IconBitMap
      {
         return new IconBitMap();
      }
      
      public static function stopLoadingIcon(icon:IconBitMap) : void
      {
         if(Boolean(_iconLoaderProxy))
         {
            _iconLoaderProxy.cancelTask(icon);
         }
      }
      
      public static function realseIconCache() : void
      {
         if(Boolean(_iconLoaderProxy))
         {
            _iconLoaderProxy.realseCache();
         }
      }
   }
}

