package com.game.modules.view.magic
{
   import com.game.global.GlobalConfig;
   import com.game.locators.GameData;
   import com.game.locators.MsgDoc;
   import com.game.modules.action.MouseEnableView;
   import com.game.modules.action.SwfAction;
   import com.game.modules.action.SwfRotationAction;
   import com.game.modules.control.MapControl;
   import com.game.modules.view.FaceView;
   import com.game.modules.view.MapView;
   import com.game.modules.view.person.GamePerson;
   import com.game.util.GameAction;
   import com.game.util.GamePersonControl;
   import com.game.util.MagicSprite;
   import com.publiccomponent.URLUtil;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   
   public class MagicSendManager
   {
      
      public static const offsetArr:Array = [{
         "id":103,
         "xoffset":30,
         "yoffset":0
      }];
      
      private var view:MapView;
      
      private var control:MapControl;
      
      private var params:Object;
      
      private const newLocationIdArr:Array = [15,16,20];
      
      private const magicStatusArr:Array = [14,26,29];
      
      public function MagicSendManager()
      {
         super();
      }
      
      public function sendActionBack(view:MapView, control:MapControl, params:Object) : void
      {
         var role:GamePerson = null;
         this.view = view;
         this.control = control;
         this.params = params;
         if(params.actionid >= 100)
         {
            if(Boolean(params.hasOwnProperty("destid")) && params.destid != 0)
            {
               role = view.findGameSprite(params.destid) as GamePerson;
            }
            if(Boolean(role))
            {
               role.actionRemove();
               new SwfAction().loadAndPlay(Sprite(role.ui),"assets/material/actionswf/bianshen" + params.actionid + ".swf",role.bottomX - 42,role.bottomY - 97);
               role.showData.isInChange = 1;
               role.showData.bodyID = params.actionid;
               role.showData.horseID = 0;
               if(params.destid == GlobalConfig.userId)
               {
                  MouseEnableView.instance.load(FaceView.clip,30,380,"assets/material/actionswf/big" + params.actionid + ".swf","你被变身啦,点击这里取消变身状态",this.cancelChangeBody);
                  GameData.instance.playerData.isInChange = 1;
                  GameData.instance.playerData.bodyID = params.actionid;
                  GameData.instance.playerData.horseID = 0;
                  control.sendMessage(MsgDoc.OP_CLIENT_HORSE_USE.send,2);
               }
               if(params.actionid == 102)
               {
                  params.targetRole = role;
                  this.playAction(params,this.changeBody);
                  return;
               }
               role.changeBody(params.actionid,null);
            }
         }
         else
         {
            params.url = "action" + params.actionid + ".swf";
            switch(params.actionid)
            {
               case 6:
                  this.playAction(params,this.complementHandler);
                  break;
               case 7:
               case 8:
               case 9:
               case 10:
               case 11:
               case 12:
               case 15:
                  this.playAction(params,this.showMagic);
                  break;
               case 14:
               case 26:
               case 29:
                  role = view.findGameSprite(params.destid) as GamePerson;
                  if(Boolean(role))
                  {
                     role.showData.horseID = 0;
                     role.stop();
                     if(params.destid == GlobalConfig.userId)
                     {
                        GameData.instance.playerData.horseID = 0;
                        GameData.instance.playerData.magicStatus = params.actionid;
                        control.sendMessage(MsgDoc.OP_CLIENT_HORSE_USE.send,2);
                     }
                     this.playAction(params,this.showMagic);
                  }
                  break;
               case 16:
                  if(GamePersonControl.instance.isInSpecialSceneList())
                  {
                     params.url = "action" + params.actionid + "_2.swf";
                  }
                  else
                  {
                     params.url = "action" + params.actionid + ".swf";
                  }
                  this.playAction(params,this.showMagic);
                  break;
               case 17:
                  params.url2 = "action" + params.actionid + "_user.swf";
                  params.url = "action" + params.actionid + "_dest.swf";
                  this.showMagicForTwo(params);
                  break;
               case 19:
                  params.url2 = "action" + params.actionid + "_user.swf";
                  params.url = "action" + params.actionid + "_dest.swf";
                  this.playAction(params,this.showMagicForTwo);
                  break;
               case 20:
                  this.showMagic(params);
                  break;
               case 21:
                  this.playAction(params,this.complemenPaozhutHandler);
                  break;
               case 13:
                  params.headurl = "action" + params.actionid + "head.swf";
                  params.destx = 400;
                  params.desty = 100;
                  if(GameData.instance.playerData.playswfStatus == true)
                  {
                     return;
                  }
                  this.showQuanPingMagic(params);
                  break;
               case 30:
               case 22:
               case 23:
               case 24:
                  params.destx = 0;
                  params.desty = 0;
                  if(GameData.instance.playerData.playswfStatus == true)
                  {
                     return;
                  }
                  this.showJinSheQuanPingMagic(params);
                  break;
               case 25:
                  break;
               default:
                  this.playAction(params);
            }
         }
      }
      
      private function changeBody(params:Object) : void
      {
         var role:GamePerson = params.targetRole;
         role.changeBody(params.actionid,null);
      }
      
      private function cancelChangeBody() : void
      {
         this.control.sendMessage(MsgDoc.OP_CLIENT_SEND_ACTION.send,0,[GlobalConfig.userId,0,0,0,1,0]);
      }
      
      private function playAction(params:Object, complement:Function = null) : void
      {
         var point:Point = null;
         var destPoint:Point = null;
         var role:GamePerson = this.view.findGameSprite(params.userid) as GamePerson;
         if(role != null && role.ui.parent != null)
         {
            point = role.ui.parent.localToGlobal(new Point(role.x,role.y - 50));
            destPoint = role.ui.parent.localToGlobal(new Point(params.destx,params.desty));
            GameAction.instance.play(MagicSprite.instance,point.x,point.y,destPoint.x,destPoint.y,params.actionid,params.userid,complement,params);
            role.beforeGo(params.destx,params.desty);
            role.playAction();
         }
      }
      
      private function complemenPaozhutHandler(params:Object) : void
      {
         var url:String = "assets/material/actionswf/" + params.url;
         url = URLUtil.getSvnVer(url);
         var destPoint:Point = this.view.masterPerson.ui.parent.localToGlobal(new Point(params.destx - 20,params.desty));
         new SwfAction().loadAndPlay(this.view,url,destPoint.x,destPoint.y);
      }
      
      private function complementHandler(params:Object) : void
      {
         var role:GamePerson = this.view.findGameSprite(params.destid) as GamePerson;
         if(Boolean(role) && Boolean(role.roleFace))
         {
            role.roleFace.removeMouseHandler();
            role.roleFace.filters = [new ColorMatrixFilter([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.5,0.5,0.5,0.5,0])];
         }
         var destPoint:Point = this.view.masterPerson.ui.parent.localToGlobal(new Point(params.destx - 20,params.desty));
         new SwfAction().loadAndPlay(this.view,"assets/material/magic5.swf",destPoint.x,destPoint.y,this.yanhuoOk,params);
      }
      
      private function yanhuoOk(params:Object) : void
      {
         var role:GamePerson = this.view.findGameSprite(params.destid) as GamePerson;
         if(Boolean(role) && Boolean(role.roleFace))
         {
            role.roleFace.filters = [];
            role.roleFace.addMouseHandler();
         }
      }
      
      private function isActionStatusOver(params:Object) : void
      {
         GameData.instance.playerData.magicStatus = 0;
      }
      
      private function showMagic(noObj:Object) : void
      {
         var completeFunc:Function = null;
         var destPoint:Point = null;
         var url:String = "assets/material/actionswf/" + this.params.url;
         url = URLUtil.getSvnVer(url);
         var role:GamePerson = this.view.findGameSprite(this.params.destid) as GamePerson;
         if(Boolean(role))
         {
            if(this.magicStatusArr.indexOf(this.params.actionid) >= 0)
            {
               if(this.params.destid == GlobalConfig.userId)
               {
                  completeFunc = this.isActionStatusOver;
                  new SwfAction(this.onLoadOver).loadAndPlay(Sprite(role.ui),url,-75,-106,completeFunc,this.params);
               }
               else
               {
                  new SwfAction(this.onLoadOver).loadAndPlay(Sprite(role.ui),url,-75,-106);
               }
            }
            if(role.showData.isInChange == 1 && this.magicStatusArr.indexOf(this.params.actionid) < 0 && this.newLocationIdArr.indexOf(this.params.actionid) == -1 && this.params.actionid != 17)
            {
               new SwfAction().loadAndPlay(Sprite(role.ui),url,-30,-80);
            }
            else if(role.showData.isInChange != 1 && this.magicStatusArr.indexOf(this.params.actionid) < 0 && this.newLocationIdArr.indexOf(this.params.actionid) == -1 && this.params.actionid != 17)
            {
               new SwfAction().loadAndPlay(Sprite(role.ui),url,-50,-70);
            }
            if(this.newLocationIdArr.indexOf(this.params.actionid) != -1)
            {
               new SwfAction().loadAndPlay(Sprite(role.ui),url,role.bottomX,role.bottomY);
            }
            if(this.params.actionid == 17)
            {
               new SwfAction().loadAndPlay(Sprite(role.ui),url,role.bottomX,role.bottomY,this.yanhuoOk,noObj,this.leijishuAction,31);
            }
         }
         else
         {
            destPoint = this.view.masterPerson.ui.parent.localToGlobal(new Point(this.params.destx - 20,this.params.desty));
            new SwfAction().loadAndPlay(this.view,url,destPoint.x,destPoint.y);
         }
      }
      
      private function onLoadOver() : void
      {
         var url1:String = null;
         var role:GamePerson = null;
         var roleMy:GamePerson = null;
         var point:Point = null;
         var destPoint1:Point = null;
         var q:Number = NaN;
         if(this.params.actionid == 29)
         {
            role = this.view.findGameSprite(this.params.destid) as GamePerson;
            roleMy = this.view.findGameSprite(GlobalConfig.userId) as GamePerson;
            point = role.ui.parent.localToGlobal(new Point(roleMy.x,roleMy.y - 35));
            destPoint1 = role.ui.parent.localToGlobal(new Point(role.x,role.y - 35));
            q = Math.atan2(destPoint1.y - point.y,destPoint1.x - point.x);
            if(q < 0)
            {
               q = q + 2 * Math.PI;
            }
            url1 = URLUtil.getSvnVer("assets/material/actionswf/action" + this.params.actionid + "_1" + ".swf");
            new SwfRotationAction().loadAndPlay(Sprite(role.ui),url1,0,-35,q * 180 / Math.PI,null,this.params);
         }
      }
      
      private function leijishuAction(params:Object) : void
      {
         var role:GamePerson = this.view.findGameSprite(params.destid) as GamePerson;
         if(Boolean(role))
         {
            role.roleFace.removeMouseHandler();
            role.roleFace.filters = [new ColorMatrixFilter([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.5,0.5,0.5,0.5,0])];
         }
      }
      
      private function showMagicForTwo(params:Object) : void
      {
         var userUrl:String = "assets/material/actionswf/" + params.url2;
         userUrl = URLUtil.getSvnVer(userUrl);
         var userRole:GamePerson = this.view.findGameSprite(params.userid) as GamePerson;
         if(Boolean(userRole))
         {
            if(userRole.showData.isInChange == 1)
            {
               new SwfAction().loadAndPlay(Sprite(userRole.ui),userUrl,userRole.bottomX,userRole.bottomY,this.showMagic,params);
            }
            else if(userRole.showData.isInChange != 1)
            {
               new SwfAction().loadAndPlay(Sprite(userRole.ui),userUrl,userRole.bottomX,userRole.bottomY,this.showMagic,params);
            }
         }
      }
      
      private function showJinSheQuanPingMagic(params:Object) : void
      {
         var url:String = "assets/material/actionswf/" + params.url;
         url = URLUtil.getSvnVer(url);
         new SwfAction().loadAndPlay(this.view,url,params.destx - 20,params.desty);
      }
      
      private function showQuanPingMagic(params:Object) : void
      {
         var url:String = "assets/material/actionswf/" + params.url;
         var headurl:String = "assets/material/actionswf/" + params.headurl;
         url = URLUtil.getSvnVer(url);
         headurl = URLUtil.getSvnVer(headurl);
         var role:GamePerson = this.view.findGameSprite(params.userid) as GamePerson;
         if(Boolean(role))
         {
            if(role.showData.isInChange == 1)
            {
               new SwfAction().loadAndPlay(Sprite(role.ui),headurl,-role.ui.width / 2 + 55,-role.ui.height + 70);
            }
            else
            {
               new SwfAction().loadAndPlay(Sprite(role.ui),headurl,-role.ui.width / 2 + 50,-role.ui.height + 70);
            }
         }
         new SwfAction().loadAndPlay(this.view,url,params.destx - 20,params.desty);
      }
   }
}

