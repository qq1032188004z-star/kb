package com.game.modules.view.battle.util
{
   import com.game.util.MovieClipUtil;
   import com.kb.util.Handler;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class FramedAnimation extends Sprite implements IFramedAnimation
   {
      
      private static var _mainFrameRate:int;
      
      public static const SOURCE_TYPE_MOVIE_CLIP:int = 1;
      
      public static const SOURCE_TYPE_BITMAP_MOVIE:int = 2;
      
      public static const SOURCE_TYPE_MIX_CLIP:int = 3;
      
      public static const SOURCE_TYPE_CLIP_FRAME:int = 4;
      
      public static const TYPE_BITMAP:int = 1;
      
      public static const TYPE_CLIP:int = 2;
      
      public static const TYPE_FRAME_CLIP:int = 3;
      
      public static const ANIMATION_COMPLETE:String = "animationComplete";
      
      public static const MY_EXIT_FRAME:String = "myExitFrame";
      
      public static var debug:Boolean = false;
      
      protected static var frameDataCache:Object = {};
      
      protected static var _playRate:Number = 1;
      
      public static var blankFrame:FrameItemData = new FrameItemData(new BitmapData(1,1,true,0),0,0,1,1,true);
      
      public var autoRegister:Boolean = true;
      
      protected var bitmap:Bitmap;
      
      protected var _clip:MovieClip;
      
      protected var aniType:int;
      
      protected var _updateFrameFN:Function;
      
      protected var _frames:Vector.<FrameItemData>;
      
      protected var _clipFrames:Vector.<ClipItemData>;
      
      protected var _sameFramesMark:Vector.<Boolean> = new Vector.<Boolean>();
      
      protected var _frameRate:int;
      
      protected var _play:Boolean = true;
      
      protected var playerFramesPerFrame:int;
      
      protected var playerFrameCount:int;
      
      protected var _totalFrames:int;
      
      protected var _currentFrame:int = 1;
      
      protected var _loopStartFrame:int = 1;
      
      protected var _loopCount:int = 1;
      
      protected var _curLoopCount:int;
      
      protected var _offsetX:Number;
      
      protected var _offsetY:Number;
      
      protected var _clipX:Number;
      
      protected var _clipY:Number;
      
      protected var _scaleX:Number = 1;
      
      protected var _scaleY:Number = 1;
      
      protected var _paused:Boolean;
      
      protected var _stopWhenComplete:Boolean;
      
      protected var aniChanged:Boolean;
      
      protected var frameHandlers:Object;
      
      protected var __curFrameData:FrameItemData;
      
      protected var __curClipData:ClipItemData;
      
      protected var _instancePlayRate:Number = 1;
      
      public function FramedAnimation()
      {
         super();
         mouseEnabled = mouseChildren = false;
         this.updateFrameFN = this.__updateFrameInvalid;
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,false,0,true);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved,false,0,true);
      }
      
      public static function set mainFrameRate(value:int) : void
      {
         _mainFrameRate = value;
      }
      
      public static function set playRate(value:Number) : void
      {
         _playRate = value;
         if(isNaN(_playRate))
         {
            _playRate = 1;
         }
      }
      
      public static function get playRate() : Number
      {
         return _playRate;
      }
      
      public static function createAnimationFromMoveClip(clip:MovieClip, sourceType:int = 1, scaleX:Number = 1, scaleY:Number = 1, cache:Boolean = false, flag:String = null, sameFrameMark:Vector.<Boolean> = null) : FramedAnimation
      {
         var framesData:Object = null;
         var ani:FramedAnimation = new FramedAnimation();
         if(sourceType == SOURCE_TYPE_MIX_CLIP)
         {
            clip.scaleX = scaleX;
            clip.scaleY = scaleY;
            ani.clip = clip;
         }
         else if(sourceType == SOURCE_TYPE_BITMAP_MOVIE)
         {
            framesData = createFramesFromBitmapMovie(clip,scaleX,scaleY,cache,flag,sameFrameMark);
            ani.frames = framesData["frames"];
         }
         else if(sourceType == SOURCE_TYPE_CLIP_FRAME)
         {
            framesData = createClipsFromMovieClip(clip);
            ani.clipFrames = framesData["clipFrames"];
         }
         else
         {
            framesData = createFramesFromMovieClip(clip,scaleX,scaleY,cache,flag,sameFrameMark);
            ani.frames = framesData["frames"];
         }
         return ani;
      }
      
      public static function createTypedAniFromClip(typeClass:Class, clip:MovieClip, sourceType:int = 1, scaleX:Number = 1, scaleY:Number = 1, cache:Boolean = false, flag:String = null, sameFrameMark:Vector.<Boolean> = null) : FramedAnimation
      {
         var framesData:Object = null;
         var ani:FramedAnimation = new typeClass() as FramedAnimation;
         if(sourceType == SOURCE_TYPE_MIX_CLIP)
         {
            clip.scaleX = scaleX;
            clip.scaleY = scaleY;
            ani.clip = clip;
         }
         else if(sourceType == SOURCE_TYPE_BITMAP_MOVIE)
         {
            framesData = createFramesFromBitmapMovie(clip,scaleX,scaleY,cache,flag,sameFrameMark);
            ani.frames = framesData["frames"];
         }
         else
         {
            framesData = createFramesFromMovieClip(clip,scaleX,scaleY,cache,flag,sameFrameMark);
            ani.frames = framesData["frames"];
         }
         return ani;
      }
      
      public static function createFramesFromMovieClip(clip:MovieClip, scaleX:Number = 1, scaleY:Number = 1, cache:Boolean = false, flag:String = null, sameFrameMark:Vector.<Boolean> = null) : Object
      {
         var L:int;
         var frames:Vector.<FrameItemData>;
         var matrix:Matrix;
         var frameData:Object = null;
         var i:int = 0;
         var frame:FrameItemData = null;
         var bounds:Rectangle = null;
         var bmpWidth:int = 0;
         var bmpHeight:int = 0;
         var bmpData:BitmapData = null;
         if(Boolean(flag))
         {
            frameData = frameDataCache[flag];
            if(Boolean(frameData))
            {
               return frameData;
            }
         }
         clip.stop();
         L = clip.totalFrames;
         frames = new Vector.<FrameItemData>(L,true);
         matrix = new Matrix();
         matrix.scale(scaleX,scaleY);
         for(i = 0; i < L; i++)
         {
            if(sameFrameMark == null || !sameFrameMark[i])
            {
               clip.gotoAndStop(i + 1);
               bounds = clip.getBounds(clip);
               bmpWidth = bounds.width * scaleX;
               bmpHeight = bounds.height * scaleY;
               if(bmpWidth > 0 && bmpHeight > 0 && bmpWidth < 1500 && bmpHeight < 1500)
               {
                  try
                  {
                     bmpData = new BitmapData(bmpWidth,bmpHeight,true,0);
                     frame = new FrameItemData(bmpData,int(bounds.left * scaleX),int(bounds.top * scaleY));
                     matrix.tx = -int(bounds.left * scaleX);
                     matrix.ty = -int(bounds.top * scaleY);
                     frame.bitmapData.draw(clip,matrix);
                  }
                  catch(error:Error)
                  {
                     frame = blankFrame;
                     if(debug)
                     {
                        throw new Error("clip:" + clip + " frame:" + (i + 1));
                     }
                  }
               }
               else
               {
                  frame = blankFrame;
               }
               frames[i] = frame;
               MovieClipUtil.stopMovieClip(clip);
            }
            else
            {
               frames[i] = frames[i - 1];
            }
         }
         frameData = {"frames":frames};
         if(cache && Boolean(flag))
         {
            frameDataCache[flag] = frameData;
         }
         MovieClipUtil.stopMovieClip(clip);
         return frameData;
      }
      
      public static function createFramesFromBitmapMovie(clip:MovieClip, scaleX:Number = 1, scaleY:Number = 1, cache:Boolean = false, flag:String = null, sameFrameMark:Vector.<Boolean> = null) : Object
      {
         var frameData:Object = null;
         var i:int = 0;
         var frame:FrameItemData = null;
         var bitmap:Bitmap = null;
         var matrix:Matrix = null;
         if(Boolean(flag))
         {
            frameData = frameDataCache[flag];
            if(Boolean(frameData))
            {
               return frameData;
            }
         }
         clip.stop();
         var L:int = clip.totalFrames;
         var frames:Vector.<FrameItemData> = new Vector.<FrameItemData>(L,true);
         for(i = 0; i < L; i++)
         {
            if(sameFrameMark == null || !sameFrameMark[i])
            {
               clip.gotoAndStop(i + 1);
               if(Boolean(clip.numChildren))
               {
                  bitmap = clip.getChildAt(0) as Bitmap;
               }
               else
               {
                  bitmap = null;
               }
               if(Boolean(bitmap))
               {
                  matrix = bitmap.transform.matrix;
                  frame = new FrameItemData(bitmap.bitmapData,bitmap.x,bitmap.y,matrix.a,matrix.d);
               }
               else
               {
                  frame = blankFrame;
               }
               frames[i] = frame;
               MovieClipUtil.stopMovieClip(clip);
            }
            else
            {
               frames[i] = frames[i - 1];
            }
         }
         frameData = {"frames":frames};
         if(cache && Boolean(flag))
         {
            frameDataCache[flag] = frameData;
         }
         MovieClipUtil.stopMovieClip(clip);
         return frameData;
      }
      
      public static function createClipsFromMovieClip(clip:MovieClip) : Object
      {
         var clipItem:ClipItemData = null;
         var j:int = 0;
         var L:int = clip.totalFrames;
         var clipFrames:Vector.<ClipItemData> = new Vector.<ClipItemData>(L,true);
         for(var i:int = L; i > 0; i--)
         {
            clip.gotoAndStop(i);
            clipItem = new ClipItemData();
            for(j = 0; j < clip.numChildren; j++)
            {
               clipItem.pushEle(clip.getChildAt(j));
            }
            clipFrames[i - 1] = clipItem;
         }
         return {"clipFrames":clipFrames};
      }
      
      public function set instancePlayRate(value:Number) : void
      {
         this._instancePlayRate = value;
         if(isNaN(this._instancePlayRate))
         {
            this._instancePlayRate = 1;
         }
         this.calcFrameRate();
      }
      
      public function get instancePlayRate() : Number
      {
         return this._instancePlayRate;
      }
      
      protected function onAddedToStage(event:Event) : void
      {
         this.calcFrameRate();
         if(this.autoRegister)
         {
            FramedAniMgr.registerFramedAni(this);
         }
      }
      
      protected function onRemoved(event:Event) : void
      {
         this.checkToSetFrameUpdateFN();
      }
      
      public function get frameRate() : int
      {
         return this._frameRate;
      }
      
      public function set frameRate(value:int) : void
      {
         if(value == this._frameRate)
         {
            return;
         }
         this._frameRate = value;
         this.calcFrameRate();
      }
      
      public function get totalFrames() : int
      {
         if(Boolean(this._clip))
         {
            return this._clip.totalFrames;
         }
         if(Boolean(this._frames))
         {
            return this._frames.length;
         }
         return 0;
      }
      
      public function get clipX() : Number
      {
         if(this.aniType == TYPE_BITMAP)
         {
            return x - this._offsetX * scaleX;
         }
         return x;
      }
      
      public function set clipX(value:Number) : void
      {
         this._clipX = value;
         if(this.aniType == TYPE_BITMAP)
         {
            x = this._clipX + this._offsetX * scaleX;
         }
         else
         {
            x = this._clipX;
         }
      }
      
      public function get clipY() : Number
      {
         if(this.aniType == TYPE_BITMAP)
         {
            return y - this._offsetY * scaleY;
         }
         return y;
      }
      
      public function set clipY(value:Number) : void
      {
         this._clipY = value;
         if(this.aniType == TYPE_BITMAP)
         {
            y = this._clipY + this._offsetY * scaleY;
         }
         else
         {
            y = this._clipY;
         }
      }
      
      protected function set offsetX(value:Number) : void
      {
         this._offsetX = value;
         x = this._clipX + this._offsetX * scaleX;
      }
      
      protected function set offsetY(value:Number) : void
      {
         this._offsetY = value;
         y = this._clipY + this._offsetY * scaleY;
      }
      
      override public function set scaleX(value:Number) : void
      {
         super.scaleX = value;
         this._scaleX = value;
         if(this.aniType == TYPE_BITMAP)
         {
            x = this._clipX + this._offsetX * this._scaleX;
         }
      }
      
      override public function set scaleY(value:Number) : void
      {
         super.scaleY = value;
         this._scaleY = value;
         if(this.aniType == TYPE_BITMAP)
         {
            y = this._clipY + this._offsetY * this._scaleY;
         }
      }
      
      public function set frames(value:Vector.<FrameItemData>) : void
      {
         if(value == null || value.length == 0)
         {
            throw new Error("invalid frames");
         }
         if(Boolean(this._clip))
         {
            if(Boolean(this._clip.parent))
            {
               removeChild(this._clip);
            }
            this._clip = null;
         }
         if(this.bitmap == null)
         {
            this.bitmap = new Bitmap();
         }
         if(this.bitmap.parent == null)
         {
            addChild(this.bitmap);
         }
         this.aniType = TYPE_BITMAP;
         this._frames = value;
         this.aniChanged = true;
         this.updateAniConfig();
      }
      
      public function get frames() : Vector.<FrameItemData>
      {
         return this._frames;
      }
      
      public function set clipFrames(value:Vector.<ClipItemData>) : void
      {
         this.aniType = TYPE_FRAME_CLIP;
         this._clipFrames = value;
         this.aniChanged = true;
         this.updateAniConfig();
      }
      
      public function set clip(value:MovieClip) : void
      {
         if(value == null)
         {
            throw new Error("invalid clip");
         }
         if(Boolean(this.bitmap) && Boolean(this.bitmap.parent))
         {
            removeChild(this.bitmap);
         }
         this.aniType = TYPE_CLIP;
         if(Boolean(this._clip) && Boolean(this._clip.parent))
         {
            removeChild(this._clip);
         }
         this._clip = value;
         this.aniChanged = true;
         addChild(this._clip);
         this.updateAniConfig();
      }
      
      private function updateAniConfig() : void
      {
         this._totalFrames = 0;
         if(this.aniType == TYPE_BITMAP)
         {
            if(Boolean(this._frames))
            {
               this._totalFrames = this._frames.length;
            }
         }
         else if(this.aniType == TYPE_CLIP)
         {
            if(Boolean(this._clip))
            {
               this._totalFrames = this._clip.totalFrames;
            }
         }
         else if(this.aniType == TYPE_FRAME_CLIP)
         {
            if(Boolean(this._clipFrames))
            {
               this._totalFrames = this._clipFrames.length;
            }
         }
         if(this._totalFrames > 0)
         {
            this._curLoopCount = 0;
            this.currentFrame = this._currentFrame;
            this.checkToSetFrameUpdateFN();
            this.loopStartFrame = this.loopStartFrame;
         }
      }
      
      public function set currentFrame(value:int) : void
      {
         var i:int = 0;
         this.playerFrameCount = 0;
         this._currentFrame = value;
         if(this._currentFrame > this._totalFrames)
         {
            this._currentFrame = this._totalFrames;
         }
         else if(this._currentFrame < 1)
         {
            this._currentFrame = 1;
         }
         if(this.aniType == TYPE_BITMAP)
         {
            this.__curFrameData = this._frames[this._currentFrame - 1];
            this.offsetX = this.__curFrameData.offsetX;
            this.offsetY = this.__curFrameData.offsetY;
            this.bitmap.bitmapData = this.__curFrameData.bitmapData;
            this.bitmap.scaleX = this.__curFrameData.scaleX;
            this.bitmap.scaleY = this.__curFrameData.scaleY;
         }
         else if(this.aniType == TYPE_FRAME_CLIP)
         {
            while(Boolean(numChildren))
            {
               removeChildAt(numChildren - 1);
            }
            this.__curClipData = this._clipFrames[this._currentFrame - 1];
            if(Boolean(this.__curClipData.count))
            {
               for(i = 0; i < this.__curClipData.count; i++)
               {
                  addChild(this.__curClipData.getEle(i));
               }
            }
         }
         else
         {
            this._clip.gotoAndStop(this._currentFrame);
         }
      }
      
      public function get currentFrame() : int
      {
         return this._currentFrame;
      }
      
      public function get currentMicroFrame() : int
      {
         return this.playerFrameCount;
      }
      
      public function set currentMicroFrame(value:int) : void
      {
         this.playerFrameCount = value;
      }
      
      public function set loopStartFrame(value:int) : void
      {
         if(value < 1)
         {
            value = 1;
         }
         else if(value > this._totalFrames)
         {
            value = this._totalFrames;
         }
         this._loopStartFrame = value;
      }
      
      public function get loopStartFrame() : int
      {
         return this._loopStartFrame;
      }
      
      public function set loopCount(value:int) : void
      {
         this._loopCount = value;
      }
      
      public function get loopCount() : int
      {
         return this._loopCount;
      }
      
      public function set bitmapData(value:BitmapData) : void
      {
         if(Boolean(this.bitmap))
         {
            this.bitmap.bitmapData = value;
         }
      }
      
      public function get bitmapData() : BitmapData
      {
         if(Boolean(this.bitmap) && Boolean(this.bitmap.parent))
         {
            return this.bitmap.bitmapData;
         }
         return null;
      }
      
      public function stop() : void
      {
         this._play = false;
         this.checkToSetFrameUpdateFN();
      }
      
      public function play() : void
      {
         this._play = true;
         this.checkToSetFrameUpdateFN();
      }
      
      public function pauseAnimation() : void
      {
         this._paused = true;
      }
      
      public function resumeAnimation() : void
      {
         this._paused = false;
      }
      
      public function get paused() : Boolean
      {
         return this._paused;
      }
      
      public function set stopWhenComplete(value:Boolean) : void
      {
         this._stopWhenComplete = value;
         if(this._stopWhenComplete)
         {
            this.addEventListener(ANIMATION_COMPLETE,this.onAniComplete,false,0,true);
         }
         else
         {
            removeEventListener(ANIMATION_COMPLETE,this.onAniComplete);
         }
      }
      
      public function get stopWhenComplete() : Boolean
      {
         return this._stopWhenComplete;
      }
      
      private function onAniComplete(event:Event) : void
      {
         this.stop();
      }
      
      public function get haveContent() : Boolean
      {
         return this._frames != null || this._clip != null;
      }
      
      public function setFrameHandler(frame:int, handler:Handler, removeAfterDispatch:Boolean = false) : void
      {
         var hasHandler:Boolean = false;
         var item:Object = null;
         if(Boolean(handler))
         {
            if(this.frameHandlers == null)
            {
               this.frameHandlers = {};
            }
            this.frameHandlers[frame] = {
               "handler":handler,
               "removeAfterDispatch":removeAfterDispatch
            };
         }
         else if(Boolean(this.frameHandlers))
         {
            delete this.frameHandlers[frame];
         }
         var _loc6_:int = 0;
         var _loc7_:* = this.frameHandlers;
         for each(item in _loc7_)
         {
            hasHandler = true;
         }
         if(!hasHandler)
         {
            this.frameHandlers = null;
         }
         this.checkToSetFrameUpdateFN();
      }
      
      protected function calcFrameRate() : void
      {
         var mainRate:int = 0;
         if(Boolean(stage) && Boolean(this._frameRate))
         {
            mainRate = int(_mainFrameRate || int(stage.frameRate));
            this.playerFramesPerFrame = Math.max(1,mainRate / this._frameRate / _playRate / this._instancePlayRate) - 1;
            this.checkToSetFrameUpdateFN();
         }
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         super.addEventListener(type,listener,useCapture,priority,useWeakReference);
         if(type == ANIMATION_COMPLETE || type == MY_EXIT_FRAME)
         {
            this.checkToSetFrameUpdateFN();
         }
      }
      
      protected function checkToSetFrameUpdateFN() : void
      {
         var fnPostfix:String = null;
         if(stage && this._frameRate && (this._frames && this._frames.length > 0 || this._clipFrames && this._clipFrames.length > 0 || this._clip) && this._play)
         {
            fnPostfix = "";
            if(hasEventListener(ANIMATION_COMPLETE))
            {
               fnPostfix += "C";
            }
            if(hasEventListener(MY_EXIT_FRAME))
            {
               fnPostfix += "E";
            }
            if(Boolean(this.frameHandlers))
            {
               fnPostfix += "H";
            }
            if(fnPostfix != "")
            {
               this.updateFrameFN = this["__updateFrame_dispatchEvent_" + fnPostfix];
            }
            else
            {
               this.updateFrameFN = this.__updateFrame;
            }
         }
         else
         {
            this.updateFrameFN = this.__updateFrameInvalid;
         }
      }
      
      protected function __updateFrame() : void
      {
         var i:int = 0;
         if(++this.playerFrameCount > this.playerFramesPerFrame)
         {
            this.playerFrameCount = 0;
            if(this._play)
            {
               if(++this._currentFrame > this._totalFrames)
               {
                  ++this._curLoopCount;
                  this._currentFrame = this._loopStartFrame;
               }
               if(this.aniType == TYPE_BITMAP)
               {
                  this.__curFrameData = this._frames[this._currentFrame - 1];
                  this.offsetX = this.__curFrameData.offsetX;
                  this.offsetY = this.__curFrameData.offsetY;
                  this.bitmap.bitmapData = this.__curFrameData.bitmapData;
                  this.bitmap.scaleX = this.__curFrameData.scaleX;
                  this.bitmap.scaleY = this.__curFrameData.scaleY;
               }
               else if(this.aniType == TYPE_FRAME_CLIP)
               {
                  while(Boolean(numChildren))
                  {
                     removeChildAt(numChildren - 1);
                  }
                  this.__curClipData = this._clipFrames[this._currentFrame - 1];
                  if(Boolean(this.__curClipData.count))
                  {
                     for(i = 0; i < this.__curClipData.count; i++)
                     {
                        addChild(this.__curClipData.getEle(i));
                     }
                  }
               }
               else
               {
                  this._clip.gotoAndStop(this._currentFrame);
               }
            }
         }
      }
      
      protected function __updateFrame_dispatchEvent_C() : void
      {
         this.aniChanged = false;
         if(++this.playerFrameCount > this.playerFramesPerFrame)
         {
            this.playerFrameCount = 0;
            if(this._currentFrame == this._totalFrames)
            {
               if(++this._curLoopCount >= this._loopCount)
               {
                  dispatchEvent(new Event(ANIMATION_COMPLETE));
               }
            }
            if(this._play && !this.aniChanged)
            {
               if(++this._currentFrame > this._totalFrames)
               {
                  this._currentFrame = this._loopStartFrame;
               }
               if(this.aniType == TYPE_BITMAP)
               {
                  this.__curFrameData = this._frames[this._currentFrame - 1];
                  this.offsetX = this.__curFrameData.offsetX;
                  this.offsetY = this.__curFrameData.offsetY;
                  this.bitmap.bitmapData = this.__curFrameData.bitmapData;
                  this.bitmap.scaleX = this.__curFrameData.scaleX;
                  this.bitmap.scaleY = this.__curFrameData.scaleY;
               }
               else
               {
                  this._clip.gotoAndStop(this._currentFrame);
               }
            }
         }
      }
      
      protected function __updateFrame_dispatchEvent_E() : void
      {
         if(++this.playerFrameCount > this.playerFramesPerFrame)
         {
            this.playerFrameCount = 0;
            dispatchEvent(new Event(MY_EXIT_FRAME));
            if(this._play)
            {
               if(++this._currentFrame > this._totalFrames)
               {
                  ++this._curLoopCount;
                  this._currentFrame = this._loopStartFrame;
               }
               if(this.aniType == TYPE_BITMAP)
               {
                  this.__curFrameData = this._frames[this._currentFrame - 1];
                  this.offsetX = this.__curFrameData.offsetX;
                  this.offsetY = this.__curFrameData.offsetY;
                  this.bitmap.bitmapData = this.__curFrameData.bitmapData;
                  this.bitmap.scaleX = this.__curFrameData.scaleX;
                  this.bitmap.scaleY = this.__curFrameData.scaleY;
               }
               else
               {
                  this._clip.gotoAndStop(this._currentFrame);
               }
            }
         }
      }
      
      protected function __updateFrame_dispatchEvent_H() : void
      {
         var handlerData:Object = null;
         if(++this.playerFrameCount > this.playerFramesPerFrame)
         {
            this.playerFrameCount = 0;
            if(this._play)
            {
               if(++this._currentFrame > this._totalFrames)
               {
                  ++this._curLoopCount;
                  this._currentFrame = this._loopStartFrame;
               }
               if(Boolean(this.frameHandlers))
               {
                  handlerData = this.frameHandlers[this._currentFrame];
                  if(Boolean(handlerData))
                  {
                     (handlerData["handler"] as Handler).dispatch(this._currentFrame);
                     if(Boolean(handlerData["removeAfterDispatch"]))
                     {
                        this.setFrameHandler(this._currentFrame,null);
                     }
                  }
               }
               if(this.aniType == TYPE_BITMAP)
               {
                  this.__curFrameData = this._frames[this._currentFrame - 1];
                  this.offsetX = this.__curFrameData.offsetX;
                  this.offsetY = this.__curFrameData.offsetY;
                  this.bitmap.bitmapData = this.__curFrameData.bitmapData;
                  this.bitmap.scaleX = this.__curFrameData.scaleX;
                  this.bitmap.scaleY = this.__curFrameData.scaleY;
               }
               else
               {
                  this._clip.gotoAndStop(this._currentFrame);
               }
            }
         }
      }
      
      protected function __updateFrame_dispatchEvent_CE() : void
      {
         this.aniChanged = false;
         if(++this.playerFrameCount > this.playerFramesPerFrame)
         {
            this.playerFrameCount = 0;
            dispatchEvent(new Event(MY_EXIT_FRAME));
            if(this._currentFrame == this._totalFrames)
            {
               if(++this._curLoopCount >= this._loopCount)
               {
                  dispatchEvent(new Event(ANIMATION_COMPLETE));
               }
            }
            if(this._play && !this.aniChanged)
            {
               if(++this._currentFrame > this._totalFrames)
               {
                  this._currentFrame = this._loopStartFrame;
               }
               if(this.aniType == TYPE_BITMAP)
               {
                  this.__curFrameData = this._frames[this._currentFrame - 1];
                  this.offsetX = this.__curFrameData.offsetX;
                  this.offsetY = this.__curFrameData.offsetY;
                  this.bitmap.bitmapData = this.__curFrameData.bitmapData;
                  this.bitmap.scaleX = this.__curFrameData.scaleX;
                  this.bitmap.scaleY = this.__curFrameData.scaleY;
               }
               else
               {
                  this._clip.gotoAndStop(this._currentFrame);
               }
            }
         }
      }
      
      protected function __updateFrame_dispatchEvent_CH() : void
      {
         var handlerData:Object = null;
         this.aniChanged = false;
         if(++this.playerFrameCount > this.playerFramesPerFrame)
         {
            this.playerFrameCount = 0;
            if(this._currentFrame == this._totalFrames)
            {
               if(++this._curLoopCount >= this._loopCount)
               {
                  dispatchEvent(new Event(ANIMATION_COMPLETE));
               }
            }
            if(this._play && !this.aniChanged)
            {
               if(++this._currentFrame > this._totalFrames)
               {
                  this._currentFrame = this._loopStartFrame;
               }
               if(Boolean(this.frameHandlers))
               {
                  handlerData = this.frameHandlers[this._currentFrame];
                  if(Boolean(handlerData))
                  {
                     (handlerData["handler"] as Handler).dispatch(this._currentFrame);
                     if(Boolean(handlerData["removeAfterDispatch"]))
                     {
                        this.setFrameHandler(this._currentFrame,null);
                     }
                  }
               }
               if(this.aniType == TYPE_BITMAP)
               {
                  this.__curFrameData = this._frames[this._currentFrame - 1];
                  this.offsetX = this.__curFrameData.offsetX;
                  this.offsetY = this.__curFrameData.offsetY;
                  this.bitmap.bitmapData = this.__curFrameData.bitmapData;
                  this.bitmap.scaleX = this.__curFrameData.scaleX;
                  this.bitmap.scaleY = this.__curFrameData.scaleY;
               }
               else
               {
                  this._clip.gotoAndStop(this._currentFrame);
               }
            }
         }
      }
      
      protected function __updateFrame_dispatchEvent_EH() : void
      {
         var handlerData:Object = null;
         if(++this.playerFrameCount > this.playerFramesPerFrame)
         {
            this.playerFrameCount = 0;
            dispatchEvent(new Event(MY_EXIT_FRAME));
            if(this._play)
            {
               if(++this._currentFrame > this._totalFrames)
               {
                  ++this._curLoopCount;
                  this._currentFrame = this._loopStartFrame;
               }
               if(Boolean(this.frameHandlers))
               {
                  handlerData = this.frameHandlers[this._currentFrame];
                  if(Boolean(handlerData))
                  {
                     (handlerData["handler"] as Handler).dispatch(this._currentFrame);
                     if(Boolean(handlerData["removeAfterDispatch"]))
                     {
                        this.setFrameHandler(this._currentFrame,null);
                     }
                  }
               }
               if(this.aniType == TYPE_BITMAP)
               {
                  this.__curFrameData = this._frames[this._currentFrame - 1];
                  this.offsetX = this.__curFrameData.offsetX;
                  this.offsetY = this.__curFrameData.offsetY;
                  this.bitmap.bitmapData = this.__curFrameData.bitmapData;
                  this.bitmap.scaleX = this.__curFrameData.scaleX;
                  this.bitmap.scaleY = this.__curFrameData.scaleY;
               }
               else
               {
                  this._clip.gotoAndStop(this._currentFrame);
               }
            }
         }
      }
      
      protected function __updateFrame_dispatchEvent_CEH() : void
      {
         var handlerData:Object = null;
         this.aniChanged = false;
         if(++this.playerFrameCount > this.playerFramesPerFrame)
         {
            this.playerFrameCount = 0;
            dispatchEvent(new Event(MY_EXIT_FRAME));
            if(this._currentFrame == this._totalFrames)
            {
               if(++this._curLoopCount >= this._loopCount)
               {
                  dispatchEvent(new Event(ANIMATION_COMPLETE));
               }
            }
            if(this._play && !this.aniChanged)
            {
               if(++this._currentFrame > this._totalFrames)
               {
                  this._currentFrame = this._loopStartFrame;
               }
               if(Boolean(this.frameHandlers))
               {
                  handlerData = this.frameHandlers[this._currentFrame];
                  if(Boolean(handlerData))
                  {
                     (handlerData["handler"] as Handler).dispatch(this._currentFrame);
                     if(Boolean(handlerData["removeAfterDispatch"]))
                     {
                        this.setFrameHandler(this._currentFrame,null);
                     }
                  }
               }
               if(this.aniType == TYPE_BITMAP)
               {
                  this.__curFrameData = this._frames[this._currentFrame - 1];
                  this.offsetX = this.__curFrameData.offsetX;
                  this.offsetY = this.__curFrameData.offsetY;
                  this.bitmap.bitmapData = this.__curFrameData.bitmapData;
                  this.bitmap.scaleX = this.__curFrameData.scaleX;
                  this.bitmap.scaleY = this.__curFrameData.scaleY;
               }
               else
               {
                  this._clip.gotoAndStop(this._currentFrame);
               }
            }
         }
      }
      
      protected function __updateFrameInvalid() : void
      {
      }
      
      public function set updateFrameFN(value:Function) : void
      {
         this._updateFrameFN = value;
      }
      
      public function get updateFrameFN() : Function
      {
         return this._updateFrameFN;
      }
   }
}

