package com.game.modules.control.menology
{
   import com.core.observer.MessageEvent;
   import com.core.view.ViewConLogic;
   import com.game.event.EventConst;
   import com.game.locators.MsgDoc;
   import com.game.modules.view.menology.MenologyEvent;
   import com.game.modules.view.menology.MenologyView;
   import com.publiccomponent.alert.Alert;
   
   public class MenologyControl extends ViewConLogic
   {
      
      public static const NAME:String = "menologycontrol";
      
      public function MenologyControl(viewComponent:Object = null)
      {
         super(NAME,viewComponent);
         this.addViewEvents();
         this.onaddtostage();
      }
      
      override public function listEvents() : Array
      {
         return [[EventConst.MENOLOGYVIEWDATA,this.onDataback],[EventConst.MENOLOGYBACK,this.onapplyback]];
      }
      
      private function addViewEvents() : void
      {
         this.view.addEventListener(MenologyEvent.DUIHUAN,this.onDuihuan);
         this.view.addEventListener(MenologyEvent.ZHANBU,this.onZhanbu);
         this.view.addEventListener(MenologyEvent.QIANDAO,this.onQiandao);
         this.view.addEventListener(MenologyEvent.ZHANBUJIEGUO,this.onZhanburesult);
         this.view.addEventListener(MenologyEvent.CHECKTIME,this.onChecktime);
      }
      
      private function onaddtostage() : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_MENOLOGY.send,5);
         this.sendMessage(MsgDoc.OP_CLIENT_GET_SINGLE_TASK_INFO.send,6010008);
      }
      
      private function onDataback(evt:MessageEvent) : void
      {
         var value1:int = 0;
         var value2:int = 0;
         var value3:int = 0;
         var value4:int = 0;
         var value5:int = 0;
         var value6:int = 0;
         var value7:int = 0;
         var arr:Array = evt.body.list;
         var len:int = int(arr.length);
         var duihuanshow:Array = [];
         for(var i:int = 0; i < len; i++)
         {
            if(arr[i].key == 1)
            {
               value1 = int(arr[i].value);
            }
            else if(arr[i].key == 2)
            {
               value2 = int(arr[i].value);
            }
            else if(arr[i].key == 3)
            {
               value3 = int(arr[i].value);
            }
            else if(arr[i].key == 4)
            {
               value4 = int(arr[i].value);
            }
            else if(arr[i].key == 5)
            {
               value5 = int(arr[i].value);
            }
            else if(arr[i].key == 6)
            {
               value6 = int(arr[i].value);
            }
            else if(arr[i].key == 7)
            {
               value7 = int(arr[i].value);
               if(value7 == 0)
               {
                  this.view.time = 1800 - value7;
               }
               else
               {
                  this.view.time = value7;
               }
            }
         }
         if((value1 & 8) == 8)
         {
            duihuanshow.push(4);
         }
         if((value1 & 4) == 4)
         {
            duihuanshow.push(3);
         }
         if((value1 & 2) == 2)
         {
            duihuanshow.push(2);
         }
         if((value1 & 1) == 1)
         {
            duihuanshow.push(1);
         }
         this.view.initJifen(value2);
         this.view.initDuihuan(null);
         this.view.initDuihuan(duihuanshow);
         this.view.initQiandao(value5);
         this.view.getzhanbu = value6;
         if(value3 == 0 || value3 > 0 && value4 == 0)
         {
            this.view.initZhanbu(0);
            return;
         }
         if(value3 > 0 && value4 > 0)
         {
            this.view.present = value4;
            this.view.initTime(value7);
            return;
         }
      }
      
      private function onQiandao(evt:MenologyEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_MENOLOGY.send,1,[0]);
      }
      
      private function onDuihuan(evt:MenologyEvent) : void
      {
         var flag:int = int(evt.params);
         this.sendMessage(MsgDoc.OP_CLIENT_MENOLOGY.send,2,[flag]);
      }
      
      private function onZhanbu(evt:MenologyEvent) : void
      {
         this.sendMessage(MsgDoc.OP_CLIENT_MENOLOGY.send,3,[0]);
         this.sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,10000,[2]);
      }
      
      private function onZhanburesult(evt:MenologyEvent) : void
      {
         var flag:int = int(evt.params);
         this.sendMessage(MsgDoc.OP_CLIENT_MENOLOGY.send,4,[flag]);
         this.sendMessage(MsgDoc.OP_CLIENT_ACTIVITY_QINGYANG.send,10000,[2]);
      }
      
      private function onChecktime(evt:MenologyEvent) : void
      {
         this.onaddtostage();
      }
      
      private function onapplyback(evt:MessageEvent) : void
      {
         var result:int = 0;
         var level:int = 0;
         var flag2:int = 0;
         var istime:int = 0;
         var present:int = 0;
         var result4:int = 0;
         var present4:int = 0;
         var flag:int = int(evt.body.params);
         switch(flag)
         {
            case 1:
               result = int(evt.body.result);
               if(result == -1)
               {
                  new Alert().showOne("已经签到过了哦!");
               }
               if(result == 1)
               {
                  new Alert().showOne("签到成功,获得10积分!");
                  this.view.score += 10;
                  this.view.initJifen(-1);
                  this.view.initQiandao(1);
                  this.view.initDuihuan(null);
               }
               break;
            case 2:
               level = int(evt.body.level);
               flag2 = int(evt.body.flag);
               if(flag2 == 1)
               {
                  this.view.showpresent(level);
                  this.view.initDuihuan(null);
               }
               if(flag2 == -1)
               {
                  new Alert().showOne("已经领过该奖励哦!");
               }
               if(flag2 == -2)
               {
                  new Alert().showOne("积分不够哦!");
               }
               break;
            case 3:
               istime = int(evt.body.istime);
               present = int(evt.body.present);
               this.view.present = present;
               if(istime == 1)
               {
                  this.view.initTime(this.view.time);
                  this.view.getgray();
               }
               else
               {
                  new Alert().showOne("还没到时间哦!");
               }
               break;
            case 4:
               result4 = int(evt.body.result);
               present4 = int(evt.body.present);
               this.view.initZhanbuback(result4,present4);
         }
      }
      
      private function get view() : MenologyView
      {
         return this.getViewComponent() as MenologyView;
      }
   }
}

