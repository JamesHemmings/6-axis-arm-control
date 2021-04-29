import java.util.Arrays;
import java.util.Scanner;

import processing.serial.*;

import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;

import cc.arduino.*;
import org.firmata.*;

ControlDevice cont;
ControlIO control;

Arduino arduino;

float lThumbX;
float lThumbXOutput=20;//starting angle for servo

float lThumbY;
float lThumbYOutput= 140 ;

float rThumbX;
float rThumbXOutput=90;

float rThumbY;
float rThumbYOutput = 180;

float HatSwitch;
float HatSwitchOutput = 30;

float trigger;
float triggerOutput = 180;

float input;
int speed = 50; // this changes the speed at which the servos will increment larger number means they will move slower
int speedMultiplier;

int[] pos1=new int[6];              //arrays to save a position to
int[] pos2=new int[6];
int[] pos3=new int[6];
int[] pos4=new int[6];

int mode = 1;


void setup() {
  size(360, 200); //window size

  control = ControlIO.getInstance(this);
  cont = control.getMatchedDevice("xbs");

  if (cont == null) {
    println("no controller was detected"); // exit program if controller not detected
    System.exit(-1);
  }

  //println(Arduino.list());

  arduino = new Arduino(this, Arduino.list()[0], 57600);// selects the port which arduino is connected to if unknown uncomment last line to help find it
  arduino.pinMode(3, Arduino.SERVO);
  arduino.pinMode(5, Arduino.SERVO);
  arduino.pinMode(6, Arduino.SERVO);
  arduino.pinMode(9, Arduino.SERVO);
  arduino.pinMode(10, Arduino.SERVO);
  arduino.pinMode(11, Arduino.SERVO);
}
void pos(int[] pos){                                                                    // function to write stored position to servos
  lThumbXOutput=pos[0];// pin to out put to,and value to lThumbXOutput
  lThumbYOutput=pos[1];// pin to out put to,and value to lThumbXOutput
 rThumbYOutput= pos[2];// pin to out put to,and value to lThumbXOutput
 rThumbXOutput=pos[3];// pin to out put to,and value to lThumbXOutput
  triggerOutput=pos[4];// pin to out put to,and value to lThumbXOutput
  HatSwitchOutput=pos[5];// pin to out put to,and value to lThumbXOutput
  
  println("moving to " + (Arrays.toString(pos)));
  
  arduino.servoWrite(3, int(lThumbXOutput));// pin to output to,and value to lThumbXOutput
  arduino.servoWrite(5, int(lThumbYOutput));// pin to output to,and value to lThumbXOutput
  arduino.servoWrite(6, int(rThumbYOutput));// pin to output to,and value to lThumbXOutput
  arduino.servoWrite(9, int(rThumbXOutput));// pin to output to,and value to lThumbXOutput
  arduino.servoWrite(11, int(HatSwitchOutput));// pin to output to,and value to lThumbXOutput
  delay(3500);                                                                                      //delay so it can move to position and have gripper move last
  arduino.servoWrite(10, int(triggerOutput));// pin to out put to,and value to lThumbXOutput
}

