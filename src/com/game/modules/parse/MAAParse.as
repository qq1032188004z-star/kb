package com.game.modules.parse
{
   import com.game.util.ChatUtil;
   import com.game.util.HtmlUtil;
   import com.publiccomponent.alert.Alert;
   import org.green.server.data.MsgPacket;
   import org.green.server.interfaces.IParser;
   import phpcon.PhpConnection;
   
   public class MAAParse implements IParser
   {
      
      public static var PersonInfoList:Array = [];
      
      public function MAAParse()
      {
         super();
      }
      
      public function parse(msg:MsgPacket) : void
      {
         var time:int = 0;
         var pname:String = null;
         var id:int = msg.body.readInt();
         var flag:int = msg.body.readInt();
         var personInfo:Object = PersonInfoList.shift();
         var name:String = "";
         if(personInfo != null)
         {
            name = personInfo.userName;
            PhpConnection.instance().insertMAAMessage(name,102);
         }
         if(flag == -6)
         {
            time = msg.body.readInt();
            new Alert().showOne("对不起，你现在处于拜师冻结期，" + this.getTimeStr(time) + "后再来拜师吧。");
         }
         else if(flag == -3)
         {
            new Alert().showOne("对不起，对方不在线，无法发送拜师或收徒请求");
         }
         else if(flag == -1)
         {
            new Alert().showOne("对方指导的徒弟已经满额，暂时不能再收徒哦");
         }
         else if(flag == 0)
         {
            new Alert().showOne("很遗憾，【" + ChatUtil.onCheckStr(name) + "】拒绝了你的请求");
            PhpConnection.instance().insertMAAMessage(name,103);
         }
         else if(flag == 1)
         {
            new Alert().showOne("【" + ChatUtil.onCheckStr(name) + "】同意了你的请求，成为你的师父，如果在游戏中遇到困难，记得找你的师父帮忙哦");
            PhpConnection.instance().insertMAAMessage(name,105);
         }
         else if(flag == 2)
         {
            pname = PhpConnection.instance().messageList.shift() as String;
            if(pname == null)
            {
               pname = "";
            }
            new Alert().showOne("【" + ChatUtil.onCheckStr(pname) + "】已经成为你的徒弟，记得要对其多多指导哦~");
            PhpConnection.instance().insertMAAMessage(pname,106);
         }
         else if(flag == -7)
         {
            new Alert().showOne("对不起，只有好友才能建立师徒关系，你的好友名单已经满了哦~");
         }
         else if(flag == -5)
         {
            new Alert().showOne("你已经有众多师父指导，不需要再拜其他人为师了");
         }
         else if(flag == -8)
         {
            new Alert().showOne("对不起，对方现在处于收徒冻结期。");
         }
         else if(flag == -9)
         {
            new Alert().showOne("对不起，只有好友才能建立师徒关系，对方的好友名单已经满了哦~");
         }
         else if(flag == -10)
         {
            new Alert().showOne("对不起，对方已经是你的师傅了哦~");
         }
         else if(flag == -11)
         {
            new Alert().showOne("对不起，对方已经是你的徒弟了哦~");
         }
         else if(flag == -12)
         {
            new Alert().showOne("已有师徒申请中，请耐心等待佳音~");
         }
         else if(flag == -13)
         {
            new Alert().showOne("已有师徒申请中，请耐心等待佳音~");
         }
      }
      
      public function parse1(msg:MsgPacket) : Object
      {
         var params:Object = {};
         params.id = msg.body.readInt();
         params.name = msg.body.readUTF();
         params.mParams = msg.mParams;
         var str:String = "";
         var linkMsg:String = "";
         if(msg.mParams == 3)
         {
            linkMsg = HtmlUtil.getHtmlText(15,"#ff0000","【<a href=\"event:\">" + ChatUtil.onCheckStr(params.name) + "】</a>") + "申请成为你的徒弟，你是否同意？";
            str = "【" + ChatUtil.onCheckStr(params.name) + "】申请成为你的徒弟，你是否同意？";
         }
         else if(msg.mParams == 5)
         {
            linkMsg = HtmlUtil.getHtmlText(15,"#ff0000","【<a href=\"event:\">" + ChatUtil.onCheckStr(params.name) + "】</a>") + "申请成为你的师父，你是否同意？";
            str = "【" + ChatUtil.onCheckStr(params.name) + "】申请成为你的师父，你是否同意？";
         }
         PhpConnection.instance().insertMAAMessage(params.name,101);
         params.msg = str;
         params.linkMsg = linkMsg;
         return params;
      }
      
      public function parse2(msg:MsgPacket) : void
      {
         var time:int = 0;
         var pname:String = null;
         var id:int = msg.body.readInt();
         var flag:int = msg.body.readInt();
         var personInfo:Object = PersonInfoList.shift();
         var name:String = "";
         if(personInfo != null)
         {
            name = personInfo.userName;
            PhpConnection.instance().insertMAAMessage(name,112);
         }
         if(flag == -6)
         {
            new Alert().showOne("对不起，对方现在处于拜师冻结期。");
         }
         else if(flag == -4)
         {
            new Alert().showOne("你能指导的徒弟已经满额，暂时不能再收徒哦");
         }
         else if(flag == -3)
         {
            new Alert().showOne("对不起，对方不在线，无法发送拜师或收徒请求");
         }
         else if(flag == -2)
         {
            new Alert().showOne("对方已经有众多师父指导，不需要再拜其他人为师了");
         }
         else if(flag == 0)
         {
            new Alert().showOne("很遗憾，【" + ChatUtil.onCheckStr(name) + "】拒绝了你的请求");
            PhpConnection.instance().insertMAAMessage(name,113);
         }
         else if(flag == 1)
         {
            new Alert().showOne("【" + ChatUtil.onCheckStr(name) + "】同意了你的请求，成为你的徒弟，记得要对其多多指导哦");
            PhpConnection.instance().insertMAAMessage(name,115);
         }
         else if(flag == 2)
         {
            pname = PhpConnection.instance().messageList.shift() as String;
            if(pname == null)
            {
               pname = "";
            }
            new Alert().showOne("【" + ChatUtil.onCheckStr(pname) + "】已经成为你的师父，如果在游戏中遇到困难，记得找你的师父帮忙哦~");
            PhpConnection.instance().insertMAAMessage(pname,116);
         }
         else if(flag == -7)
         {
            new Alert().showOne("对不起，只有好友才能建立师徒关系，你的好友名单已经满了哦~");
         }
         else if(flag == -8)
         {
            time = msg.body.readInt();
            new Alert().showOne("对不起，你现在处于收徒冻结期，" + this.getTimeStr(time) + "后再来收徒吧。");
         }
         else if(flag == -9)
         {
            new Alert().showOne("对不起，只有好友才能建立师徒关系，对方的好友名单已经满了哦~");
         }
         else if(flag == -10)
         {
            new Alert().showOne("对不起，对方已经是你的师傅了哦~");
         }
         else if(flag == -11)
         {
            new Alert().showOne("对不起，对方已经是你的徒弟了哦~");
         }
         else if(flag == -12)
         {
            new Alert().showOne("已有师徒申请中，请耐心等待佳音~");
         }
         else if(flag == -13)
         {
            new Alert().showOne("已有师徒申请中，请耐心等待佳音~");
         }
      }
      
      private function getTimeStr(num:Number) : String
      {
         var str:String = null;
         var minutes:int = num / 60;
         var hour:int = minutes / 60;
         var day:int = hour / 24;
         if(day > 0)
         {
            str = day + "天" + int(hour % 24) + "小时";
         }
         else if(hour > 0)
         {
            str = hour + "小时" + int(minutes % 60) + "分钟";
         }
         else if(minutes > 0)
         {
            str = minutes + "分" + int(num % 60) + "秒";
         }
         else
         {
            str = int(num % 60) + "秒";
         }
         return str;
      }
   }
}

