# Orion.as

Orion is an all around simple and flexible particle generator. I created Orion in order to have an easy method of creating and controlling particle effects. Orion is very fast and can handle thousands of particles and still keep frame rates high. It's also very small weighing in at around 5.5kb.

## Add Filters

It is also very modular and flexible. It was built with the filter mentality in mind. It comes bundled with a set of effect filters to alter how the particles act. For example, there is a GravityFilter, WindFilter, FadeFilter, etc. You can mix and match whatever filters you want to achieve the effect you're looking for. Of course as you add more filters it can affect performance so don't get upset when you add 50 filters and it's not maintaining 50fps.

In addition to being able to combine filters you can easily create your own filters if you feel like you are lacking the correct look you're going for. For now you can reference the GravityFilter for a simple example, I plan on having a proper example later.

## Control Output

You can also control how and when particles will be emitted. Orion comes bundled with a BurstOutput, FunctionOutput, KeyDownOutput, TimedOutput, and a SteadyOutput. use the explorer below to experiment what each one can do for you. More often than not, you'll be using SteadyOutput to keep a constant stream of particles going. Without an output class set, the default is to emit one particle every frame.

## Control how it's Rendered

The default method of displaying particles is using the display list built into Flash. But to enable some interesting bitmap effects you might want to turn to the BitmapRenderer. What this class does is draw all the particles to a bitmap which sometimes increase performance and allow for bitmap effects. Such as blur trails or glow effects etc.

## Choose to fit your needs

There are 4 types of Orion to choose from. You can use the base class, or the Bitmap, Container or Mouse version.

OrionBitmap allows you to emit particles at a specific color based on a snapshot of whatever display object you desire. An example would be, you want particles to only emit on red dots in your UI, using OrionBitmap you could do just that.

OrionContainer gives you the ability to take a MovieClip and turn any child assets into particles. This could be used to animate explosions of a MovieClip in a very simple and unique way.

OrionMouse is in essence a mouse trailer. It will emit particles wherever the mouse is and even only when the mouse is moving.

All versions of Orion can use any of the output classes, filters or renderers. So the sky is really the limit of what you can achieve using Orion for your particle effects.

## Explorer

[View Explorer](/bin/OrionExplorer.swf)

## Demos

All source code for these demos is included with the download.

-   [Animation Demo](/bin/Demo.swf)
-   [Rocket Demo](/bin/Rocket.swf)
-   [Targets Test](/bin/TargetsTest.swf)
-   [Collision Test](/bin/Collision%20Test.swf)
-   [Tween Test](/bin/TweenTest.swf)
-   [Speed Test](/bin/Speedtest.swf)

## Flash / HTML (Canvas) Benchmark

With the canvas being a bit more prevalent and wanting to learn more about this HTML5 thing I decided to port Orion (one of my favorite projects) into JavaScript. I was curious to see the perfomance difference between the Flash Player and the (currently) fastest browser Google Chrome.

Now, I'm no JS expert so please let me know if there are any optimizations I could make but the logic is pretty sound in Flash. Keep in mind I don't care how fast the page loads up, just how fast it performs afterward.

I also have it separated into two pages to keep the browsers from crashing or taking up too much memory. Also, to prevent crashing both demos auto throttle. As long as they can stay above 29fps they'll add more particles. If not, it'll throttle down and remove particles. This is checked every 3 seconds.

Below is the current test results I've experienced on my computer here at work. Just from what I've been able to experience, the Flash Player performs about 600% faster than Google Chrome. Which makes me wonder when HTML will be able to replace Flash in the interactive realm.

Also something to note, is the memory usage (which you can see in Chrome) is about the same in Canvas or Flash. Which leads me to believe that if people are complaining about performance in Flash now. Wait till people try to do the same thing in JavaScript. Same memory usage, same CPU usage, just slower.

Here are the specs for my work computer as a reference (2009):

