#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <WiFiManager.h> 
#include <DNSServer.h>
#include <MQTT.h>
#include <PZEM004Tv30.h>
WiFiServer server(80);

WiFiClient net;
MQTTClient client;

unsigned long unitMillis = 0;
unsigned long bottomMillis = 0;
unsigned long blinkMillis = 0;

float voltage1   = 0.0;
float current1   = 0.0;
float power1     = 0.0;
float voltage2   = 0.0;
float current2   = 0.0;
float power2     = 0.0;
float voltage3   = 0.0;
float current3   = 0.0;
float power3     = 0.0;


String statusMess1 = "";    
String statusMess2 = ""; 
String statusMess3 = ""; 

String logMess = "";
//************************************************MQTT Config************************************************//
String deviceID = "********"; //replace ******** whith ID_Device
String ip_MQTT_Server = "***.***.***.***"; //replace ***.***.***.*** with ip MQTT Server  
String user_MQTT_Server = "********"; //replace ******** with mqttuser
String pass_MQTT_Server = "********"; //replace ******** with mqtt password
//************************************************MQTT Config************************************************//
bool ledState = true;

PZEM004Tv30 pzem1(D1, D2); // (RX,TX)connect to TX,RX of PZEM1
PZEM004Tv30 pzem2(D5, D6);  // (RX,TX) connect to TX,RX of PZEM2
PZEM004Tv30 pzem3(D7, D3);  // (RX,TX) connect to TX,RX of PZEM3


void connect() {
  //Serial.print("checking wifi...");
  while (WiFi.status() != WL_CONNECTED) {
    //Serial.print(".");
    delay(1000);
  }

  //Serial.print("\nconnecting...");
  while (!client.connect(deviceID.c_str(), user_MQTT_Server.c_str(), pass_MQTT_Server.c_str())) //replace MQTT User with mqttuser and replace MQTT Password with mqtt password
  {
    //Serial.print(".");
    delay(1000);
  }
  //Serial.println("\nconnected!");
}

void messageReceived(String &topic, String &payload) {
  //Serial.println("incoming: " + topic + " - " + payload);

  // Note: Do not use the client in the callback to publish, subscribe or
  // unsubscribe as it may cause deadlocks when other things arrive while
  // sending and receiving acknowledgments. Instead, change a global variable,
  // or push to a queue and handle it in the loop after calling `client.loop()`.
}
WiFiManager wifiManager;

void setup() 
{
  //Serial.begin(115200);
  
  // Initialize the output variables as outputs
  // WiFiManager
  // Local intialization. Once its business is done, there is no need to keep it around
  
  pinMode(2,INPUT);
  pinMode(3,OUTPUT);
  digitalWrite(3,0);
  unitMillis = millis();
  blinkMillis = millis();
  bottomMillis = millis(); 
  // Uncomment and run it once, if you want to erase all the stored information
  //wifiManager.resetSettings();
  
  // set custom ip for portal
  //wifiManager.setAPConfig(IPAddress(10,0,1,1), IPAddress(10,0,1,1), IPAddress(255,255,255,0));

  // fetches ssid and pass from eeprom and tries to connect
  // if it does not connect it starts an access point with the specified name
  // here  "AutoConnectAP"
  // and goes into a blocking loop awaiting configuration
  
  wifiManager.autoConnect(deviceID.c_str());
  // or use this for auto generated name ESP + ChipID
  //wifiManager.autoConnect();
  
  // if you get here you have connected to the WiFi
  //Serial.println("Connected.");

  client.begin(ip_MQTT_Server.c_str(), net); 
  //client.onMessage(messageReceived);

  connect(); //connect to MQTT Server


  

}


void loop() 
{
  client.loop();

  if (millis() - unitMillis >= 1000) 
    {
      voltage1   = pzem1.voltage(); // read voltage sensor 1
      current1   = pzem1.current(); // read current sensor 1
      power1     = pzem1.power();   // read current sensor 1
      voltage2   = pzem2.voltage(); // read current sensor 1
      current2   = pzem2.current(); // read current sensor 1
      power2     = pzem2.power();   // read current sensor 1
      voltage3   = pzem3.voltage(); // read current sensor 1
      current3   = pzem3.current(); // read current sensor 1
      power3     = pzem3.power();   // read current sensor 1
      statusMess1 = String(voltage1) + "," + String(current1,3) + "," + String(power1,3); //create message status sensor1
      statusMess2 = String(voltage2) + "," + String(current2,3) + "," + String(power2,3); //create message status sensor2
      statusMess3 = String(voltage3) + "," + String(current3,3) + "," + String(power3,3); //create message status sensor3
      logMess = String(deviceID) + "," + String(pzem1.power()) + "," + String(pzem2.power()) + "," + String(pzem3.power()); //create message save to database
      if (client.connected()) 
      {        
        digitalWrite(3,1);
        client.publish("saveLog/sub", logMess); //send message save to database
        client.publish("statu/sub/" + deviceID + "/1", statusMess1);  //send message status sensor1     
        client.publish("statu/sub/" + deviceID + "/2", statusMess2);  //send message status sensor2
        client.publish("statu/sub/" + deviceID + "/3", statusMess3);  //send message status sensor3
      }
      unitMillis = millis(); 
    }
  if (!client.connected()) // WiFi not connect
  {
    digitalWrite(3,0);
    connect();
  }
  if(digitalRead(2) == 0) //press the button
  {
    if (millis() - bottomMillis > 5000) //press and hold button 5 seconds
    {
      while(1)
      {
        wifiManager.resetSettings(); //reset setting wifi
        delay(20);
        ESP.reset(); //reset ESP8266
      }       
    }
    else
    {
      if (millis() - blinkMillis > 500) //led blink every 0.5 second
      {
        ledState = !ledState; 
        digitalWrite(3,ledState);
        blinkMillis = millis();
      }
    }
  }
  else
  {
    digitalWrite(3,1);
    blinkMillis = millis();
    bottomMillis = millis(); 
  }
}
