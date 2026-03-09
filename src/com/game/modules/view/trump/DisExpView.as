package com.game.modules.view.trump
{
   import com.game.facade.ApplicationFacade;
   import com.game.manager.EventManager;
   import com.game.modules.control.task.TaskList;
   import com.game.modules.control.trump.DisExpControl;
   import com.game.modules.control.trump.TrumpEvent;
   import com.game.modules.view.item.MonsterImageItem;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.game.util.TimeTransform;
   import com.kb.util.CommonDefine;
   import com.publiccomponent.alert.Alert;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.ui.ToolTip;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class DisExpView extends HLoaderSprite
   {
      
      private var disExpClip:MovieClip;
      
      private var tileList:TileList;
      
      private var param:Object;
      
      private var currentObj:Object;
      
      private var currentExp:int;
      
      private var mloader:Loader;
      
      private var lastNeedExp:int;
      
      public function DisExpView()
      {
         super();
         GreenLoading.loading.visible = true;
         this.mloader = new Loader();
         this.mloader.x = 245;
         this.mloader.y = 153;
         this.initList();
         this.url = "assets/material/disexp.swf";
      }
      
      override public function setShow() : void
      {
         this.loader.loader.unloadAndStop(false);
         this.disExpClip = this.bg as MovieClip;
         this.addChild(this.disExpClip);
         this.disExpClip.expTxt.restrict = "0-9";
         this.addChild(this.tileList);
         this.mloader.addEventListener(IOErrorEvent.IO_ERROR,this.onIoerrorHandler);
         addChild(this.mloader);
         ApplicationFacade.getInstance().registerViewLogic(new DisExpControl(this));
         GreenLoading.loading.visible = false;
         TaskList.getInstance().checkUrlAndFreshManTask(url);
      }
      
      private function onIoerrorHandler(evt:IOErrorEvent) : void
      {
         if(this.param && this.param.spiritArr && Boolean(this.param.spiritArr[0]))
         {
            if(this.param.spiritArr[0].iid != 0)
            {
               this.mloader.load(new URLRequest("assets/monsterswf/" + this.param.spiritArr[0].iid + ".swf"));
            }
         }
      }
      
      private function initList() : void
      {
         this.tileList = new TileList(35,138);
         this.tileList.build(2,3,60,60,22,17,MonsterImageItem);
      }
      
      public function initEvents() : void
      {
         EventManager.attachEvent(this.disExpClip.closeBtn,MouseEvent.CLICK,this.closeView);
         EventManager.attachEvent(this.disExpClip.addBtn,MouseEvent.MOUSE_DOWN,this.addExp);
         EventManager.attachEvent(this.disExpClip.resetBtn,MouseEvent.MOUSE_DOWN,this.resetExp);
         EventManager.attachEvent(this.disExpClip.reduceBtn,MouseEvent.MOUSE_DOWN,this.reduceExp);
         EventManager.attachEvent(this.disExpClip.sureBtn,MouseEvent.MOUSE_DOWN,this.startDis);
         EventManager.attachEvent(this.disExpClip.expTxt,Event.CHANGE,this.onDataChange);
         EventManager.attachEvent(this.tileList,ItemClickEvent.ITEMCLICKEVENT,this.itemClick,true);
         ToolTip.BindDO(this.disExpClip.dragClip,"点击拖动面板");
      }
      
      public function removeEvents() : void
      {
         EventManager.removeEvent(this.disExpClip.closeBtn,MouseEvent.CLICK,this.closeView);
         EventManager.removeEvent(this.disExpClip.addBtn,MouseEvent.MOUSE_DOWN,this.addExp);
         EventManager.removeEvent(this.disExpClip.resetBtn,MouseEvent.MOUSE_DOWN,this.resetExp);
         EventManager.removeEvent(this.disExpClip.reduceBtn,MouseEvent.MOUSE_DOWN,this.reduceExp);
         EventManager.removeEvent(this.disExpClip.sureBtn,MouseEvent.MOUSE_DOWN,this.startDis);
         EventManager.removeEvent(this.disExpClip.expTxt,Event.CHANGE,this.onDataChange);
         EventManager.removeEvent(this.tileList,ItemClickEvent.ITEMCLICKEVENT,this.itemClick);
      }
      
      public function build(param:Object) : void
      {
         this.param = param;
         if(param != null)
         {
            this.disExpClip.totalExpTxt.text = param.totalExp;
            if(param.spiritArr != null)
            {
               this.tileList.dataProvider = param.spiritArr;
               this.setMonsterInfo(param.spiritArr[0]);
            }
         }
      }
      
      private function setMonsterInfo(obj:Object) : void
      {
         var item:MonsterImageItem = null;
         if(obj == null)
         {
            this.disExpClip.snTxt.text = "";
            this.disExpClip.nameTxt.text = "";
            this.disExpClip.levelTxt.text = "";
            this.disExpClip.moldTxt.text = "";
            this.disExpClip.needExpTxt.text = "";
            this.disExpClip.needClip.gotoAndStop(1);
            this.disExpClip.timeTxt.text = "";
            return;
         }
         var xml:XML = XMLLocator.getInstance().getSprited(obj.iid);
         this.currentObj = obj;
         this.disExpClip.snTxt.text = xml.sequence;
         this.disExpClip.nameTxt.text = obj.name;
         this.disExpClip.levelTxt.text = obj.level;
         this.disExpClip.moldTxt.text = CommonDefine.moldList[obj.mold - 1 < 0 ? 0 : obj.mold - 1];
         var exp:int = obj.needExp - obj.exp;
         if(exp <= 0)
         {
            exp = 0;
         }
         var frame:int = int(obj.exp * 100 / obj.needExp);
         if(frame <= 0)
         {
            frame = 1;
         }
         if(frame >= 100)
         {
            frame = 100;
         }
         var level:int = int(this.disExpClip.levelTxt.text);
         if(level >= 100)
         {
            this.disExpClip.needExpTxt.text = "已满级";
         }
         else
         {
            this.disExpClip.needExpTxt.text = exp + "";
         }
         this.disExpClip.needClip.gotoAndStop(frame);
         this.disExpClip.timeTxt.text = TimeTransform.getInstance().transDate(obj.time);
         this.mloader.load(new URLRequest("assets/monsterswf/" + obj.iid + ".swf"));
         var num:int = this.tileList.numChildren;
         for(var i:int = 0; i < num; i++)
         {
            item = this.tileList.getChildAt(i) as MonsterImageItem;
            if(item.data.id == this.currentObj.id)
            {
               item.filters = ColorUtil.getGrowFilter();
            }
            else
            {
               item.filters = [];
            }
         }
      }
      
      private function closeView(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function addExp(evt:MouseEvent) : void
      {
         this.currentExp += 1;
         if(this.currentExp >= this.param.totalExp)
         {
            if(this.param.totalExp > 0)
            {
               this.currentExp = this.param.totalExp;
            }
            else
            {
               this.currentExp = 0;
            }
         }
         this.disExpClip.expTxt.text = this.currentExp + "";
         TaskList.getInstance().checkUrlAndFreshManTask(url,2);
      }
      
      private function reduceExp(evt:MouseEvent) : void
      {
         this.currentExp -= 1;
         if(this.currentExp <= 0)
         {
            this.currentExp = 0;
         }
         this.disExpClip.expTxt.text = this.currentExp + "";
      }
      
      private function resetExp(evt:MouseEvent) : void
      {
         this.disExpClip.expTxt.text = "0";
         this.currentExp = 0;
      }
      
      private function startDis(evt:MouseEvent) : void
      {
         TaskList.getInstance().sendTalkBack();
         if(this.param != null && this.param.totalExp <= 0)
         {
            new Alert().show("你没有历练了哦,快去赚取历练吧!");
            return;
         }
         if(this.currentObj == null)
         {
            new Alert().show("请选择一个妖怪");
            return;
         }
         if(this.currentExp <= 0)
         {
            new Alert().show("历练不能等于0哦!");
            return;
         }
         if(this.currentObj.level >= 100)
         {
            new Alert().show("你已经登峰造极了,不需要历练了!");
            return;
         }
         if(this.currentExp >= 100000)
         {
            new Alert().showSureOrCancel("你现在要分配超过10万经验给你的妖怪哦，确定吗?",this.onSureDistribute);
            return;
         }
         var body:Object = {
            "uniqueid":this.currentObj.id,
            "expvalue":this.currentExp
         };
         this.disExpClip.expTxt.text = "0";
         this.currentExp = 0;
         dispatchEvent(new TrumpEvent(TrumpEvent.distributeExp,body));
      }
      
      private function onSureDistribute(str:String, data:Object) : void
      {
         var body:Object = null;
         if(bg == null)
         {
            return;
         }
         if(str == "确定")
         {
            body = {
               "uniqueid":this.currentObj.id,
               "expvalue":this.currentExp
            };
            this.disExpClip.expTxt.text = "0";
            this.currentExp = 0;
            dispatchEvent(new TrumpEvent(TrumpEvent.distributeExp,body));
         }
      }
      
      public function disExpBack(obj:Object) : void
      {
         var item:Object = null;
         this.param.totalExp -= obj.exp;
         if(this.param.totalExp <= 0)
         {
            this.param.totalExp = 0;
         }
         var list:Array = this.param.spiritArr;
         if(list != null)
         {
            for each(item in list)
            {
               if(item.id == obj.id)
               {
                  this.changeItem(item,obj);
                  break;
               }
            }
         }
      }
      
      private function changeItem(obj:Object, obj2:Object) : void
      {
         this.disExpClip.totalExpTxt.text = this.param.totalExp;
         obj.exp += obj2.exp;
         this.lastNeedExp = obj.needExp;
         obj.needExp = obj2.needExp;
         if(obj.iid != obj2.iid)
         {
            obj.iid = obj2.iid;
            this.dispatchEvent(new TrumpEvent(TrumpEvent.reupdateimg));
         }
         obj.exp = obj2.currentExp;
         obj.level = obj2.currentlevel;
         this.setMonsterInfo(obj);
      }
      
      private function getItemById(id:int) : MonsterImageItem
      {
         var tempmmitem:MonsterImageItem = null;
         for(var i:int = 0; i < this.tileList.numChildren; i++)
         {
            if((this.tileList.getChildAt(i) as MonsterImageItem).data.id == id)
            {
               tempmmitem = this.tileList.getChildAt(i) as MonsterImageItem;
               break;
            }
         }
         return tempmmitem;
      }
      
      private function loopCalu(obj:Object) : void
      {
         if(obj.exp >= this.lastNeedExp)
         {
            obj.exp -= obj.needExp;
            obj.level += 1;
            this.lastNeedExp = obj.needExp;
            this.loopCalu(obj);
         }
         else
         {
            this.setMonsterInfo(obj);
         }
      }
      
      private function itemClick(evt:ItemClickEvent) : void
      {
         this.currentObj = evt.params;
         this.setMonsterInfo(this.currentObj);
      }
      
      private function onDataChange(evt:Event) : void
      {
         this.currentExp = int(this.disExpClip.expTxt.text);
         if(this.currentExp <= 0)
         {
            this.disExpClip.expTxt.text = "0";
         }
         if(this.currentExp >= this.param.totalExp)
         {
            if(this.param.totalExp > 0)
            {
               this.currentExp = this.param.totalExp;
            }
            else
            {
               this.currentExp = 0;
            }
            this.disExpClip.expTxt.text = this.currentExp + "";
         }
         TaskList.getInstance().checkUrlAndFreshManTask(url,2);
      }
      
      override public function disport() : void
      {
         CacheUtil.deleteObject(DisExpView);
         ApplicationFacade.getInstance().removeViewLogic(DisExpControl.NAME);
         this.currentObj = null;
         if(Boolean(this.mloader))
         {
            this.mloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoerrorHandler);
            if(this.contains(this.mloader))
            {
               this.removeChild(this.mloader);
            }
            this.mloader.unloadAndStop(false);
         }
         this.mloader = null;
         if(this.tileList != null)
         {
            this.tileList.dataProvider = [];
         }
         this.tileList = null;
         if(Boolean(this.disExpClip) && Boolean(this.disExpClip.parent))
         {
            this.disExpClip.parent.removeChild(this.disExpClip);
         }
         this.disExpClip = null;
         super.disport();
      }
   }
}

