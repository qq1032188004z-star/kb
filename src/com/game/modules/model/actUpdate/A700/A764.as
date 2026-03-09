package com.game.modules.model.actUpdate.A700
{
   import com.game.modules.view.FaceView;
   import com.publiccomponent.ui.ButtonEffect;
   import com.publiccomponent.util.ButtonEffectUtil;
   import org.green.server.events.MsgEvent;
   import org.json.JSON;
   
   public class A764
   {
      
      private static var _ins:A764;
      
      public function A764()
      {
         super();
      }
      
      public static function get ins() : A764
      {
         return _ins = _ins || new A764();
      }
      
      public function onAct764Update(evt:MsgEvent) : void
      {
         var result:int = 0;
         var isHideBtn:Boolean = false;
         var isShowEff:Boolean = false;
         var i:int = 0;
         var strJson:String = null;
         var login_info:Array = null;
         var exchange_info:Array = null;
         if(evt == null)
         {
            return;
         }
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         switch(oper)
         {
            case "login":
               result = evt.msg.body.readInt();
               if(result == 0)
               {
                  evt.msg.body.readInt();
                  evt.msg.body.readInt();
                  isHideBtn = true;
                  isShowEff = false;
                  strJson = evt.msg.body.readUTF();
                  if(strJson != "")
                  {
                     login_info = JSON.decode(strJson) as Array;
                     for(i = 0; i < login_info.length; i++)
                     {
                        if(login_info[i]["award"] != 1)
                        {
                           isHideBtn = false;
                        }
                        if(login_info[i]["login"] == 1 && login_info[i]["award"] != 1)
                        {
                           isShowEff = true;
                        }
                     }
                  }
                  ButtonEffectUtil.delEffect(FaceView.clip.getTopButton("freshManAwardBtn"));
                  if(isShowEff)
                  {
                     ButtonEffectUtil.registerEffect(FaceView.clip.getTopButton("freshManAwardBtn"),ButtonEffect.EFFECT_AWARD1,false);
                  }
                  strJson = evt.msg.body.readUTF();
                  if(strJson != "")
                  {
                     exchange_info = JSON.decode(strJson) as Array;
                     for(i = 0; i < exchange_info.length; i++)
                     {
                        if(exchange_info[i]["num"] < exchange_info[i]["max"])
                        {
                           isHideBtn = false;
                        }
                     }
                  }
                  if(strJson == "")
                  {
                     isHideBtn = false;
                  }
               }
               if(isHideBtn)
               {
                  FaceView.clip.topClip.hideBtnByName("freshManAwardBtn");
               }
         }
      }
   }
}