public void getUserInput() {
  //assign our float value
  // access the controller

  lThumbX = map(cont.getSlider("BaseServo").getValue(), -1, 1, 180, 0);
  if (lThumbX >= 110) {   // if thumb stick is moved right
    lThumbXOutput = lThumbXOutput+(lThumbX-90)/speed;  //the amount that value is past 90 will be added to previous value
    if (lThumbXOutput>180) {
      lThumbXOutput=180;
    }
  };
  if (lThumbX<=70) {
    lThumbXOutput = lThumbXOutput -(90-lThumbX)/speed;
    if (lThumbXOutput<0) { 
      lThumbXOutput=0;
    }
  }
  
  
lThumbY = map(cont.getSlider("FirstArm").getValue(),-1,1,0,180);
if (lThumbY >= 110) {   // if thumb stick is moved right
    lThumbYOutput = lThumbYOutput+(lThumbY-90)/speed;      //  the amount that value is past 90 will be added to previous value
    if (lThumbYOutput>180) {
      lThumbYOutput=180;
    }
  };
  if (lThumbY<=70) {
    lThumbYOutput = lThumbYOutput -(90-lThumbY)/speed;
    if (lThumbYOutput<0) {
      lThumbYOutput=0;
    }
  }


 rThumbY= map(cont.getSlider("SecondArm").getValue(),-1,1,180,0);
   if (rThumbY >= 110) {   // if thumb stick is moved right
    rThumbYOutput = rThumbYOutput+(rThumbY-90)/speed;      //  the amount that value is past 90 will be added to previous value
    if (rThumbYOutput>180) {
      rThumbYOutput=180;
    }
  };
  if (rThumbY<=70) {
    rThumbYOutput = rThumbYOutput -(90-rThumbY)/speed;
    if (rThumbYOutput<0) {
      rThumbYOutput=0;
    }
  }
 
rThumbX = map(cont.getSlider("WristRotation").getValue(),-1,1,0,180);
  //println(lThumbX);
     if (rThumbX >= 110) {   // if thumb stick is moved right
    rThumbXOutput = rThumbXOutput+(rThumbX-90)/speed;      //  the amount that value is past 90 will be added to previous value
    if (rThumbXOutput>180) {
      rThumbXOutput=180;
    }
  };
  if (rThumbX<=70) {
    rThumbXOutput = rThumbXOutput -(90-rThumbX)/speed;
    if (rThumbXOutput<0) {
      rThumbXOutput=0;
    }
  }
  
trigger = map(cont.getSlider("Gripper").getValue(),-1,1,0,180);
     if (trigger >= 110) {   // if thumb stick is moved right
    triggerOutput = triggerOutput+(trigger-90)/speed*2;      //  the amount that value is past 90 will be added to previous value
    if (triggerOutput>180) {
      triggerOutput=180;
    }
  };
  if (trigger<=70) {
    triggerOutput = triggerOutput -(90-trigger)/speed*2;
    if (triggerOutput<0) {
      triggerOutput=0;
    }
  }
  
HatSwitch = map(cont.getHat("WristLinear").getY(),-1,1,0,180);
     if (HatSwitch >= 110) {   // if thumb stick is moved right
    HatSwitchOutput = HatSwitchOutput+90/float(speed);      //  the amount that value is past 90 will be added to previous value
    if (HatSwitchOutput>180) {
      HatSwitchOutput=180;
    }
  };
  if (HatSwitch<=70) {
    HatSwitchOutput = HatSwitchOutput -90/float(speed);
    if (HatSwitchOutput<0) {
      HatSwitchOutput=0;
    }
  }
speedMultiplier =int( map(cont.getHat("WristLinear").getX(),-1,1,0,180));
     if (speedMultiplier >= 110) {   // if thumb stick is moved right
    speed = speed-5;      //  the amount that value is past 90 will be added to previous value
    if (speed<=50){
    speed=50;
    }
    }
  if (speedMultiplier<=70) {
    speed = speed+5 ;
    if (speed>1000){
    speed = 1000;
    }
    }
    
if (cont.getButton("select").pressed()==true){                                                  //change mode when select button is pressed
mode++;
if (mode>3){
mode = 1;
}
delay(200);
}


if (cont.getButton("start").pressed()==true && mode ==1){                                                //when the start button is pressed
    if (cont.getButton("aButton").pressed()==true){                                          //move to position 1 when A is pressed
      pos(pos1);
    }
        if (cont.getButton("xButton").pressed()==true){                                          //move to position 2 when X is pressed
      pos(pos2);
    }
        if (cont.getButton("yButton").pressed()==true){                                          //move to position 3 when Y is pressed
      pos(pos3);
    }
        if (cont.getButton("bButton").pressed()==true){                                          //move to position 4 when B is pressed
      pos(pos4);
    }
  }
    
  if (cont.getButton("aButton").pressed()==true && cont.getButton("start").pressed()==false ){            //Store pos1
    pos1[0]=int(lThumbXOutput);
    pos1[1]=int(lThumbYOutput);
    pos1[2]=int(rThumbYOutput);
    pos1[3]=int(rThumbXOutput);
    pos1[4]=int(triggerOutput);
    pos1[5]=int(HatSwitchOutput);
  }
 if (cont.getButton("xButton").pressed()==true && cont.getButton("start").pressed()==false ){            //Store pos2
    pos2[0]=int(lThumbXOutput);
    pos2[1]=int(lThumbYOutput);
    pos2[2]=int(rThumbYOutput);
    pos2[3]=int(rThumbXOutput);
    pos2[4]=int(triggerOutput);
    pos2[5]=int(HatSwitchOutput);
  }
   if (cont.getButton("yButton").pressed()==true && cont.getButton("start").pressed()==false ){            //Store pos3
    pos3[0]=int(lThumbXOutput);
    pos3[1]=int(lThumbYOutput);
    pos3[2]=int(rThumbYOutput);
    pos3[3]=int(rThumbXOutput);
    pos3[4]=int(triggerOutput);
    pos3[5]=int(HatSwitchOutput);
  }
   if (cont.getButton("bButton").pressed()==true && cont.getButton("start").pressed()==false ){            //Store pos4
    pos4[0]=int(lThumbXOutput);
    pos4[1]=int(lThumbYOutput);
    pos4[2]=int(rThumbYOutput);
    pos4[3]=int(rThumbXOutput);
    pos4[4]=int(triggerOutput);
    pos4[5]=int(HatSwitchOutput);
  }
  
 if (mode==2 && cont.getButton("start").pressed()==true){
   while (true){
        if (cont.getButton("bButton").pressed()==true)
   {     
     println("stopping movement");
     delay(1500);
   break;
   }
   println("moving between position 1 and 2 hold b to stop movement");
   pos(pos1);
   delay(1000);
   pos(pos2);

   }
 
 }

  }


void draw() {
  getUserInput();
  background(lThumbX, 100, 255);//the numbers are just for the color of background

  arduino.servoWrite(3, int(lThumbXOutput));// pin to out put to,and value to lThumbXOutput
  arduino.servoWrite(5, int(lThumbYOutput));// pin to out put to,and value to lThumbXOutput
  arduino.servoWrite(6, int(rThumbYOutput));// pin to out put to,and value to lThumbXOutput
  arduino.servoWrite(9, int(rThumbXOutput));// pin to out put to,and value to lThumbXOutput
  arduino.servoWrite(10, int(triggerOutput));// pin to out put to,and value to lThumbXOutput
  arduino.servoWrite(11, int(HatSwitchOutput));// pin to out put to,and value to lThumbXOutput
  
  println("BaseServo= "+int(lThumbXOutput));
  println("Arm1Servo= "+int(lThumbYOutput));
  println("Arm2Servo= "+ int(rThumbYOutput));
  println("WristRotationServo= "+ int(rThumbXOutput));
  println("GripperServo= "+ int(triggerOutput));
  println("WristLinearServo= "+ int(HatSwitchOutput));
  println("SpeedMultiplier= 1/"+ int(speed));
  println(cont.getButton("aButton").pressed());
  println(cont.getButton("start").pressed());
  println("position 1 stored as:"+(Arrays.toString(pos1)));
  println("position 2 stored as:"+(Arrays.toString(pos2)));
  println("position 3 stored as:"+(Arrays.toString(pos3)));
  println("position 4 stored as:"+(Arrays.toString(pos4)));
  println("mode:"+mode);
}
