package com.game.modules.vo.list
{
   import com.core.observer.MessageEvent;
   import com.game.event.EventConst;
   import com.game.locators.CacheData;
   import com.game.locators.MsgDoc;
   import com.game.modules.view.FaceView;
   import com.game.modules.vo.messageBox.OnlineBaseVo;
   import com.game.modules.vo.messageBox.OnlineIntoVo;
   import flash.events.EventDispatcher;
   import org.green.server.manager.SocketManager;
   
   public class OnlineList extends EventDispatcher
   {
      
      private var onlines:Array = [];
      
      public function OnlineList()
      {
         super();
      }
      
      public function build() : void
      {
         var onlineIntroVo:OnlineIntoVo = null;
         var onlineVo:OnlineBaseVo = null;
         var onlinelist:Array = CacheData.instance.onlineIntros.getIntroLists();
         for each(onlineIntroVo in onlinelist)
         {
            onlineVo = new OnlineBaseVo();
            onlineVo.onlineIntroVo = onlineIntroVo;
            this.addOnlineAsObject(onlineVo);
            if(onlineVo.onlineIntroVo.type != 4)
            {
               SocketManager.getGreenSocket().sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,onlineIntroVo.actid,[0]);
            }
            else
            {
               CacheData.instance.onlinelist.setPlayState(onlineVo.onlineIntroVo.actid,false);
            }
         }
         SocketManager.getGreenSocket().sendCmd(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,10000,[0]);
         FaceView.clip.bottomClip.setNewsclipState(this.searchIsJump());
      }
      
      public function initialize($actid:int, $playTime:int, $timePlus:int) : void
      {
         var onlineVo:OnlineBaseVo = this.getOnline($actid);
         if(Boolean(onlineVo))
         {
            onlineVo.timePlus = $timePlus;
            onlineVo.playTime = $playTime;
            this.update();
         }
      }
      
      public function setOnlineActive($actid:int, $state:Boolean = false) : void
      {
         var onlineVo:OnlineBaseVo = this.getOnline($actid);
         if(Boolean(onlineVo))
         {
            onlineVo.isActive = $state;
            if(!$state)
            {
               onlineVo.isClose = true;
            }
            else
            {
               onlineVo.isClose = false;
            }
            this.update();
         }
      }
      
      public function setOnlineLeng() : void
      {
         var online:OnlineBaseVo = null;
         var len:int = 0;
         for each(online in this.onlines)
         {
            if(online.onlineIntroVo.type == OnlineBaseVo.TIME_STATE)
            {
               if(online.isActive && online.isStart == 1)
               {
                  len++;
               }
            }
            else if(online.isActive && online.timePlus <= 0)
            {
               len++;
            }
         }
         FaceView.clip.bottomClip.setOnlineNumTxt(len);
         FaceView.clip.bottomClip.setNewsclipState(this.searchIsJump());
      }
      
      public function setTimePlus($actId:int, $timePlus:int = 0) : void
      {
         this.setPlayState($actId,true);
         var onlineVo:OnlineBaseVo = this.getOnline($actId);
         if(Boolean(onlineVo))
         {
            onlineVo.timePlus = $timePlus;
            this.update();
         }
      }
      
      public function setPlayTimes($actId:int, $count:int = -1) : void
      {
         var onlineVo:OnlineBaseVo = this.getOnline($actId);
         if(Boolean(onlineVo))
         {
            onlineVo.playTime = $count;
            this.update();
         }
      }
      
      public function setPlayState($actId:int, $state:Boolean) : void
      {
         var onlineVo:OnlineBaseVo = this.getOnline($actId);
         if(Boolean(onlineVo))
         {
            onlineVo.isActive = $state;
            if(!$state)
            {
               onlineVo.isClose = true;
            }
            else
            {
               onlineVo.isClose = false;
            }
            this.update();
         }
      }
      
      public function update() : void
      {
         this.setOnlineLeng();
         dispatchEvent(new MessageEvent(EventConst.S_ONLINE_CHANGE));
      }
      
      public function getOnlines() : Array
      {
         var online:OnlineBaseVo = null;
         var needs:Array = [];
         for each(online in this.onlines)
         {
            if(online.isActive && !online.isClose)
            {
               needs.push(online);
            }
         }
         return needs;
      }
      
      public function addOnlineAsObject($online:OnlineBaseVo) : void
      {
         this.onlines.push($online);
         this.setOnlineLeng();
      }
      
      public function delOnline($id:int) : Boolean
      {
         var list:Array = null;
         var online:OnlineBaseVo = null;
         var state:Boolean = false;
         var index:int = this.indexOf($id);
         if(index != -1)
         {
            list = this.onlines.splice(index,1);
            while(list.length > 0)
            {
               online = this.onlines.shift() as OnlineBaseVo;
               if(Boolean(online))
               {
                  online.disport();
                  online = null;
               }
               state = true;
            }
         }
         return state;
      }
      
      public function hasOnline($id:int) : Boolean
      {
         return this.indexOf($id) != -1;
      }
      
      public function getOnline($id:int) : OnlineBaseVo
      {
         var index:int = this.indexOf($id);
         return index == -1 ? null : this.onlines[index];
      }
      
      public function indexOf($id:int) : int
      {
         var onlineVo:OnlineBaseVo = null;
         var index:int = -1;
         for(var i:int = 0; i < this.onlines.length; i++)
         {
            onlineVo = this.onlines[i];
            if(onlineVo == null)
            {
               this.onlines.splice(i,1);
               i--;
            }
            else if(onlineVo.id == $id)
            {
               index = i;
               break;
            }
         }
         return index;
      }
      
      public function setActivityGoing($actId:int, $state:Boolean) : void
      {
         var online:OnlineBaseVo = null;
         var onlineVo:OnlineBaseVo = this.getOnline($actId);
         if(Boolean(onlineVo))
         {
            for each(online in this.onlines)
            {
               if(online.onlineIntroVo.actid == $actId)
               {
                  online.onlineIntroVo.bOver = $state;
               }
            }
            this.update();
         }
      }
      
      public function searchIsJump() : Boolean
      {
         var onlineVo:OnlineBaseVo = null;
         var showList:Array = this.getOnlines();
         var len:int = int(showList.length);
         for(var i:int = 0; i < len; i++)
         {
            onlineVo = showList[i];
            if(onlineVo.onlineIntroVo.jump == 1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function disport() : void
      {
         var onlineVo:OnlineBaseVo = null;
         this.setOnlineLeng();
         if(Boolean(this.onlines))
         {
            while(Boolean(this.onlines.length))
            {
               onlineVo = this.onlines.shift() as OnlineBaseVo;
               onlineVo.disport();
               onlineVo = null;
            }
            this.onlines = null;
         }
      }
   }
}

