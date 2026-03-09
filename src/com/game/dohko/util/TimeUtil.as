package com.game.dohko.util
{
   public class TimeUtil
   {
      
      public function TimeUtil()
      {
         super();
      }
      
      public static function secondToString(seconds:int) : String
      {
         var min:int = 0;
         var second:int = 0;
         var show:String = null;
         min = seconds / 60;
         second = seconds % 60;
         if(min < 10)
         {
            show = "0" + min + ":";
         }
         else
         {
            show = min + ":";
         }
         if(second < 10)
         {
            show = show + "0" + second;
         }
         else
         {
            show += second;
         }
         return show;
      }
      
      public static function secondToMinute(seconds:int, maxMin:int = 5) : String
      {
         var min:int = 0;
         var second:int = 0;
         min = seconds / 60;
         second = seconds % 60;
         if(second > 0 && min < maxMin)
         {
            min++;
         }
         return min + "";
      }
      
      public static function millisecondToString($value:int) : String
      {
         var min:int = 0;
         var second:int = 0;
         var miliSecond:int = 0;
         var show:String = null;
         min = $value / 60000;
         second = $value % 60000 / 1000;
         miliSecond = $value % 60000 % 1000 / 10;
         if(min < 10)
         {
            show = "0" + min + ":";
         }
         else
         {
            show = min + ":";
         }
         if(second < 10)
         {
            show = show + "0" + second + ":";
         }
         else
         {
            show = show + second + ":";
         }
         if(miliSecond < 10)
         {
            show = show + "0" + miliSecond;
         }
         else
         {
            show += miliSecond;
         }
         return show;
      }
      
      public static function getFormatDate(date:Date, separator:String = "-") : String
      {
         return format(date.fullYear) + separator + format(date.month + 1) + separator + format(date.date);
      }
      
      public static function getFormatDateByTimestamp(timestamp:int, separator:String = "-") : String
      {
         var date:Date = new Date(timestamp * 1000);
         return getFormatDate(date,separator);
      }
      
      public static function getFormatTime(date:Date, separator:String = ":") : String
      {
         return format(date.hours) + separator + format(date.minutes) + separator + format(date.seconds);
      }
      
      public static function getFormatTimeByTimestamp(timestamp:int, separator:String = ":") : String
      {
         var date:Date = new Date(timestamp * 1000);
         return getFormatTime(date,separator);
      }
      
      public static function format(num:Number) : String
      {
         var temp:String = num.toString();
         if(temp.length == 1)
         {
            temp = "0" + temp;
         }
         return temp;
      }
      
      public static function getMinute($timeStr:String, $separator:String = ":") : int
      {
         if($timeStr == null || $timeStr.length == 0)
         {
            return -1;
         }
         var arr:Array = $timeStr.split($separator);
         if(arr == null || arr.length != 2)
         {
            return -1;
         }
         if(!isNumberStr(arr[0]))
         {
            return -1;
         }
         if(!isNumberStr(arr[1]))
         {
            return -1;
         }
         var hour:int = parseInt(arr[0]);
         var min:int = parseInt(arr[1]);
         if(hour < 0 || hour > 23)
         {
            return -1;
         }
         if(min < 0 || hour > 59)
         {
            return -1;
         }
         return hour * 60 + min;
      }
      
      public static function getSec($timeStr:String, $separator:String = ":") : int
      {
         if($timeStr == null || $timeStr.length == 0)
         {
            return -1;
         }
         var arr:Array = $timeStr.split($separator);
         if(arr == null || arr.length != 2)
         {
            return -1;
         }
         if(!isNumberStr(arr[0]))
         {
            return -1;
         }
         if(!isNumberStr(arr[1]))
         {
            return -1;
         }
         var hour:int = parseInt(arr[0]);
         var min:int = parseInt(arr[1]);
         if(hour < 0 || hour > 23)
         {
            return -1;
         }
         if(min < 0 || hour > 59)
         {
            return -1;
         }
         return hour * 3600 + min * 60;
      }
      
      public static function checkIsTimeFormatHM($timeStr:String, separator:String = ":") : Boolean
      {
         return getMinute($timeStr,separator) != -1;
      }
      
      public static function isNumberStr($numStr:String) : Boolean
      {
         var code:int = 0;
         if($numStr == null && $numStr.length <= 0)
         {
            return false;
         }
         for(var i:int = 0; i < $numStr.length; i++)
         {
            code = int($numStr.charCodeAt(i));
            if(code < 48 || code > 57)
            {
               return false;
            }
         }
         return true;
      }
      
      public static function getTickNumber($sec:int) : String
      {
         var hour:int = $sec / 3600;
         var minute:int = ($sec - hour * 3600) / 60;
         var second:int = $sec - hour * 3600 - minute * 60;
         var timeStr:String = hour < 10 ? "0" + hour : hour.toString();
         timeStr += ":" + (minute < 10 ? "0" + minute : minute);
         return timeStr + (":" + (second < 10 ? "0" + second : second));
      }
      
      public static function getTickHM($sec:int) : String
      {
         var hour:int = $sec / 3600;
         var minute:int = ($sec - hour * 3600) / 60;
         var timeStr:String = hour < 10 ? "0" + hour : hour.toString();
         return timeStr + (":" + (minute < 10 ? "0" + minute : minute));
      }
      
      public static function getTickMS($sec:int) : String
      {
         var hour:int = $sec / 3600;
         var minute:int = $sec / 60;
         var restMin:int = ($sec - hour * 3600) / 60;
         var second:int = $sec - hour * 3600 - restMin * 60;
         var timeStr:String = (minute < 10 ? "0" + minute : minute) + "";
         return timeStr + (":" + (second < 10 ? "0" + second : second));
      }
      
      public static function getTickCannLeftActivityTime($sec:int) : String
      {
         var currentSec:int = $sec - 1200;
         if(currentSec <= 0)
         {
            return "";
         }
         var hour:int = currentSec / 3600;
         var minute:int = (currentSec - hour * 3600) / 60;
         var second:int = currentSec - hour * 3600 - minute * 60;
         var timeStr:String = (minute < 10 ? "0" + minute : minute) + "";
         return timeStr + (":" + (second < 10 ? "0" + second : second));
      }
      
      public static function getNowSec($nowData:Date) : int
      {
         return $nowData.hours * 3600 + $nowData.minutes * 60 + $nowData.seconds;
      }
      
      public static function getCNTickMS($sec:int) : String
      {
         var min:int = $sec / 60;
         var sec:int = $sec - min * 60;
         var timeStr:String = "" + (min >= 10 ? min : "0" + min);
         return timeStr + ("分" + (sec >= 10 ? sec : "0" + sec) + "秒");
      }
      
      public static function getENTickMS($sec:int) : String
      {
         var min:int = $sec / 60;
         var sec:int = $sec - min * 60;
         var timeStr:String = "" + (min >= 10 ? min : "0" + min);
         return timeStr + (":" + (sec >= 10 ? sec : "0" + sec));
      }
      
      public static function getCNDHMS($sec:int) : String
      {
         var day:int = $sec / 86400;
         var hour:int = ($sec - day * 86400) / 3600;
         var min:int = ($sec - day * 86400 - hour * 3600) / 60;
         var sec:int = $sec - day * 86400 - hour * 3600 - min * 60;
         return day + "天" + " " + hour + ":" + min + ":" + sec;
      }
      
      public static function getSTRDHMS($sec:int) : String
      {
         var day:int = $sec / 86400;
         var hour:int = ($sec - day * 86400) / 3600;
         var min:int = ($sec - day * 86400 - hour * 3600) / 60;
         var sec:int = $sec - day * 86400 - hour * 3600 - min * 60;
         return day + "天" + hour + "小时" + min + "分钟" + sec + "秒";
      }
      
      public static function getDHM($sec:int) : String
      {
         var day:int = $sec / 86400;
         var hour:int = ($sec - day * 86400) / 3600;
         var min:int = ($sec - day * 86400 - hour * 3600) / 60;
         return day + "天" + hour + "小时" + min + "分钟";
      }
      
      public static function getHMTimeString($hours:int, $minutes:int) : String
      {
         var shour:String = $hours < 10 ? "0" + $hours : $hours.toString();
         var sminute:String = $minutes < 10 ? "0" + $minutes : $minutes.toString();
         return shour + ":" + sminute;
      }
      
      public static function getHMSTimeString($sec:int) : String
      {
         var hour:int = $sec / 3600;
         var hourStr:String = hour >= 10 ? hour.toString() : "0" + hour.toString();
         var min:int = ($sec - hour * 3600) / 60;
         var minStr:String = min >= 10 ? min.toString() : "0" + min.toString();
         var sec:int = $sec - hour * 3600 - min * 60;
         var secStr:String = sec >= 10 ? sec.toString() : "0" + sec.toString();
         return hourStr + ":" + minStr + ":" + secStr;
      }
   }
}

