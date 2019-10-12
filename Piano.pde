import de.voidplus.leapmotion.*;
import gifAnimation.*;
import processing.sound.*;
import beads.*;
import ddf.minim.*;

float handGap = 200;
float depth = 150;
float fingerSize = 30;
Gif leftIndexGif;
Gif rightIndexGif;
Gif otherFingersGif;
PVector leftIndex;
PVector rightIndex;
Boolean leftGrab;
Boolean rightGrab;
float grabThreshold = 1.0;
int leftI = -1;
int rightI = -1;

//vicky
int x;
int y;
boolean overBox1 = false;
boolean overBox2 = false;
Minim minim;
AudioContext ac;
AudioPlayer player;
ArrayList<Key> keys = new ArrayList();
ArrayList<String> sound = new ArrayList();

LeapMotion leap;

void setup() {
  size(988, 600);
  leap = new LeapMotion(this);
  textAlign(CENTER);
  setupFingerImg();
  
  sceneSound();
}

void sceneSound(){
  x = width/21;
  y = height/2; 
  minim = new Minim(this); 
  sound.add("sound/c3.mp3");
  sound.add("sound/d3.mp3");
  sound.add("sound/e3.mp3");
  sound.add("sound/f3.mp3");
  sound.add("sound/g3.mp3");
  sound.add("sound/a3.mp3");
  sound.add("sound/b3.mp3");
  sound.add("sound/c4.mp3");
  sound.add("sound/d4.mp3");
  sound.add("sound/e4.mp3");
  sound.add("sound/f4.mp3");
  sound.add("sound/g4.mp3");
  sound.add("sound/a4.mp3");
  sound.add("sound/b4.mp3");
  sound.add("sound/c5.mp3");
  sound.add("sound/d5.mp3");
  sound.add("sound/e5.mp3");
  sound.add("sound/f5.mp3");
  sound.add("sound/g5.mp3");
  sound.add("sound/a5.mp3");
  sound.add("sound/b5.mp3");
}

