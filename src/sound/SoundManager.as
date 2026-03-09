package sound
{
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   
   public class SoundManager
   {
      
      private static var _instance:SoundManager;
      
      private var _effectMusicVolumn:Number = 1;
      
      private var mysound:Sound;
      
      private var _bgMusucVolumn:Number = 1;
      
      private var havesound:Boolean;
      
      private var battlesoundChannel:SoundChannel;
      
      private var url:String = URLUtil.getSvnVer("assets/sound/mySound.swf");
      
      public var battleBgMusicbool:Boolean = false;
      
      private var sounder:Loader;
      
      public function SoundManager()
      {
         super();
      }
      
      public static function get instance() : SoundManager
      {
         if(_instance == null)
         {
            _instance = new SoundManager();
         }
         return _instance;
      }
      
      public function playNomalMusic() : void
      {
         var obj:* = null;
         var mysound:* = null;
         var soundtransform:* = null;
         try
         {
            if(!this.havesound)
            {
               return;
            }
            if(!this.sounder)
            {
               return;
            }
            if(this.sounder.contentLoaderInfo.applicationDomain.hasDefinition("nomalMusic"))
            {
               obj = this.sounder.contentLoaderInfo.applicationDomain.getDefinition("nomalMusic");
               mysound = new obj();
               if(Boolean(this.battlesoundChannel))
               {
                  this.battlesoundChannel.stop();
                  this.battlesoundChannel = null;
               }
               this.battlesoundChannel = mysound.play();
               this.battleBgMusicbool = true;
               soundtransform = new SoundTransform();
               soundtransform.volume = this._bgMusucVolumn;
               this.battlesoundChannel.soundTransform = soundtransform;
               this.battlesoundChannel.addEventListener(Event.SOUND_COMPLETE,this.onNomalMusicComp);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onBossMusicComp(event:Event) : void
      {
         try
         {
            this.battlesoundChannel.removeEventListener(Event.SOUND_COMPLETE,this.onBossMusicComp);
            this.battlesoundChannel = null;
         }
         catch(e:Error)
         {
         }
         this.playBossMusic();
      }
      
      public function playBgMusic() : void
      {
         var obj:* = null;
         try
         {
            if(this.mysound != null)
            {
               this.mysound.close();
               this.mysound = null;
            }
            obj = this.sounder.contentLoaderInfo.applicationDomain.getDefinition("bgMusic");
            this.mysound = new obj();
            this.mysound.play(0,10000);
         }
         catch(e:Error)
         {
         }
      }
      
      public function iconClick(value:int) : Boolean
      {
         var soundtransform:SoundTransform = null;
         var obj:* = null;
         var mysound:* = null;
         var effecttran:* = null;
         value = value;
         if(value > 0 && value < 7)
         {
            if(!this.havesound || this.sounder == null)
            {
               return true;
            }
            obj = this.sounder.contentLoaderInfo.applicationDomain.getDefinition("iconClick" + value);
            mysound = new obj();
            effecttran = mysound.play();
            soundtransform = new SoundTransform();
            soundtransform.volume = this._effectMusicVolumn;
            if(effecttran)
            {
               effecttran.soundTransform = soundtransform;
            }
            return true;
         }
         return false;
      }
      
      private function onNomalMusicComp(event:Event) : void
      {
         this.battlesoundChannel.removeEventListener(Event.SOUND_COMPLETE,this.onNomalMusicComp);
         this.battlesoundChannel = null;
         this.playNomalMusic();
      }
      
      public function playBossMusic() : void
      {
         var obj:* = null;
         var mysound:* = null;
         var soundtransform:* = null;
         try
         {
            if(!this.havesound)
            {
               return;
            }
            if(!this.sounder)
            {
               return;
            }
            if(this.sounder.contentLoaderInfo.applicationDomain.hasDefinition("bossMusic"))
            {
               obj = this.sounder.contentLoaderInfo.applicationDomain.getDefinition("bossMusic");
               mysound = new obj();
               if(Boolean(this.battlesoundChannel))
               {
                  this.battlesoundChannel.stop();
                  this.battlesoundChannel = null;
               }
               this.battlesoundChannel = mysound.play();
               this.battleBgMusicbool = true;
               soundtransform = new SoundTransform();
               soundtransform.volume = this._bgMusucVolumn;
               this.battlesoundChannel.soundTransform = soundtransform;
               this.battlesoundChannel.addEventListener(Event.SOUND_COMPLETE,this.onBossMusicComp);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onSoundLoadComp(event:Event) : void
      {
         this.havesound = true;
      }
      
      public function magicAtk(value:int) : Boolean
      {
         var obj:* = null;
         var mysound:* = null;
         var effecttran:* = null;
         var soundtransform:* = null;
         value = value;
         if(value > 0 && value < 3)
         {
            if(!this.havesound || this.sounder == null)
            {
               return true;
            }
            if(this.sounder.contentLoaderInfo.applicationDomain.hasDefinition("magicAtk" + value))
            {
               obj = this.sounder.contentLoaderInfo.applicationDomain.getDefinition("magicAtk" + value);
               mysound = new obj();
               effecttran = mysound.play();
               soundtransform = new SoundTransform();
               soundtransform.volume = this._effectMusicVolumn;
               effecttran.soundTransform = soundtransform;
               return true;
            }
         }
         return false;
      }
      
      public function stopBattleMusic() : void
      {
         if(Boolean(this.battlesoundChannel))
         {
            this.battlesoundChannel.stop();
            this.battlesoundChannel.removeEventListener(Event.SOUND_COMPLETE,this.onNomalMusicComp);
            this.battlesoundChannel.removeEventListener(Event.SOUND_COMPLETE,this.onBossMusicComp);
         }
         this.battleBgMusicbool = false;
         this.battlesoundChannel = null;
      }
      
      public function loadersound() : void
      {
         if(this.battlesoundChannel == null)
         {
            this.battlesoundChannel = new SoundChannel();
         }
         if(this.sounder == null)
         {
            this.sounder = new Loader();
            this.sounder.load(new URLRequest(this.url));
            this.sounder.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onSoundLoadComp);
         }
      }
      
      public function playSound(value:String) : void
      {
         var obj:* = null;
         var mysound:* = null;
         var effecttran:* = null;
         var soundtransform:* = null;
         value = value;
         try
         {
            if(!this.havesound || !this.sounder)
            {
               return;
            }
            if(this.sounder.contentLoaderInfo.applicationDomain.hasDefinition(value))
            {
               obj = this.sounder.contentLoaderInfo.applicationDomain.getDefinition(value);
               mysound = new obj();
               effecttran = mysound.play();
               soundtransform = new SoundTransform();
               soundtransform.volume = this._effectMusicVolumn;
               effecttran.soundTransform = soundtransform;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function taskFinish() : void
      {
         var obj:* = null;
         var mysound:* = null;
         var effecttran:* = null;
         var soundtransform:* = null;
         try
         {
            if(!this.havesound || this.sounder == null)
            {
               return;
            }
            obj = this.sounder.contentLoaderInfo.applicationDomain.getDefinition("taskFinish");
            mysound = new obj();
            effecttran = mysound.play();
            soundtransform = new SoundTransform();
            soundtransform.volume = this._effectMusicVolumn;
            effecttran.soundTransform = soundtransform;
         }
         catch(e:Error)
         {
         }
      }
      
      public function get bgMusucVolumn() : Number
      {
         return this._bgMusucVolumn;
      }
      
      public function set bgMusucVolumn(value:Number) : void
      {
         this._bgMusucVolumn = value;
      }
      
      public function get effectMusicVolumn() : Number
      {
         return this._effectMusicVolumn;
      }
      
      public function set effectMusicVolumn(value:Number) : void
      {
         this._effectMusicVolumn = value;
      }
   }
}

