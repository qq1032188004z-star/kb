package com.game.modules.model.actUpdate.A600
{
   import com.game.locators.GameData;
   import com.game.modules.view.FaceView;
   import org.green.server.events.MsgEvent;
   
   public class A632
   {
      
      private static var _ins:A632;
      
      private var _shop632Dic:Object;
      
      public function A632()
      {
         super();
      }
      
      public static function get ins() : A632
      {
         return _ins = _ins || new A632();
      }
      
      public function onAct632Update(evt:MsgEvent) : void
      {
         var params:Object = null;
         var typeLen:int = 0;
         var shopList:Array = null;
         var i:int = 0;
         var shopType:int = 0;
         var shopLen:int = 0;
         var list:Array = null;
         var j:int = 0;
         var limit:int = 0;
         var price:int = 0;
         var maxLimit:int = 0;
         var goodInfoLen:int = 0;
         var goodInfoList:Array = null;
         var k:int = 0;
         var goodInfoObj:Object = null;
         var templist:Array = null;
         var goodInfo:Object = null;
         if(evt == null)
         {
            return;
         }
         evt.msg.body.position = 0;
         var oper:String = evt.msg.body.readUTF();
         var code:int = 0;
         var sex:int = GameData.instance.playerData.sex;
         switch(oper)
         {
            case "ui_info":
               params = {};
               typeLen = evt.msg.body.readInt();
               shopList = [];
               for(i = 0; i < typeLen; i++)
               {
                  shopType = evt.msg.body.readInt();
                  shopLen = evt.msg.body.readInt();
                  list = [];
                  for(j = 0; j < shopLen; j++)
                  {
                     limit = evt.msg.body.readInt();
                     price = evt.msg.body.readInt();
                     maxLimit = evt.msg.body.readInt();
                     goodInfoLen = evt.msg.body.readInt();
                     goodInfoList = [];
                     for(k = 0; k < goodInfoLen; k++)
                     {
                        goodInfoList.push([evt.msg.body.readInt(),evt.msg.body.readInt(),evt.msg.body.readInt()]);
                     }
                     goodInfoObj = {
                        "limit":limit,
                        "price":price,
                        "maxLimit":maxLimit,
                        "goodList":goodInfoList
                     };
                     if(int(shopType) == 3)
                     {
                        if(sex == 1 && j % 2 == 0)
                        {
                           list.push(goodInfoObj);
                        }
                        else if(sex == 0 && j % 2 == 1)
                        {
                           list.push(goodInfoObj);
                        }
                     }
                     else
                     {
                        list.push(goodInfoObj);
                     }
                  }
                  params[shopType] = list;
                  shopList = shopList.concat(list);
               }
               this._shop632Dic = params;
               this.check632Over();
               break;
            case "buy_item":
               params = {};
               params["error"] = evt.msg.body.readInt();
               if(params["error"] == 0)
               {
                  params["shop_type"] = evt.msg.body.readInt();
                  params["index"] = evt.msg.body.readInt();
                  params["limit"] = evt.msg.body.readInt();
                  params["price"] = evt.msg.body.readInt();
                  params["maxLimit"] = evt.msg.body.readInt();
                  templist = this._shop632Dic[params["shop_type"]] || [];
                  goodInfo = templist[params["index"] - 1];
                  if(!goodInfo)
                  {
                     goodInfo = {
                        "limit":params["limit"],
                        "price":params["price"],
                        "maxLimit":params["maxLimit"]
                     };
                     templist.push(goodInfo);
                  }
                  goodInfo.limit = params["limit"];
                  this._shop632Dic[params["shop_type"]] = templist;
               }
               this.check632Over();
         }
      }
      
      private function check632Over() : void
      {
         var shopList:Array = null;
         var goodList:Array = null;
         var key:String = null;
         var shopData:Object = null;
         var i:int = 0;
         if(!this._shop632Dic)
         {
            return;
         }
         var gameOver:Boolean = true;
         for(key in this._shop632Dic)
         {
            shopList = this._shop632Dic[key];
            for(i = 0; i < shopList.length; i++)
            {
               shopData = shopList[i];
               if(int(key) == 3 || int(key) == 4)
               {
                  if(shopData["limit"] < shopData["maxLimit"])
                  {
                     gameOver = false;
                     break;
                  }
               }
               else
               {
                  goodList = shopData["goodList"];
                  if(!(goodList && goodList[0] && Boolean(goodList[0][2]) && goodList[0][2] == 1))
                  {
                     if(shopData["limit"] < shopData["maxLimit"])
                     {
                        gameOver = false;
                        break;
                     }
                  }
               }
            }
            if(!gameOver)
            {
               break;
            }
         }
         if(gameOver)
         {
            FaceView.clip.topClip.hideBtnByName("preciousPropBtn");
         }
      }
   }
}

