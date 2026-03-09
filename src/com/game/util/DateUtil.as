package com.game.util
{
   import com.game.locators.GameData;
   import com.publiccomponent.loading.XMLLocator;
   
   public class DateUtil
   {
      
      private static var codeXML:XML;
      
      private var tao_txtnum_info:Array;
      
      private var tao_txtsolarMonth:Array;
      
      private var Gan:Array;
      
      private var Zhi:Array;
      
      private var Animals:Array;
      
      private var tao_txtsolarTerm:Array;
      
      private var tao_txtsTermInfo:Array;
      
      private var nStr1:Array;
      
      private var nStr2:Array;
      
      private var monthName:Array;
      
      private var jieriarr:Array;
      
      private var cyear:Number;
      
      private var cmonth:Number;
      
      private var cday:Number;
      
      private var isLeap:Boolean;
      
      private var nianzhu:String;
      
      private var yuezhu:String;
      
      private var rizhu:String;
      
      private var jie:String;
      
      private var date:Date;
      
      public function DateUtil()
      {
         var y:Number = NaN;
         var m:Number = NaN;
         var d:Number = NaN;
         var cY:* = undefined;
         var cM:* = undefined;
         var cD:* = undefined;
         this.tao_txtnum_info = new Array(19416,19168,42352,21717,53856,55632,21844,22191,39632,21970,19168,42422,42192,53840,53845,46415,54944,44450,38320,18807,18815,42160,46261,27216,27968,43860,11119,38256,21234,18800,25958,54432,59984,27285,23263,11104,34531,37615,51415,51551,54432,55462,46431,22176,42420,9695,37584,53938,43344,46423,27808,46416,21333,19887,42416,17779,21183,43432,59728,27296,44710,43856,19296,43748,42352,21088,62051,55632,23383,22176,38608,19925,19152,42192,54484,53840,54616,46400,46752,38310,38335,18864,43380,42160,45690,27216,27968,44870,43872,38256,19189,18800,25776,29859,59984,27480,23232,43872,38613,37600,51552,55636,54432,55888,30034,22176,43959,9680,37584,51893,43344,46240,47780,44368,21977,19360,42416,20854,21183,43312,31060,27296,44368,23378,19296,42726,42208,53856,60005,54576,23200,30371,38608,19195,19152,42192,53430,53855,54560,56645,46496,22224,21938,18864,42359,42160,43600,45653,27951,44448,19299,37759,18936,18800,25776,26790,59999,27424,42692,43759,37600,53987
         ,51552,54615,54432,55888,23893,22176,42704,21972,21200,43448,43344,46240,46758,44368,21920,43940,42416,21168,45683,26928,29495,27296,44368,19285,19311,42352,21732,53856,59752,54560,55968,27302,22239,19168,43476,42192,53584,62034,54560);
         this.tao_txtsolarMonth = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
         this.Gan = new Array("甲","乙","丙","丁","戊","己","庚","辛","壬","癸");
         this.Zhi = new Array("子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥");
         this.Animals = new Array("鼠","牛","虎","兔","龙","蛇","马","羊","猴","鸡","狗","猪");
         this.tao_txtsolarTerm = new Array("小寒","大寒","立春","雨水","惊蛰","春分","清明","谷雨","立夏","小满","芒种","夏至","小暑","大暑","立秋","处暑","白露","秋分","寒露","霜降","立冬","小雪","大雪","冬至");
         this.tao_txtsTermInfo = new Array(0,21208,42467,63836,85337,107014,128867,150921,173149,195551,218072,240693,263343,285989,308563,331033,353350,375494,397447,419210,440795,462224,483532,504758);
         this.nStr1 = new Array("日","一","二","三","四","五","六","七","八","九","十");
         this.nStr2 = new Array("初","十","廿","卅","□");
         this.monthName = new Array("JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC");
         this.jieriarr = ["元旦","除夕","春节","元宵节","妇女节","愚人节","劳动节","母亲节","端午节","儿童节","教师节","国庆节","万圣节","感恩节","中秋节","圣诞节","父亲节","七夕节","重阳节","中元节"];
         super();
         this.date = new Date(GameData.instance.playerData.systemTimes * 1000);
         var leap:* = 0;
         var temp:* = 0;
         y = Number(this.date.getFullYear());
         m = Number(this.date.getMonth());
         d = Number(this.date.getDate());
         var offset:* = (Date.UTC(y,m,d) - Date.UTC(1900,0,31)) / 86400000;
         var i:int = 1900;
         while(i < 2100 && offset > 0)
         {
            temp = this.lYearDays(i);
            offset -= temp;
            i++;
         }
         if(offset < 0)
         {
            offset += temp;
            i--;
         }
         this.cyear = i;
         leap = this.leapMonth(i);
         this.isLeap = false;
         i = 1;
         while(i < 13 && offset > 0)
         {
            if(leap > 0 && i == leap + 1 && this.isLeap == false)
            {
               i--;
               this.isLeap = true;
               temp = this.leapDays(this.cyear);
            }
            else
            {
               temp = this.monthDays(this.cyear,i);
            }
            if(this.isLeap == true && i == leap + 1)
            {
               this.isLeap = false;
            }
            offset -= temp;
            i++;
         }
         if(offset == 0 && leap > 0 && i == leap + 1)
         {
            if(this.isLeap)
            {
               this.isLeap = false;
            }
            else
            {
               this.isLeap = true;
               i--;
            }
         }
         if(offset < 0)
         {
            offset += temp;
            i--;
         }
         this.cmonth = i;
         this.cday = offset + 1;
         if(m < 2)
         {
            cY = this.cyclical(y - 1900 + 36 - 1);
         }
         else
         {
            cY = this.cyclical(y - 1900 + 36);
         }
         cM = this.cyclical((y - 1900) * 12 + m + 12);
         var tmp1:* = this.sTerm(y,m * 2);
         var tmp2:* = this.sTerm(y,m * 2 + 1);
         if(d == tmp1)
         {
            this.jie = this.tao_txtsolarTerm[m * 2];
         }
         else if(d == tmp2)
         {
            this.jie = this.tao_txtsolarTerm[m * 2 + 1];
         }
         else
         {
            this.jie = "";
         }
         this.jie = this.jie;
         var term2:* = this.sTerm(y,2);
         var firstNode:* = this.sTerm(y,m * 2);
         if(m == 1 && d >= term2)
         {
            cY = this.cyclical(y - 1900 + 36);
         }
         if(d + 1 >= firstNode)
         {
            cM = this.cyclical((y - 1900) * 12 + m + 13);
         }
         var dayCyclical:* = Date.UTC(y,m,1,0,0,0,0) / 86400000 + 25567 + 10;
         cD = this.cyclical(dayCyclical + d - 1);
         this.nianzhu = cY.toString();
         this.yuezhu = cM.toString();
         this.rizhu = cD.toString();
      }
      
      public static function getPassDayByDate(str:String) : int
      {
         if(str == null)
         {
            return 0;
         }
         return getPassDayByValueOf(getDateByNumStr(str).valueOf());
      }
      
      public static function getPassDayByValueOf(targetT:Number) : int
      {
         var curD:Date = new Date(GameData.instance.playerData.systemTimes * 1000);
         var zeroD:Date = new Date(curD.getFullYear(),curD.getMonth(),curD.getDate());
         return uint(int((zeroD.valueOf() - targetT) / (1000 * 60 * 60 * 24) + 1));
      }
      
      public static function isServerTimeBetween(str1:String, str2:String) : Boolean
      {
         return isPassTime(str1) && !isPassTime(str2);
      }
      
      public static function isPassTime(str:String) : Boolean
      {
         if(GameData.instance.playerData.systemTimes > getDateByNumStr(str).valueOf() / 1000)
         {
            return true;
         }
         return false;
      }
      
      public static function getServerDate() : Date
      {
         if(isNaN(GameData.instance.playerData.systemTimes))
         {
            return new Date();
         }
         return new Date(GameData.instance.playerData.systemTimes * 1000);
      }
      
      public static function isPassTimeSecondEveryDay(str:String) : Boolean
      {
         var serverHours:int = getServerDate().hours;
         var serverMinutes:int = getServerDate().minutes;
         var serverSecond:int = getServerDate().seconds;
         var h1:int = int(str.slice(0,2));
         var m1:int = int(str.slice(3,5));
         var s1:int = int(str.slice(6,8));
         if(h1 * 3600 + m1 * 60 + s1 <= serverHours * 3600 + serverMinutes * 60 + serverSecond)
         {
            return true;
         }
         return false;
      }
      
      public static function isServerTimeIn(str1:String, str2:String) : Boolean
      {
         var serverHours:int = getServerDate().hours;
         var serverMinutes:int = getServerDate().minutes;
         var h1:int = int(str1.slice(0,2));
         var m1:int = int(str1.slice(3,5));
         var h2:int = int(str2.slice(0,2));
         var m2:int = int(str2.slice(3,5));
         if(h1 * 60 + m1 <= serverHours * 60 + serverMinutes && serverHours * 60 + serverMinutes < h2 * 60 + m2)
         {
            return true;
         }
         return false;
      }
      
      public static function getDateByNumStr(str:String) : Date
      {
         var len:uint = uint(str.length);
         var year:uint = len >= 4 ? uint(int(str.substr(0,4))) : 0;
         var month:uint = len >= 6 ? uint(int(str.substr(4,2)) - 1) : 0;
         var day:uint = len >= 8 ? uint(int(str.substr(6,2))) : 0;
         var hours:uint = len >= 10 ? uint(int(str.substr(8,2))) : 0;
         var mintues:uint = len >= 12 ? uint(int(str.substr(10,2))) : 0;
         var seconds:uint = len >= 14 ? uint(int(str.substr(12,2))) : 0;
         return new Date(year,month,day,hours,mintues,seconds);
      }
      
      public static function isToday(num:int) : Boolean
      {
         var flag:Boolean = false;
         var server:Date = new Date(GameData.instance.playerData.systemTimes * 1000);
         var now:Date = new Date(num * 1000);
         if(server.getFullYear() == now.getFullYear() && server.getMonth() == now.getMonth() && server.getDate() == now.getDate())
         {
            flag = true;
         }
         else
         {
            flag = false;
         }
         return flag;
      }
      
      public static function isTodayByStr(str:String) : Boolean
      {
         var flag:Boolean = false;
         var server:Date = new Date(GameData.instance.playerData.systemTimes * 1000);
         if(server.getFullYear() == int(str.substr(0,4)) && server.getMonth() == int(str.substr(4,2)) - 1 && server.getDate() == int(str.substr(6,2)))
         {
            flag = true;
         }
         else
         {
            flag = false;
         }
         return flag;
      }
      
      public static function isOpenCode() : Boolean
      {
         var timeAry:Array = null;
         var str:String = null;
         var ary:Array = null;
         if(codeXML == null)
         {
            codeXML = XMLLocator.getInstance().getErrofInfo(906);
         }
         if(isTodayByStr(String(codeXML.day)))
         {
            timeAry = String(codeXML.time).split(",");
            for each(str in timeAry)
            {
               ary = str.split("#");
               if(isServerTimeBetween(ary[0],ary[1]))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function getLongShortTime(timeValue:Number, isShowMin:Boolean = true) : String
      {
         var str:String = "";
         var tDate:Date = new Date(timeValue * 1000);
         str += tDate.getFullYear() + "-" + numTstring(tDate.getMonth() + 1) + "-" + numTstring(tDate.getDate()) + " ";
         if(isShowMin)
         {
            str += numTstring(tDate.getHours()) + ":" + numTstring(tDate.getMinutes());
         }
         return str;
      }
      
      public static function numTstring(num:Number, len:uint = 2) : String
      {
         var i:uint = 0;
         var str:String = num.toString();
         var pLen:Number = len - str.length;
         if(pLen > 0)
         {
            for(i = 0; i < pLen; i++)
            {
               str = "0" + str;
            }
         }
         return str;
      }
      
      public static function getCountdownTime3(num:Number) : String
      {
         var str:String = "";
         var day:int = num / 60 / 60 / 24;
         str = numTstring(day) + ":";
         var hour:int = num / 60 / 60 % 24;
         str += numTstring(hour) + ":";
         var minute:int = num / 60 % 60;
         return str + numTstring(minute);
      }
      
      public static function getStringByTime(num:Number, n:int) : String
      {
         var str:String = "";
         var day:int = num / 60 / 60 / 24;
         if(n == 2 && day == 0)
         {
            str = "";
         }
         else
         {
            str = numTstring(day) + "天";
         }
         var hour:int = num / 60 / 60 % 24;
         if(n == 2 && day == 0)
         {
            str += "";
         }
         else
         {
            str += numTstring(hour) + "时";
         }
         var minute:int = num / 60 % 60;
         if(n == 2 && day == 0)
         {
            str += "";
         }
         else
         {
            str += numTstring(minute) + "分";
         }
         return str;
      }
      
      public static function getStringByMinAndSecTime(num:Number) : String
      {
         var str:String = "";
         var minute:int = num / 60;
         str += numTstring(minute) + "分";
         var second:int = num % 60;
         return str + (numTstring(second) + "秒");
      }
      
      public static function getCountdowTime3(num:Number) : String
      {
         var str:String = "";
         var minute:int = num / 60 % 60;
         str += numTstring(minute) + ":";
         var seconds:int = num % 60;
         return str + numTstring(seconds);
      }
      
      public static function getCountdowTime4(num:Number) : String
      {
         var str:String = "";
         var hour:int = num / 60 / 60;
         str += numTstring(hour) + ":";
         var minute:int = num / 60 % 60;
         str += numTstring(minute) + ":";
         var seconds:int = num % 60;
         return str + numTstring(seconds);
      }
      
      public static function getCountdowTime5(num:Number) : String
      {
         var str:String = "";
         var hour:int = num / 60 / 60;
         str += numTstring(hour) + ":";
         var minute:int = num / 60 % 60;
         return str + numTstring(minute);
      }
      
      public static function getCountdowTime6(num:Number) : String
      {
         var str:String = "";
         var hour:int = num / 60 / 60;
         str += numTstring(hour) + "时";
         var minute:int = num / 60 % 60;
         str += numTstring(minute) + "分";
         var seconds:int = num % 60;
         return str + (numTstring(seconds) + "秒");
      }
      
      public static function getTimestampAfterDaysAtMidnight(inputTimestamp:Number, day:int = 30) : Number
      {
         var inputDate:Date = new Date(inputTimestamp * 1000);
         var afterDays:Date = new Date(inputDate);
         afterDays.date += day;
         return afterDays.time / 1000;
      }
      
      public function getTaosJYear() : Number
      {
         return this.cyear;
      }
      
      public function getTaoJMonth() : Number
      {
         return this.cmonth;
      }
      
      public function getTaoJDay() : Number
      {
         return this.cday;
      }
      
      public function getnewMonth() : Number
      {
         return this.date.getMonth() + 1;
      }
      
      public function getTaoJNianZhu() : String
      {
         return this.nianzhu;
      }
      
      public function getYueZhu() : String
      {
         return this.yuezhu;
      }
      
      public function getRiZhu() : String
      {
         return this.rizhu;
      }
      
      public function getJieQi() : String
      {
         return this.jie;
      }
      
      public function getShiceng() : String
      {
         return this.Zhi[Math.round(this.date.getHours() % 23 / 2)] + "时";
      }
      
      private function lYearDays(y:*) : *
      {
         var sum:* = 348;
         for(var i:* = 32768; i > 8; i >>= 1)
         {
            sum += Boolean(this.tao_txtnum_info[y - 1900] & i) ? 1 : 0;
         }
         return sum + this.leapDays(y);
      }
      
      private function leapDays(y:*) : *
      {
         if(this.leapMonth(y))
         {
            return (this.tao_txtnum_info[y - 1899] & 0x0F) == 15 ? 30 : 29;
         }
         return 0;
      }
      
      private function leapMonth(y:*) : *
      {
         var lm:* = this.tao_txtnum_info[y - 1900] & 0x0F;
         return lm == 15 ? 0 : lm;
      }
      
      private function monthDays(y:*, m:*) : *
      {
         return Boolean(this.tao_txtnum_info[y - 1900] & 65536 >> m) ? 30 : 29;
      }
      
      private function sTerm(y:*, n:*) : *
      {
         var offDate:* = new Date(31556925974.7 * (y - 1900) + this.tao_txtsTermInfo[n] * 60000 + Date.UTC(1900,0,6,2,5));
         return offDate.getUTCDate();
      }
      
      private function solarDays(y:*, m:*) : *
      {
         if(m == 1)
         {
            return y % 4 == 0 && y % 100 != 0 || y % 400 == 0 ? 29 : 28;
         }
         return this.tao_txtsolarMonth[m];
      }
      
      private function cyclical(num:*) : *
      {
         return this.Gan[num % 10] + this.Zhi[num % 12];
      }
      
      public function getDate() : Number
      {
         return this.date.getDate();
      }
      
      public function getDay() : Number
      {
         return this.date.getDay();
      }
      
      public function getFullYear() : Number
      {
         return this.date.getFullYear();
      }
      
      public function getMonth() : Number
      {
         return this.date.getMonth();
      }
      
      public function getJieri() : String
      {
         var arr1:Array = [this.getMonth() + 1,this.getDate()];
         var arr2:Array = [this.getTaoJMonth(),this.getTaoJDay()];
         var xingqi:Number = this.getDay();
         switch(arr1[0])
         {
            case 1:
               if(arr1[1] == 1)
               {
                  return this.jieriarr[0];
               }
               break;
            case 3:
               if(arr1[1] == 8)
               {
                  return this.jieriarr[4];
               }
               break;
            case 4:
               if(arr1[1] == 1)
               {
                  return this.jieriarr[5];
               }
               break;
            case 5:
               if(arr1[1] == 1)
               {
                  return this.jieriarr[6];
               }
               break;
            case 6:
               if(arr1[1] == 1)
               {
                  return this.jieriarr[9];
               }
               break;
            case 9:
               if(arr1[1] == 10)
               {
                  return this.jieriarr[10];
               }
               break;
            case 10:
               if(arr1[1] == 1)
               {
                  return this.jieriarr[11];
               }
               if(arr1[1] == 31)
               {
                  return this.jieriarr[12];
               }
               break;
            case 12:
               if(arr1[1] == 25)
               {
                  return this.jieriarr[15];
               }
         }
         switch(arr2[0])
         {
            case 12:
               if(arr2[1] == 30)
               {
                  return this.jieriarr[1];
               }
               break;
            case 1:
               if(arr2[1] == 1)
               {
                  return this.jieriarr[2];
               }
               if(arr2[1] == 15)
               {
                  return this.jieriarr[3];
               }
               break;
            case 5:
               if(arr2[1] == 5)
               {
                  return this.jieriarr[8];
               }
               break;
            case 8:
               if(arr2[1] == 15)
               {
                  return this.jieriarr[14];
               }
               break;
            case 7:
               if(arr2[1] == 7)
               {
                  return this.jieriarr[17];
               }
               if(arr2[1] == 15)
               {
                  return this.jieriarr[19];
               }
               break;
            case 9:
               if(arr2[1] == 9)
               {
                  return this.jieriarr[18];
               }
         }
         if(arr1[0] == 5 && arr1[1] >= 8 && arr1[1] <= 14 && xingqi == 0)
         {
            return this.jieriarr[7];
         }
         if(arr1[0] == 6 && arr1[1] >= 15 && arr1[1] <= 21 && xingqi == 0)
         {
            return this.jieriarr[16];
         }
         if(arr1[0] == 11 && arr1[1] >= 22 && arr1[1] <= 28 && xingqi == 4)
         {
            return this.jieriarr[13];
         }
         return "";
      }
   }
}

