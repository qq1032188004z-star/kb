package com.game.modules.view
{
   import caurina.transitions.Tweener;
   import com.game.locators.GameData;
   import com.game.modules.view.item.CinemaItem;
   import com.game.util.CacheUtil;
   import com.game.util.ColorUtil;
   import com.game.util.HLoaderSprite;
   import com.publiccomponent.URLUtil;
   import com.publiccomponent.events.ItemClickEvent;
   import com.publiccomponent.list.TileList;
   import com.publiccomponent.loading.GreenLoading;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class CinemaView extends HLoaderSprite
   {
      
      private var tlist:TileList;
      
      private var list1:Array = [];
      
      private var list2:Array = [];
      
      private var current:int = 0;
      
      private var urlloader:URLLoader;
      
      private var xml:XML;
      
      private var node:XML;
      
      private var body:Object;
      
      private var player:Loader;
      
      private var playMC:MovieClip;
      
      private var back:Sprite;
      
      private const Movie1:Array = [[1,2,3,4],[5,6,7],[8,9,10,11],[12,13,14],[16,17,18,19],[20,21,22,23],[24,25,26,27,28,29,30,31,32],[33,34],[35,36,37,38,39],[40,41,42,43,44,45],[46,47,48,49],[50,51,53,55,57,58,59,60,61,62],[63,64,65,66],[67,68,69],[70,71,73,74,75],[76],[78,80,82],[83,84,85,87,89,90,92],[94,95,96,97],[98,100,101,102,103,104],[105,106,107],[108,110,111],[113,114,115,116,117,118,119],[121,122,124,126,128,129],[130,132,134,136,138],[139,140],[142,143,145],[146,148,149,150,152],[154,156,158,160,161],[],[162,163,164],[165,166],[167,169,170,171],[173,174,175],[177,178,179],[181,182],[184,186],[188,190,191,192],[194,195,197,199,200],[201,203,204,205],[206,207,208,209],[210,211,212,213,214],[215,217,219],[220,221,222,224],[225,226,227],[228,229,231,233],[234,236,237],[239,241,242],[243,244],[246,248],[249]];
      
      private const Movie2:Array = [[1,2,3,4],[5,6,7],[8,9,10,11],[12,13,15],[16,17,18,19],[20,21,22,23],[24,25,26,27,28,29,30,31,32],[33,34],[35,36,37,38,39],[40,41,42,43,44,45],[46,47,48,49],[50,52,54,56,57,58,59,60,61,62],[63,64,65,66],[67,68,69],[70,72,73,74,75],[77],[79,81,82],[83,84,86,88,89,91,93],[94,95,96,97],[99,100,101,102,103,104],[105,106,107],[109,110,112],[113,114,115,116,117,118,120],[121,123,125,127,128,129],[131,133,135,137,138],[139,141],[142,144,145],[147,148,149,151,153],[155,157,159,160,161],[],[162,163,164],[165,166],[168,169,170,172],[173,174,176],[177,178,180],[181,183],[185,187],[189,190,191,193],[194,196,198,199,200],[202,203,204,205],[206,207,208,209],[210,211,212,213,214],[215,218,219],[220,221,223,224],[225,226,227],[228,230,232,233],[235,236,238],[240,241,242],[243,245],[247,248],[249]];
      
      public function CinemaView()
      {
         GreenLoading.loading.visible = true;
         super();
      }
      
      override public function initParams(params:Object = null) : void
      {
         var obj:Object = null;
         var i:int = 0;
         var len:int = 0;
         var target:Array = null;
         var m:int = 0;
         var list:Array = params.list as Array;
         var main:int = 0;
         for each(obj in list)
         {
            if(obj.key == 1)
            {
               main = int(obj.value);
            }
            else
            {
               for(m = int(obj.key); m <= obj.value; m++)
               {
                  this.list2.push(m);
               }
            }
         }
         len = main - 2000;
         target = Boolean(GameData.instance.playerData.roleType & 1) ? this.Movie1 : this.Movie2;
         for(i = 0; i < len; i++)
         {
            this.list1 = this.list1.concat(target[i]);
         }
         len = int(this.list2.length);
         for(i = 0; i < len; i++)
         {
            if(Boolean(GameData.instance.playerData.roleType & 1))
            {
               if(this.list2[i] == 2011 || this.list2[i] == 2016 || this.list2[i] == 2029)
               {
                  this.list2.splice(i,1);
               }
            }
            else if(this.list2[i] == 2013 || this.list2[i] == 2017 || this.list2[i] == 2028)
            {
               this.list2.splice(i,1);
            }
         }
         this.url = "assets/material/cinema_view.swf";
      }
      
      override public function setShow() : void
      {
         this.loader.loader.unloadAndStop(false);
         this.bg.cacheAsBitmap = true;
         this.bg.stopBtn.mouseEnabled = false;
         this.bg.removeChild(bg.stopBtn);
         this.bg.btn0.addEventListener(MouseEvent.CLICK,this.on_btn0);
         this.bg.btn1.addEventListener(MouseEvent.CLICK,this.on_btn1);
         this.bg.closeBtn.addEventListener(MouseEvent.CLICK,this.on_closeBtn);
         this.bg.leftBtn.addEventListener(MouseEvent.CLICK,this.on_leftBtn);
         this.bg.rightBtn.addEventListener(MouseEvent.CLICK,this.on_rightBtn);
         this.bg.playBtn.addEventListener(MouseEvent.CLICK,this.on_playBtn);
         this.bg.stopBtn.addEventListener(MouseEvent.CLICK,this.on_stopBtn);
         this.initList();
         this.initLoader();
         GreenLoading.loading.visible = false;
      }
      
      private function on_closeBtn(evt:MouseEvent) : void
      {
         this.disport();
      }
      
      private function on_btn0(evt:MouseEvent) : void
      {
         if(bg.mc.currentFrame == 1)
         {
            return;
         }
         this.bg.mc.gotoAndStop(1);
         this.bg.mmc.gotoAndStop(1);
         this.bg.mmc.visible = this.list1.length <= 0;
         this.bg.leftBtn.mouseEnabled = Boolean(this.list1.length > 3);
         this.bg.rightBtn.mouseEnabled = Boolean(this.list1.length > 3);
         this.tlist.columnCount = this.list1.length;
         this.tlist.dataProvider = this.list1;
         this.tlist.x = 317;
         this.current = 0;
      }
      
      private function on_btn1(evt:MouseEvent) : void
      {
         if(bg.mc.currentFrame == 2)
         {
            return;
         }
         this.bg.mc.gotoAndStop(2);
         this.bg.mmc.gotoAndStop(2);
         this.bg.mmc.visible = this.list2.length <= 0;
         this.bg.leftBtn.mouseEnabled = Boolean(this.list2.length > 3);
         this.bg.rightBtn.mouseEnabled = Boolean(this.list2.length > 3);
         this.tlist.columnCount = this.list2.length;
         this.tlist.dataProvider = this.list2;
         this.tlist.x = 317;
         this.current = 0;
      }
      
      private function on_leftBtn(evt:MouseEvent) : void
      {
         var front:CinemaItem = null;
         var back:CinemaItem = null;
         this.bg.leftBtn.mouseEnabled = false;
         this.bg.rightBtn.mouseEnabled = false;
         if(this.current > 0)
         {
            --this.current;
            Tweener.addTween(this.tlist,{
               "x":this.tlist.x + 165,
               "time":0.3,
               "delay":0,
               "transition":"linear",
               "onComplete":this.onTweenerComplete
            });
         }
         else
         {
            front = this.tlist.getChildAt(0) as CinemaItem;
            back = this.tlist.getChildAt(this.tlist.numChildren - 1) as CinemaItem;
            if(Boolean(front) && Boolean(back))
            {
               back.x = front.x - 165;
               this.tlist.setChildIndex(back,0);
               Tweener.addTween(this.tlist,{
                  "x":this.tlist.x + 165,
                  "time":0.3,
                  "delay":0,
                  "transition":"linear",
                  "onComplete":this.onTweenerComplete
               });
            }
         }
      }
      
      private function on_rightBtn(evt:MouseEvent) : void
      {
         var front:CinemaItem = null;
         var back:CinemaItem = null;
         this.bg.leftBtn.mouseEnabled = false;
         this.bg.rightBtn.mouseEnabled = false;
         if(this.current < this.tlist.columnCount - 3)
         {
            ++this.current;
            Tweener.addTween(this.tlist,{
               "x":this.tlist.x - 165,
               "time":0.3,
               "delay":0,
               "transition":"linear",
               "onComplete":this.onTweenerComplete
            });
         }
         else
         {
            front = this.tlist.getChildAt(0) as CinemaItem;
            back = this.tlist.getChildAt(this.tlist.numChildren - 1) as CinemaItem;
            if(Boolean(front) && Boolean(back))
            {
               front.x = back.x + 165;
               this.tlist.setChildIndex(front,this.tlist.numChildren - 1);
               Tweener.addTween(this.tlist,{
                  "x":this.tlist.x - 165,
                  "time":0.3,
                  "delay":0,
                  "transition":"linear",
                  "onComplete":this.onTweenerComplete
               });
            }
         }
      }
      
      private function onTweenerComplete() : void
      {
         this.bg.leftBtn.mouseEnabled = true;
         this.bg.rightBtn.mouseEnabled = true;
      }
      
      private function on_playBtn(evt:MouseEvent) : void
      {
         try
         {
            bg.closeBtn.mouseEnabled = false;
            bg.playBtn.mouseEnabled = false;
            bg.stopBtn.mouseEnabled = false;
            if(this.body == null)
            {
               this.playMovie(this.tlist.dataProvider[this.current]);
            }
            else
            {
               this.playMovie(int(this.body));
            }
         }
         catch(e:*)
         {
            O.o("卡布电影院播放出错了！",e);
            bg.closeBtn.mouseEnabled = true;
            bg.playBtn.mouseEnabled = true;
            bg.stopBtn.mouseEnabled = true;
         }
      }
      
      private function playMovie(id:int) : void
      {
         var myurl:String;
         var dest:String = null;
         this.node = this.xml.children().(@id == id)[0];
         dest = String(this.node.sn);
         if(Boolean(this.node.hasOwnProperty("sn2")))
         {
            dest = Boolean(GameData.instance.playerData.roleType & 1) ? String(this.node.sn) : String(this.node.sn2);
         }
         myurl = URLUtil.getSvnVer("assets/animation/" + dest + ".swf");
         MapView.instance.masterPerson.stop();
         this.player.load(new URLRequest(myurl));
      }
      
      private function initList() : void
      {
         this.tlist = new TileList(317,290);
         this.tlist.build(3,1,150,150,15,15,CinemaItem);
         this.addChild(this.tlist);
         bg.removeChild(bg.mask_mc);
         this.addChild(bg.mask_mc);
         this.tlist.mask = bg["mask_mc"];
         this.tlist.addEventListener(ItemClickEvent.ITEMCLICKEVENT,this.itemClick,true);
         this.bg.mc.gotoAndStop(2);
         this.on_btn0(null);
      }
      
      private function itemClick(evt:ItemClickEvent) : void
      {
         var item:CinemaItem = null;
         this.body = evt.params;
         var len:int = this.tlist.numChildren;
         for(var i:int = 0; i < len; i++)
         {
            item = this.tlist.getChildAt(i) as CinemaItem;
            item.filters = [];
            if(item.data == evt.params)
            {
               item.filters = ColorUtil.getGrowFilter();
            }
         }
      }
      
      private function initLoader() : void
      {
         this.urlloader = new URLLoader();
         this.urlloader.dataFormat = URLLoaderDataFormat.BINARY;
         this.urlloader.addEventListener(Event.COMPLETE,this.onLoaded);
         this.urlloader.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this.urlloader.load(new URLRequest(URLUtil.getSvnVer("config/films")));
         this.player = new Loader();
         this.player.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onPlayerComp);
         this.player.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onPlayerError);
      }
      
      private function onLoaded(evt:Event) : void
      {
         var bytes:ByteArray = null;
         var str:String = null;
         try
         {
            bytes = this.urlloader.data as ByteArray;
            bytes.uncompress();
            bytes.position = 0;
            str = bytes.readUTFBytes(bytes.bytesAvailable);
            this.xml = new XML(str);
            this.urlloader.removeEventListener(Event.COMPLETE,this.onLoaded);
            this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
            this.urlloader = null;
         }
         catch(e:*)
         {
            O.o("卡布电影院加载xml出错了~");
         }
      }
      
      private function onError(evt:IOErrorEvent) : void
      {
         O.o("卡布电影院加载xml出错了~囧");
         this.urlloader.removeEventListener(Event.COMPLETE,this.onLoaded);
         this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this.urlloader = null;
      }
      
      private function onPlayerComp(evt:Event) : void
      {
         this.playMC = this.player.content as MovieClip;
         this.playMC.x = this.node.x;
         this.playMC.y = this.node.y;
         this.back = new Sprite();
         this.back.graphics.beginFill(0,0.85);
         this.back.graphics.drawRect(0,0,970,570);
         this.back.graphics.endFill();
         WindowLayer.instance.stage.addChild(this.back);
         WindowLayer.instance.stage.addChild(this.playMC);
         WindowLayer.instance.stage.addChild(bg.stopBtn);
         this.bg.stopBtn.mouseEnabled = true;
         this.playMC.addFrameScript(this.playMC.totalFrames - 1,this.onPlayerOver);
         this.playMC.gotoAndPlay(1);
      }
      
      private function onPlayerOver() : void
      {
         this.playMC.addFrameScript(this.playMC.totalFrames - 1,null);
         this.playMC.stop();
         this.player.unloadAndStop();
         this.bg.stopBtn.mouseEnabled = false;
         WindowLayer.instance.stage.removeChild(this.back);
         WindowLayer.instance.stage.removeChild(this.playMC);
         WindowLayer.instance.stage.removeChild(bg.stopBtn);
         this.playMC = null;
         this.back = null;
         bg.closeBtn.mouseEnabled = true;
         bg.playBtn.mouseEnabled = true;
         bg.stopBtn.mouseEnabled = true;
      }
      
      private function onPlayerError(evt:IOErrorEvent) : void
      {
         O.o("影片出错了~囧");
         bg.closeBtn.mouseEnabled = true;
         bg.playBtn.mouseEnabled = true;
         bg.stopBtn.mouseEnabled = true;
      }
      
      private function on_stopBtn(evt:MouseEvent) : void
      {
         this.onPlayerOver();
      }
      
      override public function disport() : void
      {
         if(!bg)
         {
            return;
         }
         CacheUtil.deleteObject(CinemaView);
         this.bg.btn0.removeEventListener(MouseEvent.CLICK,this.on_btn0);
         this.bg.btn1.removeEventListener(MouseEvent.CLICK,this.on_btn1);
         this.bg.closeBtn.removeEventListener(MouseEvent.CLICK,this.on_closeBtn);
         this.bg.leftBtn.removeEventListener(MouseEvent.CLICK,this.on_leftBtn);
         this.bg.rightBtn.removeEventListener(MouseEvent.CLICK,this.on_rightBtn);
         this.bg.playBtn.removeEventListener(MouseEvent.CLICK,this.on_playBtn);
         this.tlist.removeEventListener(ItemClickEvent.ITEMCLICKEVENT,this.itemClick);
         this.player.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onPlayerComp);
         this.player.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onPlayerError);
         if(this.urlloader != null)
         {
            this.urlloader.removeEventListener(Event.COMPLETE,this.onLoaded);
            this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
            this.urlloader = null;
         }
         this.player = null;
         this.xml = null;
         this.removeChild(this.tlist);
         this.removeChild(bg.mask_mc);
         if(Boolean(this.playMC) && this.contains(this.playMC))
         {
            this.removeChild(this.playMC);
         }
         this.tlist.dataProvider = [];
         this.tlist = null;
         this.parent.removeChild(this);
         super.disport();
      }
   }
}

