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
unsigned long blynkMillis = 0;

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

String deviceID = "********"; //repleace ******** whith ID_Device

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
  while (!client.connect("arduino", "mymqtt", "myraspi")) {
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

  client.begin("35.185.185.123", net);
  //client.onMessage(messageReceived);

  connect();


  pinMode(2,INPUT);
  pinMode(3,OUTPUT);
  digitalWrite(2,1);
  unitMillis = millis();
  blynkMillis = millis();
  bottomMillis = millis(); 

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
      statusMess1 = String(voltage1) + "," + String(current1,3) + "," + String(power1,3);
      statusMess2 = String(voltage2) + "," + String(current2,3) + "," + String(power2,3);
      statusMess3 = String(voltage3) + "," + String(current3,3) + "," + String(power3,3);
      logMess = String(deviceID) + "," + String(pzem1.power()) + "," + String(pzem2.power()) + "," + String(pzem3.power()); //
      if (client.connected()) 
      {        
        digitalWrite(3,1);
        client.publish("saveLog/sub", logMess);
        client.publish("statu/sub/" + deviceID + "/1", statusMess1);     
        client.publish("statu/sub/" + deviceID + "/2", statusMess2);
        client.publish("statu/sub/" + deviceID + "/3", statusMess3);    
      }
      unitMillis = millis(); 
    }
  if (!client.connected()) 
  {
    digitalWrite(3,0);
    connect();
  }
  if(digitalRead(2) == 0)
  {
    if (millis() - bottomMillis > 5000) 
    {
      wifiManager.resetSettings();
      delay(20);
      ESP.reset();
      bottomMillis = millis(); 
    }
    else
    {
      if (millis() - blynkMillis > 500) 
      {
        ledState = !ledState;
        digitalWrite(3,ledState);
        blynkMillis = millis();
      }
    }
  }
  else
  {
    digitalWrite(3,1);
    blynkMillis = millis();
    bottomMillis = millis(); 
  }
}
