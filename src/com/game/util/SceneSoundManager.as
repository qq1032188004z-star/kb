package com.game.util
{
   import com.game.modules.view.FaceView;
   import com.publiccomponent.URLUtil;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import sound.SoundManager;
   
   public class SceneSoundManager
   {
      
      private static var instance:SceneSoundManager;
      
      private var _sound:Sound;
      
      private var _soundChannel:SoundChannel;
      
      private var _loader:Loader;
      
      private var soundname:String;
      
      private var _soundTrans:SoundTransform;
      
      public var playbattlesound:Boolean = false;
      
      private var _effectVolumn:Number;
      
      public var globalSound:int = 1;
      
      private var trans:SoundTransform;
      
      public function SceneSoundManager()
      {
         super();
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onSoundLoaded,false,0,true);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onSoundIoError,false,0,true);
      }
      
      public static function getInstance() : SceneSoundManager
      {
         if(instance == null)
         {
            instance = new SceneSoundManager();
         }
         return instance;
      }
      
      public function playSound(name:String) : void
      {
         if(name == null)
         {
            return;
         }
         if(name.length < 2)
         {
            this.soundname = name;
            this.stop();
            return;
         }
         if(this.soundname == name)
         {
            return;
         }
         this.soundname = name;
         this.stop();
         this._loader.unloadAndStop();
         var url:String = URLUtil.getSvnVer("assets/sound/" + name + ".swf");
         this._loader.load(new URLRequest(url));
      }
      
      private function onSoundLoaded(evt:Event) : void
      {
         var cls:Class = null;
         var domain:ApplicationDomain = evt.currentTarget.applicationDomain as ApplicationDomain;
         if(domain != null && !SoundManager.instance.battleBgMusicbool)
         {
            if(domain.hasDefinition("sceneSound"))
            {
               cls = domain.getDefinition("sceneSound") as Class;
               this.playDanceSound(new cls() as Sound);
            }
         }
         this._loader.unloadAndStop();
      }
      
      public function playDanceSound(sound:Sound) : void
      {
         try
         {
            if(Boolean(this._soundChannel))
            {
               this._soundChannel.stop();
            }
            if(!this.playbattlesound && Boolean(sound))
            {
               this.soundname = "";
               this._sound = sound;
               this._soundChannel = this._sound["play"](0,1000);
               this._soundChannel.soundTransform = this.soundTrans;
            }
         }
         catch(error:Error)
         {
         }
      }
      
      public function getSoundName() : String
      {
         return this.soundname;
      }
      
      public function playSceneMusic() : void
      {
         this.playSound(this.soundname);
      }
      
      private function onSoundIoError(event:IOErrorEvent) : void
      {
         O.o("场景声音加载失败啊");
      }
      
      public function stop() : void
      {
         if(Boolean(this._soundChannel))
         {
            this._soundChannel.stop();
         }
         if(Boolean(this._loader))
         {
            this._loader.unloadAndStop();
         }
      }
      
      public function pause() : void
      {
         if(Boolean(this._soundChannel))
         {
            this._soundChannel.stop();
         }
      }
      
      public function continuePlay() : void
      {
         var url:String = null;
         this.stop();
         this._loader.unloadAndStop();
         if(Boolean(this._sound))
         {
            this._soundChannel = this._sound.play(0,1000);
            this.setBgVolumn(SoundManager.instance.bgMusucVolumn);
         }
         else if(Boolean(this.soundname) && this.soundname.length > 2)
         {
            url = URLUtil.getSvnVer("assets/sound/" + this.soundname + ".swf");
            this._loader.load(new URLRequest(url));
         }
      }
      
      public function setBgVolumn(volumn:Number) : void
      {
         if(volumn > 1)
         {
            volumn = 1;
         }
         else if(volumn < 0)
         {
            volumn = 0;
         }
         this.soundTrans.volume = volumn;
         if(Boolean(this._soundChannel))
         {
            this._soundChannel.soundTransform = this.soundTrans;
         }
         SoundManager.instance.bgMusucVolumn = volumn;
      }
      
      public function getBgVolumn() : Number
      {
         if(Boolean(this._soundChannel))
         {
            return this._soundChannel.soundTransform.volume;
         }
         return 1;
      }
      
      public function set effectMusicVolumn(value:Number) : void
      {
         if(value > 1)
         {
            value = 1;
         }
         else if(value < 0)
         {
            value = 0;
         }
         this._effectVolumn = value;
         SoundManager.instance.effectMusicVolumn = value;
      }
      
      public function get effectMusicVolumn() : Number
      {
         return this._effectVolumn;
      }
      
      public function openSound(value:int = 1) : void
      {
         try
         {
            this.trans = SoundMixer.soundTransform;
            this.globalSound = value;
            FaceView.clip.topMiddleClip.voiceClip.gotoAndStop(1);
            this.trans.volume = 1;
            SoundMixer.soundTransform = this.trans;
         }
         catch(e:*)
         {
            O.o("【SceneSoundeManager——opensound】");
         }
      }
      
      public function closeSound(value:int = 0) : void
      {
         try
         {
            this.trans = SoundMixer.soundTransform;
            this.globalSound = value;
            FaceView.clip.topMiddleClip.voiceClip.gotoAndStop(2);
            this.trans.volume = 0;
            SoundMixer.soundTransform = this.trans;
         }
         catch(e:*)
         {
            O.o("【SceneSoundeManager——closesound】");
         }
      }
      
      public function get soundTrans() : SoundTransform
      {
         if(this._soundTrans == null)
         {
            this._soundTrans = new SoundTransform();
         }
         return this._soundTrans;
      }
   }
}

