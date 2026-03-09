package com.game.modules.view.battle
{
   import com.game.util.TextScrollBar;
   import com.publiccomponent.loading.XMLLocator;
   import com.publiccomponent.loading.data.BufInfoTypeData;
   import com.publiccomponent.loading.data.SiteBuffTypeData;
   import com.xygame.module.battle.data.BufData;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   public class StatePanel extends MovieClip
   {
      
      private var statePanel_MC:MovieClip;
      
      private var scrollBar_MC:MovieClip;
      
      private var state_TXT:TextField;
      
      private var scrollbar:TextScrollBar;
      
      private var _playerAry:Array;
      
      private var _otherAry:Array;
      
      private var poleMC:SimpleButton;
      
      private var _curSiteName:String;
      
      private var myLt:RegExp = /</g;
      
      private var myRt:RegExp = /\>/g;
      
      public function StatePanel(stateFC:MovieClip, dis:int = 80)
      {
         super();
         this.statePanel_MC = stateFC;
         this.scrollBar_MC = this.statePanel_MC.scrollBar_mc;
         this.state_TXT = this.statePanel_MC.state_txt;
         this.state_TXT.htmlText = "";
         this.scrollbar = new TextScrollBar(this.statePanel_MC.scrollBar_mc.up_btn,this.statePanel_MC.scrollBar_mc.pole_mc,this.statePanel_MC.scrollBar_mc.down_btn,this.state_TXT,dis);
      }
      
      public function getSiteData(obj:Object) : void
      {
         var adTD:SiteBuffTypeData = null;
         var remTD:SiteBuffTypeData = null;
         switch(obj.params)
         {
            case BufData.COMBAT_SITE_ADD:
               adTD = XMLLocator.getInstance().getSiteInfo(obj.id);
               this._curSiteName = adTD.name;
               this.state_TXT.htmlText += "展开<font color=\'#9999FF\'>【" + this._curSiteName + "】</font><font color=\'#FF0000\'>" + obj.round + "</font>" + "回合";
               break;
            case BufData.COMBAT_SITE_MD:
               this.state_TXT.htmlText += "<font color=\'#9999FF\'>【" + this._curSiteName + "】</font>" + "，剩余回合数：" + "<font color=\'#FF0000\'>" + obj.round + "</font>";
               break;
            case BufData.COMBAT_SITE_DEL:
               remTD = XMLLocator.getInstance().getSiteInfo(obj.id);
               this.state_TXT.htmlText += "结束<font color=\'#9999FF\'>【" + remTD.name + "】</font>";
         }
         this.scrollbar.updata();
      }
      
      public function getStateData(resultObj:Object) : void
      {
         var xml:XML = XMLLocator.getInstance().getSkill(resultObj.skillid);
         if(resultObj.skillid == 0 || xml == null)
         {
            return;
         }
         if(Boolean(resultObj.isM))
         {
            this.state_TXT.htmlText += "<font color=\'#CCFF99\'>【" + this.getRealHtmlStr(resultObj.atkid) + "】</font>" + (resultObj.atkid == resultObj.defid ? "" : "对" + "<font color=\'#CCFF99\'>【" + this.getRealHtmlStr(resultObj.defid) + "】</font>") + "使用了" + "<font color=\'#9999FF\'>【" + this.getRealHtmlStr(xml == null ? "" : xml.name) + "】</font>" + "<font color=\'#ffffff\'>" + this.getRealHtmlStr(int(resultObj.brust) == 1 ? "触发暴击，" : null) + "</font>" + this.selfchang(resultObj.mhp) + this.gethpchange(resultObj.mhp,resultObj.ohp,resultObj.skillid) + ",【状态】" + "<font color=\'#ffffff\'>" + this.getRealHtmlStr(this.getBufName(resultObj.bufArr,resultObj.skillSid)) + "</font>" + "<font color=\'#ffffff\'>" + this.getRealHtmlStr(this.bufdesc(resultObj.miss,xml.range)) + String(resultObj.appendtxt != undefined ? String(resultObj.appendtxt) : "") + "。</font>";
         }
         else
         {
            this.state_TXT.htmlText += "<font color=\'#FF3366\'>【" + this.getRealHtmlStr(resultObj.atkid) + "】</font>" + (resultObj.atkid == resultObj.defid ? "" : "对" + "<font color=\'#FF3366\'>【" + this.getRealHtmlStr(resultObj.defid) + "】</font>") + "使用了" + "<font color=\'#9999FF\'> 【" + this.getRealHtmlStr(xml == null ? "" : xml.name) + "】</font>" + "<font color=\'#ffffff\'>" + this.getRealHtmlStr(int(resultObj.brust) == 1 ? "，触发暴击" : null) + "</font>" + this.selfchang(resultObj.ohp) + this.gethpchange(resultObj.ohp,resultObj.mhp,resultObj.skillid) + ",【状态】" + "<font color=\'#ffffff\'>" + this.getRealHtmlStr(this.getBufName(resultObj.bufArr,resultObj.skillSid)) + "</font>" + "<font color=\'#ffffff\'>" + this.getRealHtmlStr(this.bufdesc(resultObj.miss,xml.range)) + String(resultObj.appendtxt != undefined ? String(resultObj.appendtxt) : "") + "。</font>";
         }
         this.scrollbar.updata();
      }
      
      private function gethpchange(pvalue:int, ovalue:int, skillid:int = 0) : String
      {
         var hpchangestr:String = "";
         if(skillid != 3858)
         {
            if(ovalue < 0)
            {
               hpchangestr += "造成" + "<font color=\'#ff0000\'>" + Math.abs(ovalue) + "</font>" + "点伤害";
            }
            if(pvalue < 0)
            {
               hpchangestr += "自身承受" + "<font color=\'#ff0000\'>" + Math.abs(pvalue) + "</font>" + "点伤害";
            }
         }
         else
         {
            if(pvalue < 0)
            {
               hpchangestr += "自身减血" + "<font color=\'#ff0000\'>" + Math.abs(pvalue) + "</font>" + "";
            }
            if(ovalue < 0)
            {
               hpchangestr += "造成对手" + "<font color=\'#ff0000\'>" + Math.abs(ovalue) + "</font>" + "点伤害";
            }
         }
         return hpchangestr;
      }
      
      private function selfchang(value:int) : String
      {
         var changestr:String = "";
         if(value > 0 && value != 100000000)
         {
            changestr += "体力增加" + "<font color=\'#ff0000\'>" + value + "</font>";
         }
         return changestr;
      }
      
      private function bufdesc(miss:int, self:int) : String
      {
         if(miss == 1)
         {
            if(self == 2)
            {
               return "，使用失败";
            }
            return "，被成功躲闪";
         }
         return null;
      }
      
      public function getCounterattackDesc(isPlayer:Boolean, name:String, value:int, obj:Object) : void
      {
         var info:BufInfoTypeData = XMLLocator.getInstance().getBufInfo(obj.bufid);
         if(Boolean(info))
         {
            if(info.no_buf_blood == 1)
            {
               return;
            }
            if(isPlayer)
            {
               this.state_TXT.htmlText += "<font color=\'#CCFF99\'>【" + name + "】</font>遭到<font color=\'#ff0000\'>" + Math.abs(value) + "</font>" + "点" + info.buf_blood_desc + "。";
            }
            else
            {
               this.state_TXT.htmlText += "<font color=\'#FF3366\'>【" + name + "】</font>遭到<font color=\'#ff0000\'>" + Math.abs(value) + "</font>" + "点" + info.buf_blood_desc + "。";
            }
            this.scrollbar.updata();
         }
      }
      
      public function getUseToolInfo(value:Object) : void
      {
         var xml:XML = XMLLocator.getInstance().tooldic[int(value.toolid)];
         if(Boolean(xml))
         {
            this.state_TXT.htmlText += "<font color=\'#ffffff\'>【" + value.sid + "】</font>" + "使用了" + "<font color=\'#ffffff\'>" + xml.name + "，" + xml.desc + "。</font>";
         }
      }
      
      public function sceneChatData(obj:Object) : void
      {
         this.state_TXT.htmlText += "<font color=\'#FFFF00\'>" + obj.name + "说:</font>" + "<font color=\'#ffffff\'>" + obj.message + "</font>";
         this.scrollbar.updata();
      }
      
      private function getBufName(arr:Array, skillSid:int) : String
      {
         var i:int = 0;
         var strPlayer:String = null;
         var strOther:String = null;
         var name:String = null;
         var tempStr:String = null;
         this._playerAry = [];
         this._otherAry = [];
         for(i = 0; i < arr.length; i++)
         {
            switch(arr[i].add_or_remove)
            {
               case BufData.BUF_TYPE_1:
                  name = this.checkBufName(arr[i].bufid);
                  if(name != null)
                  {
                     tempStr = "";
                     if(arr[i].bufid == 12 || arr[i].bufid == 14 || arr[i].bufid == 90)
                     {
                        tempStr = arr[i].round + "回合";
                     }
                     tempStr += name;
                     if(arr[i].defid != skillSid)
                     {
                        this._otherAry.push("对方" + tempStr);
                     }
                     else
                     {
                        this._playerAry.push(tempStr);
                     }
                  }
                  break;
               case BufData.BUF_TYPE_2:
                  if(arr[i].bufid == 59)
                  {
                     if(arr[i].defid != skillSid)
                     {
                        this._otherAry.push("对方附加" + arr[i].param1 + "点固定伤害");
                     }
                     else
                     {
                        this._playerAry.push("附加" + arr[i].param1 + "点固定伤害");
                     }
                  }
            }
         }
         var str:String = "";
         for each(strPlayer in this._playerAry)
         {
            if(str != "")
            {
               str += ",";
            }
            str += strPlayer;
         }
         for each(strOther in this._otherAry)
         {
            if(str != "")
            {
               str += ",";
            }
            str += strOther;
         }
         if(str == "" || str == "，")
         {
            str = "正常";
         }
         return str;
      }
      
      private function checkBufName(bufid:int) : String
      {
         var td:BufInfoTypeData = XMLLocator.getInstance().getBufInfo(bufid);
         if(Boolean(td))
         {
            return td.name;
         }
         if(BufData.BUF_NAME.hasOwnProperty(bufid.toString()))
         {
            return BufData.BUF_NAME[bufid];
         }
         return null;
      }
      
      private function getRealHtmlStr(str:String) : String
      {
         if(str == null)
         {
            return "";
         }
         str = str.replace(this.myLt,"&lt;");
         return str.replace(this.myRt,"&gt;");
      }
      
      public function destroy() : void
      {
         this.scrollbar.destroy();
         this.scrollbar = null;
         while(this.statePanel_MC.numChildren > 0)
         {
            if(this.statePanel_MC.getChildAt(0) is MovieClip)
            {
               MovieClip(this.statePanel_MC.getChildAt(0)).stop();
            }
            this.statePanel_MC.removeChildAt(0);
         }
         this.statePanel_MC.stop();
         this.statePanel_MC = null;
      }
   }
}

