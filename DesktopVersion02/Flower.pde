
class Flower {
  //101 Movement Variables
  PVector pos;
  PVector vel;
  PVector acc;
  float size;
  float r;

  float radius;
  float maxforce;
  float maxspeed;

  //201 PShapes
  PShape flower = createShape(GROUP);
  PShape flowerAlt = createShape(GROUP);
  PShape flowerSound = createShape(GROUP);

  PShape[] fPetal;
  PShape[] fPetalAlt;
  PShape flowerT2;
  PShape flowerT2Alt;

  //202 Changing Variables
  //Data In
  String tweet;
  float sentiment;
  float ratio;
  float statuses;
  color[] colors;
  int col;
  color secondary;

  float sHue, sSat, sLit, cHue, cSat, cLit;

  //Data Out
  int petals;
  int petalsAlt;

  String season;
  float minSize = 90;


  //301 Death, Growth and Life
  float healthMeter = 100;
  float timeSinceSpawn = 0;

  float theta = random(-0.001, 0.001);  

  float scaleUp = 1.01;
  float easeUp = 0.003;

  float scaleDown = 0.99999;
  float easeDown = 0.000005;

  boolean flowerDeath = false;
  boolean flowerIsDying = false;



  //401 Sounds
  int chordTrigger;
  int melodyTrigger;
  int visualTrigger;
  int chordInts = 3;
  int melodyInts = 15;

  //chord notes are 0-7 melody is 8-15
  int chordNote;
  int melodyNote;

  boolean triggered = false;
  // one beat every chordInt, the notes play every 4 beats indicated by interval -1 for interval
  int chordIntTime = 4000;
  int melodyIntTime = 1000;


  //403 Sound Visuals
  float alpha;
  float aStart = 10;
  float aInc = 0.2;



