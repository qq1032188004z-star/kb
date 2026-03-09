package com.game.modules.view.battle.pop
{
   import com.game.Tools.AttributeCharacterIcon;
   import com.game.facade.ApplicationFacade;
   import com.game.locators.EventDefine;
   import com.game.locators.GameData;
   import com.game.manager.AlertManager;
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
   
   public class ChangeSkillView extends HLoaderSprite
   {
      
      private var sid:uint;
      
      private var data:LevelUpData;
      
      public var changdata:Object = {};
      
      private var selectBool:Boolean = false;
      
      private var iloader:Loader;
      
      private var _attIcon:AttributeCharacterIcon;
      
      private var _learnIcon:AttributeCharacterIcon;
      
      private var _skillIcon:Vector.<AttributeCharacterIcon>;
      
      private var selectid:int;
      
      public function ChangeSkillView(value:LevelUpData)
      {
         super();
         this.init();
         this.data = value;
         ApplicationFacade.getInstance().registerViewLogic(new WinSkillControl(this));
      }
      
      private function init() : void
      {
         this.url = "assets/battle/battlebg/battleChangeSkill.swf";
      }
      
      override public function setShow() : void
      {
         var i:int = 0;
         this.bg.okBtn.addEventListener(MouseEvent.CLICK,this.onClickOkBtnHandler);
         this.bg.noBtn.addEventListener(MouseEvent.CLICK,this.onClickNoBtnHandler);
         if(GameData.instance.playerData.isAutoBattle)
         {
            this.sid = setTimeout(this.onClickNoBtnHandler,1000);
         }
         var l:int = int(this.data.oldskill.length);
         for(i = 0; i < l; i++)
         {
            this.bg["skillitem" + int(i + 1)].gotoAndStop(1);
         }
         this.showSkillInfo();
         this.loaderIcon();
      }
      
      private function loaderIcon() : void
      {
         this.iloader = new Loader();
         this.iloader.scaleX = 0.7;
         this.iloader.scaleY = 0.7;
         this.iloader.x = 94;
         this.iloader.y = 33;
         this.iloader.load(new URLRequest(URLUtil.getSvnVer("assets/monsterswf/" + this.data.spiritid + ".swf")));
         this.iloader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.iconLoaderComp);
         this.iloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOerrorHandler);
      }
      
      private function iconLoaderComp(event:Event) : void
      {
         this.iloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.iconLoaderComp);
         this.iloader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOerrorHandler);
         this.addChild(this.iloader);
         this.setCircleMask(this.iloader,40,188 - 65,50 + 18);
      }
      
      private function onIOerrorHandler(event:IOErrorEvent) : void
      {
         O.o("精魂升级窗口【精魂头像】加载失败" + event);
         this.iloader.load(new URLRequest("assets/monsterswf/1003.swf"));
      }
      
      private function getAttIcon() : AttributeCharacterIcon
      {
         if(this._attIcon == null)
         {
            this._attIcon = new AttributeCharacterIcon();
            this._attIcon.isShowAttWord = false;
            this.bg.spAtt.addChild(this._attIcon);
         }
         return this._attIcon;
      }
      
      private function getLearnIcon() : AttributeCharacterIcon
      {
         if(this._learnIcon == null)
         {
            this._learnIcon = new AttributeCharacterIcon();
            this._learnIcon.isShowAttWord = false;
            this.bg.learnSkillItem.spAtt.addChild(this._learnIcon);
         }
         return this._learnIcon;
      }
      
      private function showSkillInfo() : void
      {
         var icon:AttributeCharacterIcon = null;
         var i:int = 0;
         var xml:XML = XMLLocator.getInstance().getSprited(this.data.spiritid);
         this.bg.spiritname.text = "" + xml.name;
         icon = this.getAttIcon();
         icon.id = xml.elem;
         this.bg.desc.text = xml.name + "可以学习新技能了";
         var skillid:int = int(this.data.skillarr[0].skillid);
         xml = XMLLocator.getInstance().getSkill(skillid);
         this.bg.learnSkillItem.skillname.text = "" + xml.name;
         this.bg.learnSkillItem.skillpower.text = "威力:" + (int(xml.power) == 0 ? "--" : xml.power);
         this.bg.learnSkillItem.skilltimes.text = "PP:" + xml.count + "/" + xml.count;
         icon = this.getLearnIcon();
         icon.id = xml.elem;
         this.bg.learnSkillItem.addEventListener(MouseEvent.ROLL_OVER,this.onRollOverItem);
         this.bg.learnSkillItem.addEventListener(MouseEvent.ROLL_OUT,this.onRollOutItem);
         this.bg.learnSkillItem.gotoAndStop(2);
         var l:int = int(this.data.oldskill.length);
         for(i = 0; i < l; i++)
         {
            skillid = int(this.data.oldskill[i].skillid);
            xml = XMLLocator.getInstance().getSkill(skillid);
            this.bg["skillitem" + int(i + 1)].skillname.text = "" + xml.name;
            this.bg["skillitem" + int(i + 1)].skillpower.text = "威力:" + xml.power;
            this.bg["skillitem" + int(i + 1)].skilltimes.text = "PP:" + xml.count + "/" + xml.count;
            this.getSkillIcon()[i].id = xml.elem;
            this.bg["skillitem" + int(i + 1)].addEventListener(MouseEvent.CLICK,this.onClickSkillItem);
            this.bg["skillitem" + int(i + 1)].addEventListener(MouseEvent.ROLL_OVER,this.onRollOverItem);
            this.bg["skillitem" + int(i + 1)].addEventListener(MouseEvent.ROLL_OUT,this.onRollOutItem);
         }
      }
      
      private function getSkillIcon() : Vector.<AttributeCharacterIcon>
      {
         var i:int = 0;
         var icon:AttributeCharacterIcon = null;
         if(this._skillIcon == null)
         {
            this._skillIcon = new Vector.<AttributeCharacterIcon>();
            for(i = 0; i < 4; i++)
            {
               icon = new AttributeCharacterIcon();
               this.bg["skillitem" + int(i + 1)].spAtt.addChild(icon);
               this._skillIcon.push(icon);
            }
         }
         return this._skillIcon;
      }
      
      private function onRollOverItem(event:MouseEvent) : void
      {
         var skillid:int = 0;
         var i:int = 0;
         var tn:String = "";
         var td:String = "";
         if(event.currentTarget.name == "learnSkillItem")
         {
            skillid = int(this.data.skillarr[0].skillid);
         }
         else
         {
            i = int(event.currentTarget.name.charAt(9));
            skillid = int(this.data.oldskill[i - 1].skillid);
         }
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
      
      private function onClickSkillItem(event:MouseEvent) : void
      {
         var i:int = 0;
         this.selectid = int(String(event.currentTarget.name).charAt(9)) - 1;
         var l:int = int(this.data.oldskill.length);
         for(i = 0; i < l; i++)
         {
            this.bg["skillitem" + int(i + 1)].gotoAndStop(1);
         }
         event.currentTarget.gotoAndStop(2);
         this.selectBool = true;
      }
      
      private function onClickOkBtnHandler(event:MouseEvent) : void
      {
         var id:int = 0;
         var obj:Object = null;
         if(!this.selectBool)
         {
            AlertManager.instance.addTipAlert({
               "tip":"请先选择要替换的技能!",
               "type":1
            });
            return;
         }
         var xml:XML = XMLLocator.getInstance().getSkill(this.data.skillarr[0].skillid);
         var oldID:int = int(this.data.oldskill[this.selectid].skillid);
         var ary:Array = LuaObjUtil.getLuaObjArr(xml.repel);
         var curAry:Array = this.data.oldskill;
         if(ary.length > 0)
         {
            for each(id in ary)
            {
               if(oldID == id)
               {
                  break;
               }
               for each(obj in curAry)
               {
                  if(obj["skillid"] == id)
                  {
                     AlertManager.instance.addTipAlert({
                        "tip":xml.name + "和" + XMLLocator.getInstance().getSkill(id).name + "互斥了，只能同时携带1个哦！",
                        "type":2
                     });
                     return;
                  }
               }
            }
         }
         this.data.oldskill[this.selectid].skillid = this.data.skillarr[0].skillid;
         this.data.oldskill[this.selectid].time = xml.count + "";
         this.data.skillarr.shift();
         if(this.data.skillarr.length > 0)
         {
            this.changdata.uniqueid = this.data.uniqueid;
            this.changdata.key = this.data.key;
            this.changdata.newskillarr = this.data.oldskill;
            this.dispatchEvent(new Event("clickchangbtn"));
            this.showSkillInfo();
         }
         else
         {
            this.changdata.uniqueid = this.data.uniqueid;
            this.changdata.key = this.data.key;
            this.changdata.newskillarr = this.data.oldskill;
            this.dispatchEvent(new Event("clickchangbtn"));
            dispatchEvent(new Event(Event.CLOSE));
            if(Boolean(this.parent) && this.parent.contains(this))
            {
               this.parent.removeChild(this);
            }
            this.disport();
         }
      }
      
      private function onClickNoBtnHandler(event:MouseEvent = null) : void
      {
         clearTimeout(this.sid);
         this.data.skillarr.shift();
         if(this.data.skillarr.length > 0)
         {
            this.showSkillInfo();
         }
         else
         {
            dispatchEvent(new Event(Event.CLOSE));
            if(Boolean(this.parent) && this.parent.contains(this))
            {
               this.parent.removeChild(this);
            }
            this.disport();
         }
      }
      
      override public function disport() : void
      {
         var icon:AttributeCharacterIcon = null;
         ApplicationFacade.getInstance().dispatch(EventDefine.LEARN_SKILL_CLOSE);
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
         if(Boolean(this._learnIcon))
         {
            this._learnIcon.dispose();
            this._learnIcon = null;
         }
         if(Boolean(this._skillIcon))
         {
            for each(icon in this._skillIcon)
            {
               icon.dispose();
            }
            this._skillIcon = null;
         }
         ApplicationFacade.getInstance().removeViewLogic(WinSkillControl.NAME);
         this.data = null;
         super.disport();
      }
   }
}

