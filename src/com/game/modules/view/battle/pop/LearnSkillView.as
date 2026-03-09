package com.game.modules.view.battle.pop
{
   import com.game.Tools.AttributeCharacterIcon;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.game.modules.control.battle.WinSkillControl;
   import com.game.modules.view.battle.item.ItemTip;
   import com.game.util.HLoaderSprite;
   import com.game.util.LuaObjUtil;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.loading.XMLLocator;
   import com.xygame.module.battle.data.LevelUpData;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class LearnSkillView extends HLoaderSprite
   {
      
      private var sid:uint;
      
      private var data:LevelUpData;
      
      private var _attIcon:AttributeCharacterIcon;
      
      private var iloader:Loader;
      
      public var changdata:Object = {};
      
      public function LearnSkillView(value:LevelUpData)
      {
         super();
         this.data = value;
         this.init();
         ApplicationFacade.getInstance().registerViewLogic(new WinSkillControl(this));
      }
      
      private function init() : void
      {
         this.url = "assets/battle/battlebg/battleLearnSkill.swf";
      }
      
      override public function setShow() : void
      {
         if(Boolean(this.bg.hasOwnProperty("okbtn")))
         {
            this.bg.okbtn.addEventListener(MouseEvent.CLICK,this.onClickOkBtnHandler);
         }
         if(Boolean(this.bg.hasOwnProperty("xbtn")))
         {
            this.bg.xbtn.addEventListener(MouseEvent.CLICK,this.onClickOkBtnHandler);
         }
         if(GameData.instance.playerData.isAutoBattle)
         {
            this.sid = setTimeout(this.onClickOkBtnHandler,1000);
         }
         this.showInfo();
         this.loaderIcon();
      }
      
      private function loaderIcon() : void
      {
         this.iloader = new Loader();
         this.iloader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterswf/" + this.data.spiritid + ".swf")));
         this.iloader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.iconLoaderComp);
         this.iloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOerrorHandler);
      }
      
      private function iconLoaderComp(event:Event) : void
      {
         this.iloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.iconLoaderComp);
         this.iloader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOerrorHandler);
         this.iloader.scaleY = 1.2;
         this.iloader.scaleX = 1.2;
         this.iloader.x = 40;
         this.iloader.y = 30;
         this.addChild(this.iloader);
      }
      
      private function onIOerrorHandler(event:IOErrorEvent) : void
      {
         O.o("精魂升级窗口【精魂头像】加载失败" + event);
         this.iloader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterswf/1003.swf")));
      }
      
      private function showInfo() : void
      {
         var xml:XML = XMLLocator.getInstance().getSprited(this.data.spiritid);
         var skillid:int = int(this.data.skillarr[0].skillid);
         this.bg.spiritname.text = "" + xml.name;
         xml = XMLLocator.getInstance().getSkill(skillid);
         this.bg.desc.text = "" + this.bg.spiritname.text + "学会了新技能" + "[" + xml.name + "]";
         this.bg.skillitem.gotoAndStop(1);
         this.bg.skillitem.skillname.text = "" + xml.name;
         this.bg.skillitem.skillpower.text = "威力" + (int(xml.power) == 0 ? "--" : xml.power);
         this.bg.skillitem.skilltimes.text = "PP" + xml.count + "/" + xml.count;
         if(this._attIcon == null)
         {
            this._attIcon = new AttributeCharacterIcon();
            this._attIcon.isShowAttWord = false;
            this._attIcon.isShowTip = false;
            this.bg.skillitem.spAtt.addChild(this._attIcon);
         }
         this._attIcon.id = int(xml.elem);
         this.bg.skillitem.addEventListener(MouseEvent.ROLL_OVER,this.onRollOverItem);
         this.bg.skillitem.addEventListener(MouseEvent.ROLL_OUT,this.onRollOutItem);
      }
      
      private function onRollOverItem(event:MouseEvent) : void
      {
         var skillid:int = 0;
         var tn:String = "";
         var td:String = "";
         skillid = int(this.data.skillarr[0].skillid);
         var xml:XML = XMLLocator.getInstance().getSkill(skillid);
         tn = xml.name + "";
         td = "<font color=\'#FF0000\'>类型:" + xml.type + "</font>\n" + "<font color=\'#FFFFFF\'>作用:" + xml.desc + "</font>";
         ItemTip.instance.show({
            "toolname":tn,
            "tooldesc":td
         },this,event.currentTarget.x,event.currentTarget.y - 80);
      }
      
      private function onRollOutItem(event:MouseEvent) : void
      {
         ItemTip.instance.hide();
      }
      
      private function onClickOkBtnHandler(event:MouseEvent = null) : void
      {
         var repelAry:Array = null;
         var id:int = 0;
         var oldObj:Object = null;
         clearTimeout(this.sid);
         var obj:Object = new Object();
         var xml:XML = XMLLocator.getInstance().getSkill(this.data.skillarr[0].skillid);
         obj.time = xml.count + "";
         obj.skillid = this.data.skillarr[0].skillid;
         var flag:Boolean = true;
         if(this.data.oldskill.length > 0)
         {
            repelAry = LuaObjUtil.getLuaObjArr(xml.repel);
            if(repelAry.length > 0)
            {
               for each(id in repelAry)
               {
                  for each(oldObj in this.data.oldskill)
                  {
                     if(oldObj["skillid"] == id)
                     {
                        flag = false;
                        break;
                     }
                  }
                  if(!flag)
                  {
                     break;
                  }
               }
            }
         }
         if(flag)
         {
            this.data.oldskill.push(obj);
         }
         this.data.skillarr.shift();
         if(this.data.skillarr.length > 0 && this.data.oldskill.length < 4)
         {
            this.showInfo();
         }
         else
         {
            this.changdata.uniqueid = this.data.uniqueid;
            this.changdata.key = this.data.key;
            this.changdata.newskillarr = this.data.oldskill;
            this.dispatchEvent(new Event("clickchangbtn"));
            if(this.data.oldskill.length > 3 && this.data.skillarr.length > 0)
            {
               this.dispatchEvent(new Event(Event.CANCEL));
            }
            else
            {
               this.dispatchEvent(new Event(Event.CLOSE));
               ApplicationFacade.getInstance().dispatch(EventDefine.LEARN_SKILL_CLOSE);
            }
            this.disport();
         }
      }
      
      override public function disport() : void
      {
         if(Boolean(this.iloader))
         {
            clearTimeout(this.sid);
            if(this.contains(this.iloader))
            {
               this.removeChild(this.iloader);
            }
            this.iloader.unload();
            this.iloader = null;
         }
         if(Boolean(this._attIcon))
         {
            this._attIcon.dispose();
            this._attIcon = null;
         }
         ApplicationFacade.getInstance().removeViewLogic(WinSkillControl.NAME);
         this.data = null;
         super.disport();
      }
      
      public function get spiritData() : LevelUpData
      {
         return this.data;
      }
      
      public function newOldSkillBack(obj:Object) : void
      {
         O.o("ok 接收");
      }
   }
}

