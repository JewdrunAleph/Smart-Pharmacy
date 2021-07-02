#include <dht11.h>
#define DHT11PIN A5
#define Aout A0 //MQ-135 AO 接 Arduino Uno A0
dht11 DHT11;
int concentration = 0;//临时变量，储存A0读入的气体传感器的浓度
int incomedate = 0;
void setup() {                                                       //设置
Serial.begin(9600);                                            //设置波特率参数
pinMode(DHT11PIN,OUTPUT);                       //定义输出口
pinMode(Aout, INPUT);//定义A0为INPUT模式
}

void loop() {                                                    //循环
  //while (Serial.available() > 0)//串口接收到数据
  while(1)
    //while (1)//串口接收到数据
    {
      concentration = analogRead(Aout); //读取A0的模拟数据
      incomedate = Serial.read();//获取串口接收到的数据
      int chk = DHT11.read(DHT11PIN);                 //将读取到的值赋给chk
      int tem=(float)DHT11.temperature;               //将温度值赋值给tem
      int hum=(float)DHT11.humidity;                   //将湿度值赋给hum
      String str1 = "DATA,";
      
      incomedate = Serial.read();//获取串口接收到的数据
      
      //若接收到1则执行
      pinMode(13, OUTPUT);
      digitalWrite(13, HIGH); //亮灯    

      str1 += tem;
      str1 += ",";
      str1 += hum;
      str1 += ",";
      str1 += concentration;
      Serial.println(str1);                              //打印出最终组合的字符串
      
      delay(5);
    }
}
