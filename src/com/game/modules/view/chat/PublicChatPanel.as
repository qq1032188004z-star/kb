package com.game.modules.view.chat
{
   import com.game.util.rectUtils.scroll.RectScrollBox;
   import flash.display.Sprite;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol78")]
   public class PublicChatPanel extends Sprite
   {
      
      private var publicCV:PubChatView;
      
      private var _box:RectScrollBox;
      
      public var rightScrollBack:Sprite;
      
      public var rightScrollBtn:Sprite;
      
      public var grayBack:Sprite;
      
      public function PublicChatPanel()
      {
         super();
         this.publicCV = new PubChatView();
         this._box = new RectScrollBox(205,150,1,false,-3);
         this._box.scrollBar.setScrollSkin(new Sprite(),new Sprite(),this.rightScrollBtn,this.rightScrollBack);
         this._box.setGrayBar(this.grayBack);
         addChild(this._box);
         this._box.addDisplayObj(this.publicCV);
         this.sceneChatData({"first":1});
      }
      
      public function sceneChatData(obj:Object) : void
      {
         this.publicCV.addItem(obj);
         this._box.updateView();
         this._box.onUpdateScrollToPos(this.publicCV.height);
      }
   }
}