  Flower(float x, float y, String _tweet, float _followerRatio, float _statusCount, float _sentiment, int _flowerStyle) {

    //202 Changing Variables
    tweet = _tweet;
    sentiment = _sentiment;
    ratio = _followerRatio;
    statuses = _statusCount;

    //101 Movement Variables
    this.pos = new PVector(x, y);
    this.acc = new PVector();
    this.vel = new PVector();

    //this.size initializes the circle size while radius dynamically changes adjusts seperation
    this.size = map(tweet.length(), 0, 280, minSize + 10, 400);
    r = map(tweet.length(), 0, 280, minSize + 10, 400) * 0.035 * 2.1;


    this.maxspeed = 0.6;
    this.maxforce = 0.05;

    //401 sounds
    chordTrigger = int(millis()/chordIntTime - 1);
    melodyTrigger = int(millis()/melodyIntTime - 1);
    visualTrigger = 0;

    switch(int(sentiment)) {
    case 0:
      chordNote = int(0);
      melodyNote = int(8);

      break;
    case 1:
      chordNote = int(random(0, 2));
      melodyNote = int(random(8, 10));

      break;
    case 2:
      chordNote = int(random(2, 5));
      melodyNote = int(random(10, 13));
      break;
    case 3:
      chordNote = int(random(5, 7));
      melodyNote = int(random(13, 15));
      break;
    case 4:
      chordNote = int(7);
      melodyNote = int(15);

      break;
    default:
      chordNote = int(7);
      break;
    }

    //402 Sound Visuals
    alpha = aStart;



    //201 PShapes


    flowerT2 = new PShape();
    flowerT2Alt = new PShape();

    int flowerStyle = _flowerStyle;

    if (flowerStyle == 1) {
      //FLOWER 1

      float petalLength = random(1.2, 1.95);
      float sizeAdj = map(petalLength, 1.2, 1.95, 0.15, 0.1);
      float altSizeAdj = map(petalLength, 1.2, 1.95, 0.9, 0.63);

      for (int c = 0; c < 7; c++) {
        flowerT2 = createShape();
        flowerT2.scale(0.035);
        flowerT2.beginShape();
        for (int b = 0; b < 100; b++) {
          float radius = this.size * random(1, petalLength);
          float fXAlt = cos(radians(b * 3.6)) * radius * sizeAdj * c;
          float fYAlt = sin(radians(b * 3.6)) * radius * sizeAdj * c;
          flowerT2.vertex(fXAlt, fYAlt);
        }
        flowerT2.endShape();
        flower.addChild(flowerT2);
      }

      for (int c = 0; c < 2; c++) {
        flowerT2Alt = createShape();
        flowerT2Alt.scale(0.035);
        flowerT2Alt.beginShape();
        for (int b = 0; b < 100; b++) {
          float radius = this.size * random(1, petalLength);
          float fXAlt = cos(radians(b * 3.6)) * radius * altSizeAdj * c;
          float fYAlt = sin(radians(b * 3.6)) * radius * altSizeAdj * c;
          flowerT2Alt.vertex(fXAlt, fYAlt);
        }
        flowerT2Alt.endShape();
        flowerAlt.addChild(flowerT2Alt);
      }


      //END FLOWER 1
    } else 
    if (flowerStyle == 2) 
    {
      //START FLOWER 2

      petals = int(map(sentiment, 0, 4, 5, 6));
      petalsAlt = int(map(sentiment, 0, 4, 6, 8));
      fPetal = new PShape[petals];
      fPetalAlt = new PShape[petalsAlt];

      for (int i = 0; i < fPetal.length; i++) {
        int vertices = 5;
        float spacing = 360 / vertices;
        pushMatrix();
        fPetal[i] = createShape();
        fPetal[i].translate(0, this.size/2 * 1);
        fPetal[i].scale(0.035);
        fPetal[i].beginShape();
        for (int a = 0; a < vertices + 1; a++) {
          float radius = this.size/2;
          float angle = a * spacing;
          float fX = cos(radians(angle)) * radius;
          float fY = sin(radians(angle)) * radius;
          if (a == 0) {
            fPetal[i].vertex(fX, fY);
          } else {
            float cAngle = angle - spacing/2;
            float cX = cos(radians(cAngle)) * radius;
            float cY = sin(radians(cAngle)) * (radius + random(0, size/3));
            fPetal[i].quadraticVertex(cX, cY, fX, fY);
          }
        }
        fPetal[i].endShape(CLOSE);
        fPetal[i].rotate(map(i, 0, fPetal.length, 0, TWO_PI));
        popMatrix();
        flower.addChild(fPetal[i]);
      }

      for (int i = 0; i < fPetal.length; i++) {
        int vertices = 5;
        float spacing = 360 / vertices;
        pushMatrix();
        fPetalAlt[i] = createShape();
        fPetalAlt[i].translate(0, this.size/2 * 1.2);
        fPetalAlt[i].scale(0.035);
        fPetalAlt[i].beginShape();
        for (int a = 0; a < vertices + 1; a++) {
          float radius = this.size/2.1;
          float angle = a * spacing;
          float fX = cos(radians(angle)) * radius;
          float fY = sin(radians(angle)) * radius;
          if (a == 0) {
            fPetalAlt[i].vertex(fX, fY);
          } else {
            float cAngle = angle - spacing/2;
            float cX = cos(radians(cAngle)) * radius;
            float cY = sin(radians(cAngle)) * (radius + random(0, 20));
            fPetalAlt[i].quadraticVertex(cX, cY, fX, fY);
          }
        }
        fPetalAlt[i].endShape(CLOSE);
        fPetalAlt[i].rotate(map(i, 0, fPetal.length, 0, TWO_PI));
        popMatrix();
        flowerAlt.addChild(fPetalAlt[i]);
      }

      //END FLOWER 2
    } else if (flowerStyle == 3) {
      //Flower 3 START
      petals = int(6);
      fPetal = new PShape[petals];
      fPetalAlt = new PShape[petals];

      float lScale = 0.9;
      float lScaleAlt = 0.9;

      for (int i = 0; i < petals; i++) {
        int vertices = 5;
        float spacing = 360 / vertices;
        fPetal[i] = createShape();
        fPetalAlt[i] = createShape();

        fPetal[i].translate(0, size/2 * lScale * 1.5);
        fPetalAlt[i].translate(0, size/2 * lScaleAlt * 1.5);

        fPetal[i].scale(0.035);
        fPetalAlt[i].scale(0.035);
        fPetal[i].beginShape();
        fPetalAlt[i].beginShape();


        fPetal[i].vertex(0, -this.size/2 * lScale * 3);
        fPetalAlt[i].vertex(0, -this.size/2 * lScaleAlt * 2);


        for (int a = 0; a < vertices; a++) {
          float radius = size/2;
          float angle = a * spacing + 360/vertices -121;
          float fX = cos(radians(angle)) * radius * 0.5;
          float fY = sin(radians(angle)) * radius;
          if (a == 0) {
          } else {
            float cAngle = angle - spacing/2;
            float cX = cos(radians(cAngle)) * radius * 0.5;
            float cY = sin(radians(cAngle)) * radius + random(20);
            fPetal[i].quadraticVertex(cX, cY, fX, fY);
            fPetalAlt[i].quadraticVertex(cX, cY, fX, fY);
          }
        }

        fPetal[i].endShape(CLOSE);
        fPetalAlt[i].endShape(CLOSE);

        fPetal[i].rotate(map(i, 0, petals, 0, TWO_PI));
        fPetalAlt[i].rotate(map(i, 0, petals, 0 - 0.1, TWO_PI - 0.1));

        flower.addChild(fPetal[i]);
        flowerAlt.addChild(fPetalAlt[i]);
      }

      //Flower 3 END
    } else {
      //Flower 4 START
      petals = int(6);
      fPetal = new PShape[petals];
      fPetalAlt = new PShape[petals];

      float lScale = 1.4;
      float lScaleAlt = 1.5;
      for (int i = 0; i < petals; i++) {
        int vertices = 5;
        float spacing = 360 / vertices;
        fPetal[i] = createShape();
        fPetalAlt[i] = createShape();
        fPetal[i].translate(0, size/2 * lScale);
        fPetalAlt[i].translate(0, size/2 * lScaleAlt);
        fPetal[i].scale(0.035);
        fPetalAlt[i].scale(0.035);
        fPetal[i].beginShape();
        fPetalAlt[i].beginShape();
        fPetal[i].vertex(0, -this.size/2 * lScale);
        fPetalAlt[i].vertex(0, -this.size/2 * lScaleAlt);
        for (int a = 0; a < vertices; a++) {
          float radius = size/2.8;
          float angle = a * spacing + 360/vertices -110;
          float fX = cos(radians(angle)) * radius;
          float fY = sin(radians(angle)) * radius;
          if (a == 0) {
            fPetal[i].quadraticVertex(1, -this.size/2 * lScale, fX, fY);
            fPetalAlt[i].quadraticVertex(50, -this.size/2 * lScaleAlt, fX, fY);
          } else {
            float cAngle = angle - spacing/2;
            float cX = cos(radians(cAngle)) * radius;
            float cY = sin(radians(cAngle)) * radius + random(20);
            fPetal[i].quadraticVertex(cX, cY, fX, fY);
            fPetalAlt[i].quadraticVertex(cX, cY, fX, fY);
          }
        }
        fPetal[i].quadraticVertex(-1, -this.size/2 * lScale, 0, -this.size/2 * lScale);
        fPetalAlt[i].quadraticVertex(-50, -this.size/2 * lScaleAlt, 0, -this.size/2 * lScaleAlt);
        fPetal[i].endShape(CLOSE);
        fPetalAlt[i].endShape(OPEN);
        fPetal[i].rotate(map(i, 0, petals, 0, TWO_PI));
        fPetalAlt[i].rotate(map(i, 0, petals, 0 + 0.1, TWO_PI + 0.1));
        flower.addChild(fPetal[i]);
        flowerAlt.addChild(fPetalAlt[i]);
      }

      //FLOWER 4 END
    }

    //number of different colour variations of flowers
    int colPal = 20;
    colors = new color[colPal];

    flower.setFill(true);
    flowerAlt.setFill(true);
    flower.setStroke(false);
    flowerAlt.setStroke(false);

    //1 = summer
    //2 = autumn
    //3 = winter
    //4 = spring
    int month = monthCol;

    switch(month) {
    case 12:
    case 1:
    case 2:
      season = "summer";
      sHue = 50;
      sSat = 90;
      sLit = 90;

      cHue = 60/colPal;
      cSat = 60/colPal;
      cLit = 40/colPal;

      for (int c = 0; c < colPal; c++) {
        colors[c] = color(hsluvToRgb(
          sHue + (c * cHue), 
          sSat - (c * cSat), 
          sLit - (c * cLit)
          ));
      }

      break;
    case 3:
    case 4:
    case 5:
      season = "autumn";
      sHue = 60;
      sSat = 90;
      sLit = 80;

      cHue = 70/colPal;
      cSat = 50/colPal;
      cLit = 45/colPal;

      for (int c = 0; c < colPal; c++) {
        //if (c >= 3) {
        //  sHue = 0;
        //}
        colors[c] = color(hsluvToRgb(
          sHue - (c * cHue), 
          sSat - (c * cSat), 
          sLit - (c * cLit)
          ));
      }

      break;
    case 6:
    case 7:
    case 8:
      season = "winter";
      sHue = 240;
      sSat = 30;
      sLit = 100;

      cHue = 40/colPal;
      cSat = 30/colPal;
      cLit = 60/map(colPal, 0, 20, 0, 30);

      for (int c = 0; c < colPal; c++) {
        colors[c] = color(hsluvToRgb(
          sHue + (c * cHue), 
          sSat + (c * cSat), 
          sLit - (c * cLit)
          ));
      }

      break;
    case 9:
    case 10:
    case 11:
      season = "spring";
      sHue = 80;
      sSat = 100;
      sLit = 90;

      cHue = 120/colPal;
      cSat = 0/colPal;
      cLit = 70/colPal;

      for (int c = 0; c < colPal; c++) {
        colors[c] = color(hsluvToRgb(
          sHue - (c * cHue), 
          sSat - (c * cSat), 
          sLit - (c * cLit)
          ));
      }

      secondary = color(hsluvToRgb(320, 90, 90), 30);

      break;
    default:
    }

    if (ratio < 0.5) {
      col = int(map(ratio, 0, 0.5, 0, 5));
    } else if (ratio > 0.5 && ratio < 1.5) {
      col = int(map(ratio, 0.5, 1.5, 6, 14));
    } else if (ratio > 1.5 && ratio < 40) {
      col = int(map(ratio, 1.5, 40, 15, 18));
    } else {
      col = int(19);
    }

    color primary = color(colors[col], 100);

    flower.setFill(primary);
    flowerAlt.setFill(secondary);
  }