void draw() {
  background(100);
  createKeys();  
  drawanyKey();
  blackKey();

  int fps = leap.getFrameRate();
  fill(#00E310);
  text(fps + " fps", 20, 20);

  for (Hand hand : leap.getHands ()) {

    PVector thumbTip = hand.getThumb().getRawPositionOfJointTip();
    PVector indexTip = hand.getIndexFinger().getRawPositionOfJointTip();
    PVector ringTip = hand.getRingFinger().getRawPositionOfJointTip();
    PVector middleTip = hand.getMiddleFinger().getRawPositionOfJointTip();
    PVector pinkyTip = hand.getPinkyFinger().getRawPositionOfJointTip();

    //Set label for each finger
    handleFinger(thumbTip, "Thb", hand.getPalmPosition(),0);
    if(hand.isLeft()){
      handleFinger(indexTip, "Idx", hand.getPalmPosition(),1);
    }else{
      handleFinger(indexTip, "Idx", hand.getPalmPosition(),2);
    }
    handleFinger(middleTip, "Mdl", hand.getPalmPosition(),0);
    handleFinger(ringTip, "Rng", hand.getPalmPosition(),0);
    handleFinger(pinkyTip, "Pky", hand.getPalmPosition(),0);
    
    //Detect grab gesture
    if(hand.isLeft()&&hand.getGrabStrength()>=grabThreshold){
      leftGrab = true;
    }else if(hand.isLeft()&&hand.getGrabStrength()<grabThreshold){
      leftGrab = false;
    }
    
    if(hand.isRight()&&hand.getGrabStrength()>=grabThreshold){
      rightGrab = true;
    }else if(hand.isRight()&&hand.getGrabStrength()<grabThreshold){
      rightGrab = false;
    }
    
    //System.out.println("isLeftGrab: "+leftGrab+" isRightGrab: "+rightGrab);
    
    hand.draw();    
  }
  
  detectPressed();
  detectReleased();
  
}

void setupFingerImg(){
  leftIndexGif = new Gif(this,"img/Target.gif");
  leftIndexGif.loop();
  rightIndexGif = new Gif(this,"img/Target.gif");
  rightIndexGif.loop();
  otherFingersGif = new Gif(this,"img/Target.gif");
  otherFingersGif.loop();
}

void handleFinger(PVector pos, String id, PVector palm, int finger) {

  float x = map(pos.x, -handGap, handGap, 0, width);
  float y = map(-pos.z, -depth, depth, 0, height);
  
  if(finger==1){
    image(leftIndexGif,x,y,fingerSize,fingerSize);
    leftIndex = new PVector(x,y);
  }else if(finger==2){
    image(rightIndexGif,x,y,fingerSize,fingerSize);
    rightIndex = new PVector(x,y);
  }else{
    image(otherFingersGif,x,y,fingerSize,fingerSize);
  }

  fill(#00E310);
  text(id, x, y - 20);
}

//PVector getLeftIndexPosition(){
//  return leftIndex;
//}

//PVector getRightIndexPosition(){
//  return rightIndex;
//}

//Boolean isLeftGrab(){
//  return leftGrab;
//}

//Boolean isRightGrab(){
//  return rightGrab;
//}


//
void createKeys() {

  for (int i=0; i<21; i++) {
    keys.add(new Key(i));
  }
}

void drawanyKey() {

  for (int i=0; i<21; ++i) {
    for (int i1=0; i1<21; ++i1) {

      if (i1==i) {
        continue;
      }
      if (keys.get(i1).overBox) {
        fill(#FFFFFF);
        rect(i*x, height/2, x, 2*y-10);  
        break;
      }
    }
    //if (mouseX > i*x && mouseX < (i+1)*x) {
    //  keys.get(i).overBox=true;
    //  if (!keys.get(i).locked) { 
    //    fill(#FFFFFF);
    //  } else {
    //    fill(#C9C9C9);
    //    rect(i*x, height/2, x, 2*y-10);
    //  }
    //} else {
    //  fill(#FFFFFF);
    //  keys.get(i).overBox = false;
    //}
    if ((leftIndex!=null&&leftIndex.y>=height/2&&leftIndex.x > i*x && leftIndex.x < (i+1)*x)||(rightIndex!=null&&rightIndex.y>=height/2&&rightIndex.x > i*x && rightIndex.x < (i+1)*x)) {
      keys.get(i).overBox=true;
      if (!keys.get(i).locked) { 
        fill(#FFFFFF);
      } else {
        fill(#C9C9C9);
        rect(i*x, height/2, x, 2*y-10);
      }
    } else {
      fill(#FFFFFF);
      keys.get(i).overBox = false;
    }
    rect(i*x, height/2, x, 2*y-10);
  }
}

void detectReleased(){
  if(leftIndex!=null&&leftIndex.y<height/2){
    leftI=-1;
  }
  if(rightIndex!=null&&rightIndex.y<height/2){
    rightI=-1;
  }
  if(leftIndex==null||rightIndex==null){
    drawanyKey();
    blackKey();
  }
}

void detectPressed(){
  playSound(leftIndex);
  playSound(rightIndex);
}

void playSound(PVector index){
  if(index!=null&&index.y>=height/2){
    for (int i=0; i<21; ++i) {
    if (index.x > i*x && index.x< (i+1)*x) 
    {
      if(index==leftIndex&&leftI==i){
        break;
      }else if(index==rightIndex&&rightI==i){
        break;
      }
      if(index==leftIndex){
        leftI=i;
      }else if(index==rightIndex){
        rightI=i;
      }
      keys.get(i).locked=true;
      
      player = minim.loadFile(sound.get(i));


      if
        ( player.isPlaying() ) {

        player.pause();
      } else
        if  ( player.position() == player.length() ) {

          player.rewind();

          player.play();
        } else
        {

          player.play();
        }
    }
  }
  }
}

void mousePressed() {
  System.out.println("1");
  for (int i=0; i<21; ++i) {
    if (mouseX > i*x && mouseX< (i+1)*x) 
    {
      keys.get(i).locked=true;

      player = minim.loadFile(sound.get(i));


      if
        ( player.isPlaying() ) {

        player.pause();
      } else
        if  ( player.position() == player.length() ) {

          player.rewind();

          player.play();
        } else
        {

          player.play();
        }
    }
  }
}

void blackKey() {

  int x= width/21;
  int y = height/4;
  fill(0);
  rect(2*x/3, height/2, 2*x/3, y);
  rect(x+2*x/3, height/2, 2*x/3, y);
  rect(3*x+2*x/3, height/2, 2*x/3, y);
  rect(4*x+2*x/3, height/2, 2*x/3, y);
  rect(5*x+2*x/3, height/2, 2*x/3, y);
  rect(7*x+2*x/3, height/2, 2*x/3, y);
  rect(8*x+2*x/3, height/2, 2*x/3, y);
  rect(10*x+2*x/3, height/2, 2*x/3, y);
  rect(11*x+2*x/3, height/2, 2*x/3, y);
  rect(12*x+2*x/3, height/2, 2*x/3, y);
  rect(14*x+2*x/3, height/2, 2*x/3, y);
  rect(15*x+2*x/3, height/2, 2*x/3, y);
  rect(17*x+2*x/3, height/2, 2*x/3, y);
  rect(18*x+2*x/3, height/2, 2*x/3, y);
  rect(19*x+2*x/3, height/2, 2*x/3, y);
}

void mouseReleased() {
  player.pause();   
  for (Key k : keys)
    k.locked = false;
}
