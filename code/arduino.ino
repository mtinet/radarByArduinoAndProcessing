// 서보 라이브러리 추가  
#include <Servo.h>. 

// 초음파 센서의 트리거, 에코 핀 설정  
const int trigPin = 10;
const int echoPin = 11;

// 서보모터 핀 설정
const int servoPin = 9;

// 초음파 시간(duration), 거리(distance) 변수 설정  
long duration;
int distance;

// 서보모터의 제어를 위한 서보 객체 생성  
Servo myServo; 

void setup() {
  pinMode(trigPin, OUTPUT); // 아두이노의 트리거 핀을 출력으로 설정  
  pinMode(echoPin, INPUT); // 아두이노의 에코 핀을 입력으로 설정  
  Serial.begin(9600);
  myServo.attach(servoPin); // 서보모터를 제어할 핀 번호를 지정  
}

void loop() {
  // 서보모터를 15도부터 165도까지 회전시킴
  for(int i = 15;i <= 165; i++){  
    myServo.write(i);
    delay(30);
    
    // 각각의 각도에서 초음파센서로부터 측정된 거리를 계산하는 calculateDistance() 함수를 호출하여 그 결과를 distance 변수에 넣음  
    distance = calculateDistance();

    Serial.print(i); // 시리얼 포트에 각도 값을 보냄  
    Serial.print(","); // 각도값 바로 다음에 추가 문자 ","를 붙여서 보냄, 프로세싱에서 인덱싱에 사용  
    Serial.print(distance); // 시리얼 포트에 거리 값을 보냄  
    Serial.print("."); // 거리값 바로 다음에 추가 문자 "."를 붙여서 보냄, 프로세싱에서 인덱싱에 사용  
  }
  
  // 서보모터를 165도부터 15도까지 회전시킴  
  for(int i = 165; i > 15; i--){  
    myServo.write(i);
    delay(30);
    distance = calculateDistance();
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
}


// 초음파 센서로부터 측정된 거리를 계산하는 함수  
int calculateDistance(){ 
  // 트리거 핀을 2마이크로초(1/1,000,000초) 동안 끔  
  digitalWrite(trigPin, LOW);  
  delayMicroseconds(2);
  
  // 트리거 핀에 10마이크로초 동안 신호를 인가하고 다시 끔  
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  // 시간(duration) 변수에 에코핀이 HIGH가 되는 시간을 읽어서 저장하고, 이를 거리로 환산  
  // 음파는 섭씨 15도에서 초당 약 340m(34000cm) 이동함  
  // 이를 마이크로초(1/1,000,000)당 이동거리로 환산하면 0.034cm/us  
  // 초음파가 초음파센서로부터 발사되어 돌아오는 거리는 측정되는 거리의 2배이므로 2로 나눔  
  duration = pulseIn(echoPin, HIGH); 
  distance = duration * 0.034 / 2;
  
  // 거리값(distance)을 반환  
  return distance;
}