  void show() {         
    pushMatrix();
    translate(this.pos.x, this.pos.y);
    flower.rotate(theta);    
    flowerAlt.rotate(theta);

    shape(flower);
    shape(flowerAlt);

    popMatrix();
  }

  void grow() {

    float targetScale = 1.0001;
    float dScale = targetScale - scaleUp;
    scaleUp += dScale * easeUp;

    r *= scaleUp;

    flower.rotate(theta);
    flower.scale(scaleUp);
    flowerAlt.rotate(theta);
    flowerAlt.scale(scaleUp);
  }

  void fadeOut() {
    float targetScale = 0.95;
    float dScale = targetScale - scaleDown;
    scaleDown += dScale * easeDown;

    flower.scale(scaleDown);
    flowerAlt.scale(scaleDown);
    r *= scaleDown;

    flowerIsDying = true;

    if (flower.getHeight() < minSize - 60 ||
      this.pos.x > width + flower.getWidth() ||
      this.pos.x < -flower.getWidth() ||
      this.pos.y > height + flower.getHeight() ||
      this.pos.y < -flower.getHeight()
      ) {
      flowerDeath = true;
    }
  }


  PVector separation (ArrayList flowers) {
    PVector steer = new PVector(0, 0);
    int total = 0;
    for (int i = 0; i < flowers.size(); i++) {
      Flower f = flowergroup.get(i);
      float perceptionRadius = r/2 + f.r/2;
      float d = dist(this.pos.x, this.pos.y, f.pos.x, f.pos.y);
      if ((d > 0) && (d < perceptionRadius)) {
        PVector diff = PVector.sub(pos, f.pos);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        total++;
      }
    }
    if (total > 0) {
      steer.div((float)total);
    } else {
      //this tells to stop if none are in the perception radius
      float easeSpeed = 0.01;
      if (vel.x > 0) {
        vel.x -= easeSpeed;
      } else if (vel.x < 0) {
        vel.x += easeSpeed;
      } else {
        vel.x = 0;
      }
      if (vel.y > 0) {
        vel.y -= easeSpeed;
      } else if (vel.y < 0) {
        vel.y += easeSpeed;
      } else {
        vel.y = 0;
      }
    }

    if (steer.mag() > 0) {
      steer.setMag(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  PVector cohesion (ArrayList flowers) {
    float perceptionRadius = r + 100;
    PVector steer = new PVector(0, 0);
    int total = 0;


    for (int i = 0; i < flowers.size(); i++) {
      Flower f = flowergroup.get(i);
      float d = dist(this.pos.x, this.pos.y, f.pos.x, f.pos.y);
      if ((d > 0) && (d < perceptionRadius)) {
        steer.add(f.pos);

        total++;
      } else if (d <= size + f.size + 10) {
        total = 0;
      }
    }

    if (total > 0) {
      steer.div(total);
      return seek(steer);
    } else {
      return new PVector(0, 0);
    }
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, pos);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  PVector attract(float x, float y) {
    PVector target = new PVector(x, y);
    return seek(target);
  }


  void bunching(ArrayList flowers) {
    PVector sep = separation(flowers);
    PVector coh = cohesion(flowers);
    PVector cen = attract(width/2, height/2);

    sep.mult(2.5);
    coh.mult(1);
    cen.mult(1);

    applyForces(sep);
    applyForces(coh);
    applyForces(cen);
  }

  void applyForces(PVector force) {
    PVector f = force.get();
    f.div(7);
    acc.add(f);
  }

  void update() {
    vel.add(acc);
    vel.limit(maxspeed);
    pos.add(vel);
    acc.mult(0);

    healthMeter -= 0.001;
    timeSinceSpawn += 1;
  }

  void move(float x, float y) {
    pos.x = x;
    pos.y = y;
  }

  boolean isDying() {

    if (healthMeter <= 20 ||
      this.pos.x > width + minSize ||
      this.pos.x < -minSize ||
      this.pos.y > height + minSize ||
      this.pos.y < -minSize ||
      flowerIsDying == true
      ) {
      return true;
    } else {
      return false;
    }
  }

  boolean isDead() {
    if (healthMeter <= 0 ||
      flowerDeath == true
      ) {
      return true;
    } else {
      return false;
    }
  }

  boolean isGrowing() {
    if (
      timeSinceSpawn < 500
      ) {
      return true;
    } else {
      return false;
    }
  }

  boolean selected(float x, float y) {
    float d = dist(x, y, pos.x, pos.y);
    if (d < r * 2/3) {
      return true;
    } else {
      return false;
    }
  }

  void sound() {

    if (millis()/chordIntTime > chordTrigger) {
      float volume = map(flower.getWidth(), 30, 400, 0, 1);
      notes[int(chordNote)].trigger();
      notes[int(chordNote)].amplitude.setLastValue(volume);
      notes[int(chordNote)].patch(out);

      chordTrigger = int(millis()/chordIntTime) + int(chordInts);
    }

    if (millis()/melodyIntTime > melodyTrigger) {
      float volume = map(flower.getWidth(), 30, 400, 0, 1) * 0.2;
      notes[int(melodyNote)].trigger();
      notes[int(melodyNote)].amplitude.setLastValue(volume);
      notes[int(melodyNote)].patch(out);

      melodyTrigger = int(millis()/melodyIntTime) + int(melodyInts);
    }
  }
}
