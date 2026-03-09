package com.game.modules.vo.list
{
   import com.game.modules.vo.messageBox.OnlineIntoVo;
   import com.game.util.PropertyPool;
   
   public class OnlineIntroList
   {
      
      private var introLists:Array = [];
      
      private var loadState:Boolean = false;
      
      private var responseOnline:Function;
      
      public function OnlineIntroList($init:Function)
      {
         super();
         this.loadState = false;
         PropertyPool.instance.getXML("config/","online",this.build);
         this.responseOnline = $init;
      }
      
      public function getIntroLists() : Array
      {
         return this.introLists;
      }
      
      private function build($xml:XML) : void
      {
         var node:XML = null;
         var onlineVo:OnlineIntoVo = null;
         if($xml != null)
         {
            for each(node in $xml.children())
            {
               onlineVo = new OnlineIntoVo();
               onlineVo.id = node.@id;
               onlineVo.actid = node.actid;
               onlineVo.actName = node.actName;
               onlineVo.sDate = node.sDate;
               onlineVo.eDate = node.eDate;
               onlineVo.type = node.type;
               onlineVo.setGameTime(String(node.time));
               onlineVo.actType = node.actType;
               onlineVo.priority = node.priority;
               onlineVo.timePlus = node.timeplus;
               onlineVo.content = node.content;
               onlineVo.showgo = node.showgo;
               onlineVo.delgo = node.delgo;
               onlineVo.showgoing = node.showgoing;
               onlineVo.showdec = node.showdec;
               onlineVo.jump = node.jump;
               this.introLists.push(onlineVo);
            }
            this.introLists.sortOn(["priority","actid"],Array.NUMERIC | Array.DESCENDING);
            this.loadState = true;
         }
         this.responseLoadTrue();
      }
      
      private function responseLoadTrue() : void
      {
         if(this.responseOnline != null)
         {
            this.responseOnline.apply();
            this.responseOnline = null;
         }
      }
      
      public function getOnlineIntroByID($id:int) : OnlineIntoVo
      {
         var index:int = this.indexOf($id);
         return index == -1 ? null : this.introLists[index];
      }
      
      public function indexOf($id:int) : int
      {
         var index:int = -1;
         for(var i:int = 0; i < this.introLists.length; i++)
         {
            if(this.introLists[i].actid == $id)
            {
               index = i;
               break;
            }
         }
         return index;
      }
      
      public function disport() : void
      {
         var onlineVo:OnlineIntoVo = null;
         while(this.introLists.length > 0)
         {
            onlineVo = this.introLists.shift();
            onlineVo = null;
         }
         this.introLists = null;
      }
   }
}

