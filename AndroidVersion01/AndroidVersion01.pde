//libraries for twitter stream
import twitter4j.conf.*; 
import twitter4j.auth.*; 
import twitter4j.api.*; 
import twitter4j.util.*; 
import twitter4j.*; 
import java.util.*;

import http.requests.*;

//music for android only

import android.media.SoundPool;
import android.media.AudioManager;
import android.content.res.AssetFileDescriptor;
import android.content.Context;
import android.app.Activity;


SoundPool sp; // 
Context context; // these two objects determine the file access path to the sound files
Activity act;
AssetFileDescriptor[] afd; // 4 file path descriptors
int[] sound; // IDs for the sounds to handle in the soundpool
int audioFiles;
//int trigger;

import android.view.MotionEvent;
import ketai.ui.*;
import ketai.sensors.*;

double longitude, latitude;
KetaiLocation location;
KetaiGesture gesture;




//twitter stream object
TwitterStream twitterStream;
boolean streamOpen = false;
boolean streamUnopened = true;

//where tweets are all stored
StringList tweets;

ArrayList<Flower> flowergroup = new ArrayList<Flower>();

//ArrayList<Ripple> ripple = new ArrayList<Ripple>();

//School school;

boolean newTweet = false;

//Shaders
PShader tex;
PShader bg;

//background graphic
PGraphics pg;


//float sentimentValue;
FloatList sentiments;
FloatList ratio;
FloatList statuses;

float xoff = 0.0;
float flowerStyle = 1;

int monthCol = month();



void setup() {
  
  fullScreen(P2D);
  orientation(LANDSCAPE);

  gesture = new KetaiGesture(this);

  ////android only sounds
  act = this.getActivity();
  context = act.getApplicationContext();
  sp = new SoundPool(12, AudioManager.STREAM_MUSIC, 0);
  act.setVolumeControlStream(AudioManager.STREAM_MUSIC);
  audioFiles = 16;
  sound = new int[audioFiles];
  afd = new AssetFileDescriptor[audioFiles];
  try {
    for (int i = 0; i < audioFiles; i ++) {
      afd[i] = context.getAssets().openFd(i + ".mp3");
      sound[i] = sp.load(afd[i], 1);
    }
  }
  catch(IOException e) {
  }

  location = new KetaiLocation(this);
  //1-milis before update 2-metres until update
  location.setUpdateRate(10000000, 100);

  pg = createGraphics(width, height, P2D);
  tex = loadShader("texfrag.glsl");

  tweets = new StringList();

  sentiments = new FloatList();
  ratio = new FloatList();
  statuses = new FloatList();

  colorMode(RGB, 255, 255, 255, 150);

}


void draw() {
  background(0);

  tex.set("time", (float) millis()/1000.0);
  tex.set("resolution", float(pg.width), float(pg.height));

  shader(tex);

  flowerStyle += 0.0005;

  if (flowerStyle > 5) {
    flowerStyle = 1;
  }


  for (Iterator<Flower> iter = flowergroup.iterator(); iter.hasNext(); ) {
    Flower f = iter.next();
    f.show();
    f.update();
    f.sound();
    f.bunching(flowergroup);
    if (f.isGrowing() == true && f.isDying() == false) {
      f.grow();
    }

    if (f.isDying() == true) {
      f.fadeOut();
    }

    if (f.isDead()) {
      iter.remove();
    }

    int maxFlowers = 12;

    for (int j = flowergroup.size(); j >= 0; j--) {
      if (j > maxFlowers) {
        int flowersOver = int(j - maxFlowers);
        Flower first = flowergroup.get(flowersOver -1);
        first.fadeOut();
      }
    }
  }

  if (newTweet) {
    String t = tweets.get(tweets.size() -1);
    //println(t);
    float sentiment = sentiments.get(sentiments.size() -1);
    float followerRatio = ratio.get(ratio.size() -1);
    float statusesCount = statuses.get(statuses.size() -1);
    flowergroup.add(new Flower(width/2 + random(-400, 400), height/2 + random(-100, 100), t, followerRatio, statusesCount, sentiment, int(flowerStyle)));
    newTweet = false;
  }

  resetShader();
}

int hsluvToRgb(float h, float s, float l) {
  double [] c = {h, s, l};
  c = HUSLColorConverter.hsluvToRgb(c);
  return color((float)c[0]*255, (float)c[1]*255, (float)c[2]*255);
}
