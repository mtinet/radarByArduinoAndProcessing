import processing.serial.*; // 시리얼 통신  
import java.awt.event.KeyEvent; // 시리얼 통신으로부터 데이터 읽기  
import java.io.IOException;

// 시리얼 객체 생성  
Serial myPort; 

// 변수 초기화  
String angle="";
String distance="";
String data="";
String noObject;

float pixsDistance;

int iAngle, iDistance;
int index1=0;
int index2=0;

// 폰트 객체 생성  
PFont orcFont;

void setup() {
  // 스크린 해상도 지정  
  size (1200, 700); 
  // 곡률이 들어간 부분을 부드럽게 처리  
  smooth();
  
  // 시리얼 포트를 COM5로 지정하고 속도를 9600보레이트로 맞춤, 이 때 COM5는 컴퓨터에 연결된 아두이노의 포트를 확인하여 수정해야 함  
  myPort = new Serial(this,"COM5", 9600); 
  // 맥에서는 30번 줄 코드를 주석처리하고 31번 줄 코드를 주석해제함, 아두이노로부터 신호가 안들어와서 동작이 안될 경우 [0]을 [1]로 바꿔봄.  
  // myPort = new Serial(this, Serial.list()[0], 9600);
  // 시리얼 포트로부터 문자 '.'까지 들어온 데이터를 읽어서 버퍼에 넣음, 예) 각도,거리.
  myPort.bufferUntil('.'); 
}

void draw() {
  // 밝은 초록색으로 채움  
  fill(98,245,31);
  // 움직이는 라인의 모션 블러와 슬로우 페이드를 구현 
  noStroke();
  fill(0,4); 
  rect(0, 0, width, height-height*0.065); 
  
  // 밝은 초록색으로 채움  
  fill(98,245,31); 
  
  // 레이더를 그리는 함수 호출  
  drawRadar(); // 레이더 그리기  
  drawLine(); // 각도별 레이더 선 그리기(초록색)  
  drawObject(); // 각도별 레이더 선 그리기(빨간색)  
  drawText(); // 레이더 표시 글자 쓰기  
}

// 시리얼 이벤트가 있을 때 값 처리하기  
void serialEvent (Serial myPort) { 
  // 문자 '.'가 들어올 때까지 시리얼 포트로부터 데이터를 읽고 문자열 변수 data에 넣음  
  data = myPort.readStringUntil('.');
  
  // data에 들어온 마지막 부분인 '.'를 제거하고 다시 data에 저장  
  data = data.substring(0,data.length()-1);
  
  // data 안의 ','의 위치를 찾아 index1에 넣음  
  index1 = data.indexOf(","); 
  
  // data의 첫부분부터 index1 이전까지 잘라내어 angle에 넣음  
  angle= data.substring(0, index1); 
  
  // data의 index1 다음부터 data의 마지막까지 잘라내어 distance에 넣음  
  distance= data.substring(index1+1, data.length()); 
  
  // 문자열 변수를 정수형으로 변환하고 각도는 iAngle에, 거리는 iDistance에 넣음  
  iAngle = int(angle);
  iDistance = int(distance);
}

// 레이더 그리기  
void drawRadar() {
  // 좌표 원점을 이동하여 작업함  
  pushMatrix();
    // 좌표 원점을 이동함, 중앙 
    translate(width/2,height-height*0.074); 
    // 채우기 없음  
    noFill();
    // 선 두께는 2  
    strokeWeight(2);
    // 선 색깔은 초록색 지정  
    stroke(98,245,31);

    // 레이더의 호 선을 그림
    arc(0,0,(width-width*0.0625),(width-width*0.0625),PI,TWO_PI);
    arc(0,0,(width-width*0.27),(width-width*0.27),PI,TWO_PI);
    arc(0,0,(width-width*0.479),(width-width*0.479),PI,TWO_PI);
    arc(0,0,(width-width*0.687),(width-width*0.687),PI,TWO_PI);

    // 레이더의 각도 선을 그림  
    line(-width/2,0,width/2,0);
    line(0,0,(-width/2)*cos(radians(30)),(-width/2)*sin(radians(30)));
    line(0,0,(-width/2)*cos(radians(60)),(-width/2)*sin(radians(60)));
    line(0,0,(-width/2)*cos(radians(90)),(-width/2)*sin(radians(90)));
    line(0,0,(-width/2)*cos(radians(120)),(-width/2)*sin(radians(120)));
    line(0,0,(-width/2)*cos(radians(150)),(-width/2)*sin(radians(150)));
    line((-width/2)*cos(radians(30)),0,width/2,0);
    
  // 좌표 원점을 0, 0으로 되돌림  
  popMatrix();
}

