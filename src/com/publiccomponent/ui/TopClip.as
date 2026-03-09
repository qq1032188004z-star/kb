package com.publiccomponent.ui
{
   import com.game.locators.GameData;
   import com.game.util.ColorUtil;
   import com.greensock.TweenMax;
   import com.publiccomponent.tips.MainUIToolTip;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   
   public class TopClip extends Sprite
   {
      
      private static var btnGap:Number = 60.5;
      
      private static var maxNum:int = 6;
      
      private static var posGap:Number = 7;
      
      private var _viewc1:MovieClip;
      
      private var _viewc2:MovieClip;
      
      private var _leftIconBox:Sprite;
      
      private var _rightIconBox:Sprite;
      
      public var topLen:int;
      
      public var topList:Dictionary;
      
      private var _domain:ApplicationDomain;
      
      private var dataList:Array = [];
      
      private var paperhorseXml:XML;
      
      private var paperHorseSid:uint;
      
      private var _iconDic:Object;
      
      public function TopClip($damin:ApplicationDomain, $dataList:Array)
      {
         super();
         this.topList = new Dictionary();
         this._domain = $damin;
         this.dataList = $dataList;
         this.loadViewIcon();
         this.onCongigComplete($dataList);
      }
      
      private function onCongigComplete(dataList:Array) : void
      {
         var row:int = 0;
         var col:int = 0;
         var showPos:int = 0;
         var hide:int = 0;
         var type:int = 0;
         var list:Array = null;
         var leftButton:TopButton = null;
         this._iconDic = {};
         this.topLen = dataList.length;
         for(var i:int = 0; i < this.topLen; i++)
         {
            row = int(dataList[i].row);
            col = int(dataList[i].col);
            type = int(dataList[i].type);
            showPos = int(dataList[i].showPos);
            switch(type)
            {
               case 1:
                  leftButton = new TopButton(this.getBitmapDataByName(dataList[i].name),type);
                  break;
               case 2:
                  leftButton = new TopButton(this.getMovieClipByName(dataList[i].name),type);
                  break;
               case 3:
                  leftButton = new TopButton(dataList[i].url,type);
            }
            leftButton.jump = dataList[i].jump;
            leftButton.targetScene = dataList[i].targetScene;
            leftButton.name = dataList[i].name;
            leftButton.tips = dataList[i].desc;
            leftButton.index = (row - 1) * 16 + col;
            leftButton.row = row;
            leftButton.col = col;
            leftButton.showPos = showPos;
            leftButton.hide = hide;
            leftButton.c = dataList[i].c;
            leftButton.place = 0;
            leftButton.showTime = dataList[i].showTime;
            leftButton.showPhares = dataList[i].showPhares;
            if(leftButton.showPos == 1)
            {
               this._leftIconBox.addChild(leftButton);
            }
            else
            {
               this._rightIconBox.addChild(leftButton);
            }
            this.topList[leftButton.name] = {
               "item":leftButton,
               "showPhares":leftButton.showPhares,
               "place":leftButton.place,
               "tips":leftButton.tips,
               "c":leftButton.c,
               "row":leftButton.row,
               "col":leftButton.col,
               "name":leftButton.name,
               "showPos":leftButton.showPos,
               "jump":leftButton.jump,
               "targetScene":leftButton.targetScene
            };
            if(leftButton.tips != "" && leftButton.tips != "0")
            {
               MainUIToolTip.showTips(leftButton,leftButton.tips,4,1);
            }
            list = this._iconDic[row + "_" + showPos] || [];
            if(!this._iconDic[row + "_" + showPos])
            {
               this._iconDic[row + "_" + showPos] = list;
            }
            if(list.indexOf(this.topList[leftButton.name]) <= -1)
            {
               list.push(this.topList[leftButton.name]);
            }
         }
         (this.topList["familyBattleBtn"].item as TopButton).hide = 1;
         (this.topList["vsBtn"].item as TopButton).hide = 1;
         this.resetIconSort();
      }
      
      private function resetIconSort() : void
      {
         var list:Array = null;
         var topBtn:TopButton = null;
         var btnData:Object = null;
         var key:String = null;
         var isNewHand:int = 0;
         var showNum:int = 0;
         var i:int = 0;
         for(key in this._iconDic)
         {
            list = this._iconDic[key];
            list.sortOn("col",Array.NUMERIC);
            showNum = 0;
            for(i = 0; i < list.length; i++)
            {
               btnData = list[i];
               topBtn = btnData.item;
               if(topBtn.hide == 1)
               {
                  topBtn.visible = false;
               }
               else if(!topBtn.checkShowIcon())
               {
                  topBtn.visible = false;
               }
               else
               {
                  showNum++;
                  if(showNum <= maxNum)
                  {
                     if(topBtn.showPos == 1)
                     {
                        topBtn.x = -this._leftIconBox.x + (showNum - 1) * btnGap + posGap;
                     }
                     else
                     {
                        topBtn.x = 970 - this._rightIconBox.x - showNum * btnGap + 5;
                     }
                     topBtn.y = (topBtn.row - 1) * btnGap + posGap - Math.floor(this._viewc1.height / 2);
                     topBtn.visible = true;
                  }
                  else
                  {
                     topBtn.visible = false;
                  }
               }
            }
         }
         isNewHand = GameData.instance.playerData.isNewHand;
         if(isNewHand < 6)
         {
            this._viewc1.visible = this._viewc2.visible = false;
         }
         else
         {
            this._viewc1.visible = this._viewc2.visible = true;
         }
      }
      
      public function showFamilyBattleBtn() : void
      {
         var topBtn:TopButton = this.topList["familyBattleBtn"].item;
         topBtn.hide = 0;
         this.resetIconSort();
      }
      
      public function hideFamilyBattleBtn() : void
      {
         var topBtn:TopButton = this.topList["familyBattleBtn"].item;
         topBtn.hide = 1;
         this.resetIconSort();
      }
      
      public function disableUIByName(uiName:String) : void
      {
         if(Boolean(this.topList.hasOwnProperty(uiName)) && this.topList[uiName] != null)
         {
            if(Boolean(this.topList[uiName].hasOwnProperty("currentFrame")))
            {
               this.topList[uiName]["mouseEnabled"] = false;
               this.topList[uiName]["filters"] = ColorUtil.getColorMatrixFilterGray();
               this.topList[uiName]["gotoAndStop"](2);
            }
            else
            {
               this.topList[uiName]["filters"] = ColorUtil.getColorMatrixFilterGray();
               this.topList[uiName]["mouseEnabled"] = false;
            }
         }
      }
      
      public function enableUIByName(uiName:String) : void
      {
         if(Boolean(this.topList.hasOwnProperty(uiName)) && this.topList[uiName] != null)
         {
            if(Boolean(this.topList[uiName].hasOwnProperty("currentFrame")))
            {
               this.topList[uiName]["mouseEnabled"] = true;
               this.topList[uiName]["gotoAndStop"](1);
               this.topList[uiName]["filters"] = null;
            }
            else
            {
               this.topList[uiName]["filters"] = null;
               this.topList[uiName]["mouseEnabled"] = true;
            }
         }
      }
      
      public function showNewShiBao() : void
      {
      }
      
      public function hideNewShiBao() : void
      {
      }
      
      public function showVSClip() : void
      {
         var topBtn:TopButton = this.topList["vsBtn"].item;
         topBtn.hide = 0;
         this.resetIconSort();
      }
      
      public function hideVSClip() : void
      {
         var topBtn:TopButton = this.topList["vsBtn"].item;
         topBtn.hide = 1;
         this.resetIconSort();
      }
      
      public function getButtonByName(name:String) : TopButton
      {
         var btn:TopButton = null;
         if(this.topList[name] != null && Boolean(this.topList[name].hasOwnProperty("item")))
         {
            btn = this.topList[name].item;
         }
         return btn;
      }
      
      public function getTipByName(name:String) : Object
      {
         var btn:Object = null;
         if(this.topList[name] != null && Boolean(this.topList[name].hasOwnProperty("tips")))
         {
            btn = this.topList[name];
         }
         return btn;
      }
      
      public function hideBtnByName(name:String, bSort:Boolean = true) : void
      {
         var btn:Object = null;
         var index:int = 0;
         var iconBtn:TopButton = null;
         if(this.topList[name] != null)
         {
            iconBtn = this.topList[name].item;
            if(iconBtn == null)
            {
               return;
            }
            iconBtn.hide = 1;
            this.resetIconSort();
         }
      }
      
      public function showBtnByName(name:String) : void
      {
         var btn:TopButton = null;
         var iconBtn:TopButton = null;
         if(this.topList[name] != null)
         {
            iconBtn = this.topList[name].item;
            if(iconBtn == null)
            {
               return;
            }
            iconBtn.hide = 0;
            this.resetIconSort();
         }
      }
      
      public function showRedPointByName(name:String, flag:Boolean = false) : void
      {
         var btn:TopButton = null;
         var iconBtn:TopButton = null;
         if(this.topList[name] != null)
         {
            iconBtn = this.topList[name].item;
            if(iconBtn == null)
            {
               return;
            }
            iconBtn.setRedPoint(flag);
         }
      }
      
      private function hideSort(name:String, $row:int, $col:int) : void
      {
         var iconbtn:Object = null;
         var flag:Boolean = false;
         for each(iconbtn in this.topList)
         {
            if(iconbtn.item.row == $row)
            {
               if($col > maxNum)
               {
                  if(iconbtn.item.col >= maxNum && iconbtn.item.col < $col)
                  {
                     ++iconbtn.item.col;
                     flag = true;
                     iconbtn.item.x = (iconbtn.item.col - 1) * btnGap + posGap;
                  }
               }
               else if(iconbtn.item.col < maxNum && iconbtn.item.col > $col)
               {
                  --iconbtn.item.col;
                  iconbtn.item.x = (iconbtn.item.col - 1) * btnGap + posGap;
                  flag = true;
               }
            }
         }
         if(flag)
         {
            return;
         }
         for each(iconbtn in this.topList)
         {
            if(iconbtn.item.col == $col && !flag)
            {
               if(iconbtn.item.row > $row)
               {
                  --iconbtn.item.row;
                  iconbtn.item.y = (iconbtn.item.row - 1) * btnGap + posGap;
               }
            }
         }
      }
      
      private function showSort(name:String, $row:int, $col:int) : void
      {
         var iconbtn:Object = null;
         var flag:Boolean = false;
         var tempList:Array = [];
         for each(iconbtn in this.topList)
         {
            if(iconbtn.item.row == $row)
            {
               if($col > maxNum)
               {
                  if(iconbtn.item.col >= maxNum && iconbtn.item.col <= $col && iconbtn.item.name != name)
                  {
                     --iconbtn.item.col;
                     flag = true;
                     iconbtn.item.x = (iconbtn.item.col - 1) * btnGap + posGap;
                  }
               }
               else if(iconbtn.item.col < maxNum && iconbtn.item.col >= $col && iconbtn.item.name != name)
               {
                  ++iconbtn.item.col;
                  iconbtn.item.x = (iconbtn.item.col - 1) * btnGap + posGap;
                  flag = true;
               }
            }
         }
         if(flag)
         {
            return;
         }
         for each(iconbtn in this.topList)
         {
            if(iconbtn.item.col == $col)
            {
               if(iconbtn.item.row >= $row && iconbtn.item.name != name)
               {
                  ++iconbtn.item.row;
                  iconbtn.item.y = (iconbtn.item.row - 1) * btnGap + posGap;
                  flag = true;
               }
            }
         }
      }
      
      public function getMovieClipByName(name:String) : MovieClip
      {
         var cls:Class = null;
         if(this._domain.hasDefinition(name))
         {
            cls = this._domain.getDefinition(name) as Class;
            return new cls() as MovieClip;
         }
         return null;
      }
      
      public function getBitmapDataByName(name:String) : BitmapData
      {
         var cls:Class = null;
         if(this._domain.hasDefinition(name))
         {
            cls = this._domain.getDefinition(name) as Class;
            return new cls() as BitmapData;
         }
         return null;
      }
      
      private function loadViewIcon() : void
      {
         this._viewc1 = this.getMovieClipByName("viewc1");
         addChild(this._viewc1);
         this._viewc1.x = 392;
         this._viewc1.gotoAndStop(2);
         this._viewc1.addEventListener(MouseEvent.CLICK,this.onClickLeftIcon);
         this._leftIconBox = new Sprite();
         addChild(this._leftIconBox);
         this._leftIconBox.x = Math.floor(this._viewc1.x - this._viewc1.width / 2);
         this._leftIconBox.y = Math.floor(this._viewc1.width / 2);
         addChild(this._viewc1);
         this._viewc2 = this.getMovieClipByName("viewc2");
         addChild(this._viewc2);
         this._viewc2.x = 570;
         this._viewc2.gotoAndStop(2);
         this._viewc2.addEventListener(MouseEvent.CLICK,this.onClickRightIcon);
         this._rightIconBox = new Sprite();
         addChild(this._rightIconBox);
         this._rightIconBox.x = this._viewc2.x + Math.floor(this._viewc2.width / 2);
         this._rightIconBox.y = Math.floor(this._viewc2.width / 2);
         addChild(this._viewc2);
      }
      
      private function onClickLeftIcon(event:MouseEvent) : void
      {
         this.playIconAni(this._viewc1,this._leftIconBox);
      }
      
      private function onClickRightIcon(event:MouseEvent) : void
      {
         this.playIconAni(this._viewc2,this._rightIconBox);
      }
      
      private function playIconAni(viewc:MovieClip, iconBox:Sprite) : void
      {
         iconBox.visible = true;
         if(viewc.currentFrame == 2)
         {
            viewc.gotoAndStop(1);
            TweenMax.to(iconBox,1,{
               "alpha":0,
               "scaleX":0.1,
               "scaleY":0.1,
               "onComplete":this.onIconShow,
               "onCompleteParams":[0],
               "visible":false
            });
         }
         else
         {
            viewc.gotoAndStop(2);
            TweenMax.to(iconBox,1,{
               "alpha":1,
               "scaleX":1,
               "scaleY":1,
               "onComplete":this.onIconShow,
               "onCompleteParams":[0]
            });
         }
      }
      
      private function onIconShow(index:int) : void
      {
      }
      
      public function disport() : void
      {
         if(Boolean(this._viewc1))
         {
            this._viewc1.removeEventListener(MouseEvent.CLICK,this.onClickLeftIcon);
         }
         if(Boolean(this._viewc2))
         {
            this._viewc2.removeEventListener(MouseEvent.CLICK,this.onClickRightIcon);
         }
         this._domain = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

