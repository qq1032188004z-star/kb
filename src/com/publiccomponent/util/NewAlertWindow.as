package com.publiccomponent.util
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol337")]
   public class NewAlertWindow extends MovieClip
   {
      
      public static var instance:NewAlertWindow = new NewAlertWindow();
      
      public var msgTxt:TextField;
      
      public var sureBtn:SimpleButton;
      
      public var tb:SimpleButton;
      
      public function NewAlertWindow()
      {
         super();
      }
   }
}