// 오브젝트 그리기  
void drawObject() {
  pushMatrix();
    // 원점 이동, 중앙 하단
    translate(width/2,height-height*0.074); 
    // 선두께는 9  
    strokeWeight(9);
    // 선 색깔은 빨간색 지정  
    stroke(255,10,10); 
    // 센서로부터 나온 거리(cm)를 픽셀(pixels)로 수정하여 거리를 표현함  
    pixsDistance = iDistance*((height-height*0.1666)*0.025);
    
    // 표시되는 거리를 40cm로 제한  
    if(iDistance < 40){
      // 각도와 거리에 따라 객체를 그림  
      line(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)),(width-width*0.505)*cos(radians(iAngle)),-(width-width*0.505)*sin(radians(iAngle)));
    }
  popMatrix();
}

// 선 그리기  
void drawLine() {
  pushMatrix();
    // 선 두께는 9  
    strokeWeight(9);
    // 선 색깔은 초록색 지정
    stroke(30,250,60);
    // 원점 이동, 중앙 하단  
    translate(width/2,height-height*0.074);  
    // 각도에 따라 선을 그림
    line(0,0,(height-height*0.12)*cos(radians(iAngle)),-(height-height*0.12)*sin(radians(iAngle))); 
  popMatrix();
}

// 글씨 써넣기  
void drawText() { 
  pushMatrix();
    // 거리가 40cm를 넘으면 'Out of Range'를 표시하고, 그렇지 않다면 'In Range'를 표시함  
    if(iDistance > 40) {
      noObject = "Out of Range";
    } else {
      noObject = "In Range";
    }
    
    // 레이더 하단 바탕 부분, 검정색 사각형, 선 없음
    fill(0,0,0);
    noStroke();
    rect(0, height-height*0.0648, width, height);
    
    // 레이더 하단 글씨 부분, 초록색, 거리 표시 글씨크기 25  
    fill(98,245,31);
    textSize(25);
    text("10cm",width-width*0.3854,height-height*0.0833);
    text("20cm",width-width*0.281,height-height*0.0833);
    text("30cm",width-width*0.177,height-height*0.0833);
    text("40cm",width-width*0.0729,height-height*0.0833);
    
    // 레이더 측정 정보 글씨크기 40  
    textSize(40);
    text("Ultra Sonic Radar", width-width*0.95, height-height*0.0277);
    text("Angle: " + iAngle +" °", width-width*0.57, height-height*0.0277);
    text("Distance: ", width-width*0.35, height-height*0.0277);
    
    // 거리가 40cm보다 작으면 화면에 표시  
    if(iDistance < 40) {
      text("        " + iDistance +" cm", width-width*0.225, height-height*0.0277);
    }
    
    // 레이더 각도 글씨 표시  
    textSize(25);
    fill(98,245,60);
    translate((width-width*0.4994)+width/2*cos(radians(30)),(height-height*0.0907)-width/2*sin(radians(30)));
    rotate(-radians(-60));
    text("30°",0,0);
    
    resetMatrix();
    translate((width-width*0.503)+width/2*cos(radians(60)),(height-height*0.0888)-width/2*sin(radians(60)));
    rotate(-radians(-30));
    text("60°",0,0);
    
    resetMatrix();
    translate((width-width*0.507)+width/2*cos(radians(90)),(height-height*0.0833)-width/2*sin(radians(90)));
    rotate(radians(0));
    text("90°",0,0);
    
    resetMatrix();
    translate(width-width*0.513+width/2*cos(radians(120)),(height-height*0.07129)-width/2*sin(radians(120)));
    rotate(radians(-30));
    text("120°",0,0);
    
    resetMatrix();
    translate((width-width*0.5104)+width/2*cos(radians(150)),(height-height*0.0574)-width/2*sin(radians(150)));
    rotate(radians(-60));
    text("150°",0,0);
  popMatrix(); 
}
