import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//libraries for twitter stream
import twitter4j.conf.*; 
import twitter4j.auth.*; 
import twitter4j.api.*; 
import twitter4j.util.*; 
import twitter4j.*; 
import java.util.*;

import http.requests.*;

import com.hamoid.*;
VideoExport videoExport;

Minim m;
AudioPlayer[] player;

Minim         minim;
Sampler[] notes;

AudioOutput   out;
AudioRecorder recorder;

int audioFiles;

//twitter stream object
TwitterStream twitterStream;
boolean streamOpen = false;
boolean streamUnopened = true;

//where tweets are all stored
StringList tweets;

ArrayList<Flower> flowergroup = new ArrayList<Flower>();

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

  frameRate(60);
  
  //videoExport = new VideoExport(this, "SydSpring.mp4");
  //videoExport.setQuality(98, 128);
  //videoExport.startMovie();

  openTwitterStream();


  orientation(LANDSCAPE);

  minim = new Minim(this);

  out = minim.getLineOut();

  //// create a recorder that will record from the output to the filename specified
  //// the file will be located in the sketch's root folder.

  audioFiles = 16;
  notes = new Sampler[audioFiles];

  for (int i = 0; i < audioFiles; i ++) {
    notes[i] = new Sampler( i + ".mp3", 4, minim );
  };

  recorder = minim.createRecorder(out, dataPath("myrecording.wav"), true);




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
    //school.addFish(new Fish(random(0, width), random(0, height), t, 100));
    flowergroup.add(new Flower(width/2 + random(-400, 400), height/2 + random(-100, 100), t, followerRatio, statusesCount, sentiment, int(flowerStyle)));
    newTweet = false;
  }

  resetShader();
  //videoExport.saveFrame();
}

int hsluvToRgb(float h, float s, float l) {
  double [] c = {h, s, l};
  c = HUSLColorConverter.hsluvToRgb(c);
  return color((float)c[0]*255, (float)c[1]*255, (float)c[2]*255);
}


void keyReleased()
{
  if ( key == 'r' ) 
  {
    // to indicate that you want to start or stop capturing audio data, you must call
    // beginRecord() and endRecord() on the AudioRecorder object. You can start and stop
    // as many times as you like, the audio data will be appended to the end of the buffer 
    // (in the case of buffered recording) or to the end of the file (in the case of streamed recording). 
    if ( recorder.isRecording() ) 
    {
      recorder.endRecord();
    } else 
    {
      recorder.beginRecord();
    }
  }
  if ( key == 's' )
  {
    // we've filled the file out buffer, 
    // now write it to the file we specified in createRecorder
    // in the case of buffered recording, if the buffer is large, 
    // this will appear to freeze the sketch for sometime
    // in the case of streamed recording, 
    // it will not freeze as the data is already in the file and all that is being done
    // is closing the file.
    // the method returns the recorded audio as an AudioRecording, 
    // see the example  AudioRecorder >> RecordAndPlayback for more about that
    recorder.save();
    println("Done saving.");
  }
}

void keyPressed() {
  if (key == 'q') {
    //videoExport.endMovie();
    exit();
  }
}