```
MS Windows XP Professional 32-bit SP3
Intel Core 2 Duo E6550  @ 2.33GHz
2.0GB Dual-Channel DDR2 @ 332MHz
256MB ATI Radeon HD 2400 Pro (Dell)
78GB Western Digital WDC WD800ADFS-75SLR2 (IDE)
```

Here are the specs for my work computer as a reference (2017):

```
MS Windows 10 Professional 64-bit
Intel Core i7-4790K @ 4.00GHz
32.0GB DDR3 @ 332MHz
2GB NVidia GeForce GTX 960
250GB Samsung 840 EVO (SATAIII)
```

| Browser                   | Year | Particles (P) | Particles Added Per Render (PPR) |
| ------------------------- | ---- | ------------- | -------------------------------- |
| Firefox 3.6.4             | 2009 | 14,000        | 600                              |
| Chrome 6.0.427.0          | 2009 | 50,000        | 2,100                            |
| Opera 10.60 Beta          | 2009 | 50,000        | 2,100                            |
| Chrome 56.0.2924.87       | 2017 | 685,000       | 26,200                           |
| Flash 10.0.45.2           | 2009 | 260,000       | 11,000                           |
| Flash 10.0.45.2 Debugger  | 2009 | 150,000       | 6,400                            |
| Flash 10.1.53.64          | 2009 | 270,000       | 11,500                           |
| Flash 10.1.53.64 Debugger | 2009 | 225,000       | 9,500                            |
| Flash 24.0.0.194          | 2017 | 1,025,000     | 42,100                           |

_\* All results tested with a minimum FPS of 29_

HTML (Canvas) Particle Speed Test | Flash (Bitmap) Particle Speed Test

## Flash / HTML (DOM) Benchmark

This comparison is very similar to the Flash/Canvas comparison with a minor change. The first Flash demo utilizes BitmapData to render the particles. Much like Canvas renders directly to a bitmap array. But I wanted to compare the speed versus HTML (animating with elements) and a Bitmap demo isn't a fair comparison. So I have a second Flash demo that animated with Sprites. As with the previous demos, the particles are 1x1px white boxes to keep the look the same. Another small change in these demos is that they increment by 10s instead of 100s. This is because it's much more intensive to animate a sprite over a single pixel that really only exists when it's finally drawn on the bitmap. Also in an effort to let you see what the you can do with each, I've added controls to manipulate the minimum FPS. This will affect when the demos actually begin to throttle back.
| Browser | Year | Particles (P) | Particles Added Per Render (PPR) |
|---------------------------|------|---------------|----------------------------------|
| Firefox 3.6.4 | 2009 | 400 | 20 |
| Chrome 6.0.437.1 | 2009 | 800 | 30 |
| Opera 10.60 Beta | 2009 | 800 | 30 |
| Chrome 56.0.2924.87 | 2017 | 2,240 | 80 |
| Flash 10.0.45.2 | 2009 | 6,000 | 220 |
| Flash 10.0.45.2 Debugger | 2009 | 5,000 | 180 |
| Flash 10.1.53.64 | 2009 | 7,500 | 270 |
| Flash 10.1.53.64 Debugger | 2009 | 6,500 | 230 |

_\* All results tested with a minimum FPS of 29_

## Orion 2.0 Preview

[Orion 1.0](/bin/SpeedTest_1.0.swf)
[Orion 2.0](/bin/SpeedTest_2.0.swf)

## Usage

The quickest way to use Orion is listed below. This will get Orion on the stage, using an asset from the library and outputting particles.

```actionscript
import cv.Orion;

var e:Orion = new Orion(LibraryAssetID, null, {settings:{lifeSpan:500, velocityXMin:-50, velocityXMax:50, velocityYMin:-50, velocityYMax:50}}, true);
e.x = 275;
e.y = 250;
this.addChild(e);
```

## Documentation

[View Orion 1.0 ASDocs](/doc/)
