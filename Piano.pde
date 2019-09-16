import de.voidplus.leapmotion.*;
import gifAnimation.*;

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

LeapMotion leap;

void setup() {
  size(1000, 600);
  leap = new LeapMotion(this);
  textAlign(CENTER);
  setupFingerImg();
}

void draw() {
  background(100);

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
    
    System.out.println("isLeftGrab: "+leftGrab+" isRightGrab: "+rightGrab);
    
    hand.draw();    
  }
  
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

PVector getLeftIndexPosition(){
  return leftIndex;
}

PVector getRightIndexPosition(){
  return rightIndex;
}

Boolean isLeftGrab(){
  return leftGrab;
}

Boolean isRightGrab(){
  return rightGrab;
}
