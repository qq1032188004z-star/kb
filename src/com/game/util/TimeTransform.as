package com.game.util
{
   import com.game.locators.GameData;
   
   public class TimeTransform
   {
      
      public static var timeTrans:TimeTransform;
      
      public var date:Date;
      
      public function TimeTransform()
      {
         super();
         if(timeTrans != null)
         {
            throw new Error("单例类只能被实例化一次");
         }
      }
      
      public static function getInstance() : TimeTransform
      {
         if(timeTrans == null)
         {
            timeTrans = new TimeTransform();
         }
         return timeTrans;
      }
      
      public function transDate(num:Number, middle:String = "/") : String
      {
         this.date = new Date(num * 1000);
         return this.date.fullYear + middle + (this.date.month + 1) + middle + this.date.date;
      }
      
      public function transDateAll(num:Number) : String
      {
         var hour:String = null;
         this.date = new Date(num * 1000);
         return this.date.fullYear + "/" + this.setTimeForm(this.date.month + 1) + "/" + this.setTimeForm(this.date.date) + "  " + this.setTimeForm(this.date.hours) + ":" + this.setTimeForm(this.date.minutes) + ":" + this.setTimeForm(this.date.seconds);
      }
      
      public function transTime() : String
      {
         this.date = new Date();
         return this.date.hours + ":" + this.date.minutes + ":" + this.date.seconds;
      }
      
      public function transDateAsChinese(num:Number) : String
      {
         var month:int = 0;
         var days:int = 0;
         var years:int = 0;
         var timeStr:String = "0";
         if(num < 3600 * 24)
         {
            timeStr = num / 3600 + "";
            timeStr = timeStr.slice(0,4) + "小时";
         }
         else if(num < 3600 * 24 * 30)
         {
            timeStr = int(num / (3600 * 24)) + "天";
         }
         else if(num < 3600 * 24 * 30 * 12)
         {
            month = int(num / (3600 * 24 * 30));
            days = int(num % (3600 * 24 * 30));
            days = int(days / (3600 * 24));
            timeStr = month + "月" + days + "天";
         }
         else
         {
            years = int(num / (3600 * 24 * 30 * 12));
            month = int(num % (3600 * 24 * 30 * 12));
            month = int(month / (3600 * 24 * 30));
            timeStr = years + "年" + month + "月";
         }
         return timeStr;
      }
      
      public function transToTime_email(num:Number) : String
      {
         this.date = new Date(num * 1000);
         var str:String = "" + this.date.hours;
         if(this.date.minutes < 10)
         {
            str += ":0" + this.date.minutes;
         }
         else
         {
            str += ":" + this.date.minutes;
         }
         if(this.date.seconds < 10)
         {
            str += ":0" + this.date.seconds;
         }
         else
         {
            str += ":" + this.date.seconds;
         }
         return str;
      }
      
      public function transToTime(num:Number, state:int = 0) : String
      {
         var residue:Number = NaN;
         var str:String = "";
         var day:int = num / (3600 * 24);
         residue = num % (3600 * 24);
         var hour:int = residue / 3600;
         residue = Number(residue / 3600) - hour;
         var minute:int = residue * 60;
         var seconds:int = num % 3600 % 60;
         if(state == 0)
         {
            str = "" + hour + ":" + minute + ":" + seconds;
         }
         else if(day > 0)
         {
            str = day + "天" + hour + "时" + minute + "分" + seconds + "秒";
         }
         else
         {
            str = "" + hour + "时" + minute + "分" + seconds + "秒";
         }
         return str;
      }
      
      public function transToDHM(num:Number) : String
      {
         var residue:Number = NaN;
         var str:String = "";
         var day:int = num / (3600 * 24);
         residue = num % (3600 * 24);
         var hour:int = residue / 3600;
         residue = Number(residue / 3600) - hour;
         var minute:int = residue * 60;
         return day + "天" + hour + "小时" + minute + "分";
      }
      
      public function isPathTime(lastTime:int, year:int, month:int, day:int) : Boolean
      {
         var currentMonth:int = 0;
         var date:Date = GameData.instance.playerData.getDate();
         if(GameData.instance.playerData.vipLevel > 0)
         {
            date.setTime(lastTime * 1000);
         }
         var state:Boolean = false;
         if(date.getFullYear() > year)
         {
            state = true;
         }
         else if(date.getUTCFullYear() == year)
         {
            currentMonth = date.getMonth() + 1;
            if(currentMonth > month)
            {
               state = true;
            }
            else if(currentMonth == month)
            {
               if(date.getDate() > day || date.getDate() == day)
               {
                  state = true;
               }
            }
         }
         return state;
      }
      
      public function passTime(year:int, month:int, day:int) : Boolean
      {
         var currentMonth:int = 0;
         var date:Date = GameData.instance.playerData.getDate();
         var state:Boolean = false;
         if(date.getFullYear() > year)
         {
            state = true;
         }
         else if(date.getUTCFullYear() == year)
         {
            currentMonth = date.getMonth() + 1;
            if(currentMonth > month)
            {
               state = true;
            }
            else if(currentMonth == month)
            {
               if(date.getDate() > day || date.getDate() == day)
               {
                  state = true;
               }
            }
         }
         return state;
      }
      
      private function setTimeForm(num:Number) : String
      {
         if(num < 10)
         {
            return "0" + num;
         }
         return num + "";
      }
   }
}

