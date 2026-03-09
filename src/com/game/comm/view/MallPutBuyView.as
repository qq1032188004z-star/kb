package com.game.comm.view
{
   import com.game.Tools.ItemIcon;
   import com.game.locators.GameData;
   import com.game.modules.view.WindowLayer;
   import com.game.util.DisplayUtil;
   import com.game.util.FloatAlert;
   import com.game.util.HLoaderSprite;
   import com.game.util.ToolTipStringUtil;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class MallPutBuyView extends HLoaderSprite
   {
      
      private var _leftBtn:SimpleButton;
      
      private var _rightBtn:SimpleButton;
      
      private var _itemBox:Sprite;
      
      private var _itemIcon:ItemIcon;
      
      private var callback:Function;
      
      private var _data:MallPutBuyData;
      
      private var _max:int;
      
      private var _price:int;
      
      private var _needPay:int;
      
      public var closeBack:Function;
      
      public function MallPutBuyView($callBack:Function = null)
      {
         super();
         this.callback = $callBack;
         this.url = "assets/common/mall_put_buy_comm.swf";
      }
      
      override public function setShow() : void
      {
         bg.cacheAsBitmap = true;
         this.initParams(this._data);
      }
      
      override public function initParams(params:Object = null) : void
      {
         var mpbd:MallPutBuyData = null;
         if(params != null)
         {
            if(params is MallPutBuyData)
            {
               this._data = params as MallPutBuyData;
            }
            else
            {
               mpbd = new MallPutBuyData();
               mpbd.parse(params);
               this._data = mpbd;
            }
         }
         if(!bg)
         {
            return;
         }
         this._itemBox = bg.itemBox;
         this._itemBox.removeChildren();
         this._itemIcon = new ItemIcon();
         this._itemBox.addChild(this._itemIcon);
         (bg.descTxt as TextField).mouseWheelEnabled = true;
         bg.countTxt.maxChars = 4;
         bg.countTxt.restrict = "0-9";
         this._leftBtn = bg.leftBtn;
         this._rightBtn = bg.rightBtn;
         bg.buyBtn.addEventListener(MouseEvent.CLICK,this.onBuy);
         bg.closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         bg.countTxt.addEventListener(Event.CHANGE,this.onCountTxt);
         this._leftBtn.addEventListener(MouseEvent.CLICK,this.onLeftBtn);
         this._rightBtn.addEventListener(MouseEvent.CLICK,this.onRightBtn);
         bg.vipd.visible = false;
         bg.vip8.visible = false;
         this._itemIcon.setData(this._data.goodId,this._data.amount,this._data.isTool,Boolean(this._data.amount > 1));
         this.showBuyInfo();
         this.showPriceByCount(1);
      }
      
      private function showBuyInfo() : void
      {
         var ldesc:String = null;
         bg.newMc.visible = Boolean(this._data.mark == 1);
         bg.HotMc.visible = Boolean(this._data.mark == 2);
         if(this._data.isTool)
         {
            bg.nameTxt.text = ToolTipStringUtil.getToolName(this._data.goodId);
            bg.descTxt.text = ToolTipStringUtil.getToolDesc(this._data.goodId);
         }
         else
         {
            bg.nameTxt.text = ToolTipStringUtil.getSpriteName(this._data.goodId);
            bg.descTxt.text = ToolTipStringUtil.getSpriteDesc(this._data.goodId);
         }
         bg.coinMc1.gotoAndStop(this._data.payType + 1);
         bg.coinMc2.gotoAndStop(this._data.payType + 1);
         this._price = this._data.price;
         if(GameData.instance.playerData.isVip && this._data.vipPrice > 0)
         {
            bg.vipd.visible = true;
            this._needPay = this._data.vipPrice;
         }
         else if(this._data.commonPrice > 0)
         {
            this._needPay = this._data.commonPrice;
         }
         else if(this._data.payType != 0 && GameData.instance.playerData.isVip)
         {
            bg.vip8.visible = true;
            this._needPay = Math.ceil(this._price * 0.8);
         }
         else
         {
            this._needPay = this._price;
         }
         if(this._data.limitNum > 0 && this._data.showLimit)
         {
            if(this._data.limitType == 1)
            {
               ldesc = "(每天可以购买" + this._data.limitNum + "个)";
            }
            else if(this._data.limitType == 2)
            {
               ldesc = "(每周可以购买" + this._data.limitNum + "个)";
            }
            else if(this._data.limitType == 3)
            {
               ldesc = "(每月可以购买" + this._data.limitNum + "个)";
            }
            else if(this._data.limitType == 4)
            {
               ldesc = "(限购商品，还能购买：" + this._data.limitNum + "个)";
            }
            bg.limitTxt.text = ldesc;
         }
         else
         {
            bg.limitTxt.text = "";
         }
      }
      
      private function onBuy(evt:MouseEvent) : void
      {
         var count:int = int(bg.countTxt.text);
         if(count < 1)
         {
            new FloatAlert().show(WindowLayer.instance,300,400,"购买数量至少是1哦！",5,200);
            return;
         }
         if(count > 1)
         {
            if(this._data.type == 2)
            {
               if(this._data.subType == 1)
               {
                  new FloatAlert().show(WindowLayer.instance,300,400,"坐骑一次只能购买一件哦！",5,200);
               }
               else if(this._data.subType == 2)
               {
                  new FloatAlert().show(WindowLayer.instance,300,400,"贝贝只能购买一件哦！",5,200);
               }
               else
               {
                  new FloatAlert().show(WindowLayer.instance,300,400,"装扮只能购买一件哦！",5,200);
               }
               return;
            }
         }
         this._data.mallCount = count;
         this.apply(this._data);
         this.disport();
      }
      
      private function gotoBuy(data:Object) : void
      {
         if(this.closeBack != null)
         {
            this.closeBack(1);
            this.closeBack = null;
         }
         var bodyList:Array = [];
         bodyList.push(String(data.md5));
         bodyList.push(int(data.time));
         bodyList.push(1);
         bodyList.push(this._data.payId);
         bodyList.push(int(data.goods.mallCount));
         this.apply(bodyList);
         this.disport();
      }
      
      private function onClose(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function onCountTxt(evt:Event) : void
      {
         var count:int = int(bg.countTxt.text);
         if(count <= 0)
         {
            this.showPriceByCount(1);
            return;
         }
         var max:int = this._data.getMaxCount();
         if(count > max)
         {
            count = max;
         }
         this.showPriceByCount(count);
      }
      
      private function onLeftBtn(evt:MouseEvent) : void
      {
         var count:int = int(bg.countTxt.text);
         if(count > 1)
         {
            count--;
            this.showPriceByCount(count);
         }
         trace("===========onLeftBtn=========",count);
      }
      
      private function onRightBtn(evt:MouseEvent) : void
      {
         var count:int = int(bg.countTxt.text);
         if(count < this._data.getMaxCount())
         {
            count++;
            this.showPriceByCount(count);
         }
         trace("===========onRightBtn=========",count);
      }
      
      private function showPriceByCount(count:int = 1) : void
      {
         bg.countTxt.text = count + "";
         bg.numTxt.text = count * this._price + "";
         bg.needTxt.text = count * this._needPay + "";
         if(count <= 1)
         {
            this._leftBtn.enabled = this._leftBtn.mouseEnabled = false;
            DisplayUtil.grayDisplayObject(this._leftBtn);
         }
         else
         {
            this._leftBtn.enabled = this._leftBtn.mouseEnabled = true;
            DisplayUtil.ungrayDisplayObject(this._leftBtn);
         }
         if(count >= this._data.getMaxCount())
         {
            this._rightBtn.enabled = this._rightBtn.mouseEnabled = false;
            DisplayUtil.grayDisplayObject(this._rightBtn);
         }
         else
         {
            this._rightBtn.enabled = this._rightBtn.mouseEnabled = true;
            DisplayUtil.ungrayDisplayObject(this._rightBtn);
         }
      }
      
      public function apply(data:Object) : void
      {
         if(this.callback != null)
         {
            this.callback(data);
         }
      }
      
      override public function disport() : void
      {
         if(bg != null)
         {
            if(Boolean(this._itemIcon))
            {
               this._itemIcon.dispose();
               this._itemIcon = null;
            }
            bg.buyBtn.removeEventListener(MouseEvent.CLICK,this.onBuy);
            bg.closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
            bg.countTxt.removeEventListener(Event.CHANGE,this.onCountTxt);
            this._leftBtn.removeEventListener(MouseEvent.CLICK,this.onLeftBtn);
            this._rightBtn.removeEventListener(MouseEvent.CLICK,this.onRightBtn);
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.disport();
         this.callback = null;
      }
   }
}

