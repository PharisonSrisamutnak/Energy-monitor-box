#include <M5Stack.h>
#include <PZEM004Tv30.h>


#if !defined(PZEM_RX_PIN) && !defined(PZEM_TX_PIN)
#define PZEM_RX_PIN 16
#define PZEM_TX_PIN 17
#endif

#if !defined(PZEM_SERIAL)
#define PZEM_SERIAL Serial2
#endif


#if defined(ESP32)
/*************************
 *  ESP32 initialization
 * ---------------------
 * 
 * The ESP32 HW Serial interface can be routed to any GPIO pin 
 * Here we initialize the PZEM on Serial2 with RX/TX pins 16 and 17
 */
PZEM004Tv30 pzem(PZEM_SERIAL, PZEM_RX_PIN, PZEM_TX_PIN);
#elif defined(ESP8266)

//PZEM004Tv30 pzem(Serial1);
#else

PZEM004Tv30 pzem(PZEM_SERIAL);
#endif

void setup() 
{
  M5.begin(); //Init M5Core.  
  M5.Power.begin(); //Init Power module.  
  M5.Lcd.fillScreen(BLACK); // Set the screen background.  
  M5.Lcd.setTextSize(2);
  delay(500); //Delay 500ms.  
}                           


void loop()
{
    M5.update();
    float voltage = pzem.voltage();
    float current = pzem.current();
    float power = pzem.power();
    float energy = pzem.energy();
    float frequency = pzem.frequency();
    float pf = pzem.pf();
    if(voltage != NAN)
    {
        M5.Lcd.setCursor(0, 20); //Move the cursor position to (x,y).
        M5.Lcd.setTextColor(WHITE , BLACK); //Set the font color to white.  
        M5.Lcd.printf("Voltage : %6.2f V",voltage);  //Serial output format string.

    } 
    else 
    {
        M5.Lcd.setCursor(0, 20); //Move the cursor position to (x,y).
        M5.Lcd.setTextColor(WHITE , BLACK); //Set the font color to white.  
        M5.Lcd.printf("Error reading voltage");  //Serial output format string.
    }
    if(current != NAN)
    {
        M5.Lcd.setCursor(0, 65); //Move the cursor position to (x,y).
        M5.Lcd.setTextColor(WHITE , BLACK); //Set the font color to white.  
        M5.Lcd.printf("Current : %6.2f A",current);  //Serial output format string.
    } 
    else 
    {
        M5.Lcd.setCursor(0, 65); //Move the cursor position to (x,y).
        M5.Lcd.setTextColor(WHITE , BLACK); //Set the font color to white.  
        M5.Lcd.printf("Error reading current");  //Serial output format string.
    }
    if(current != NAN)
    {
        M5.Lcd.setCursor(0, 110); //Move the cursor position to (x,y).
        M5.Lcd.setTextColor(WHITE , BLACK); //Set the font color to white.  
        M5.Lcd.printf("Power : %6.2f W",power);  //Serial output format string.
    } 
    else 
    {
        M5.Lcd.setCursor(0, 110); //Move the cursor position to (x,y).
        M5.Lcd.setTextColor(WHITE , BLACK); //Set the font color to white.  
        M5.Lcd.printf("Error reading power");  //Serial output format string.
    }
    if(current != NAN)
    {
        M5.Lcd.setCursor(0, 155); //Move the cursor position to (x,y).
        M5.Lcd.setTextColor(WHITE , BLACK); //Set the font color to white.  
        M5.Lcd.printf("Power : %6.2f kWh",energy);  //Serial output format string.
    } 
    else 
    {
        M5.Lcd.setCursor(0, 155); //Move the cursor position to (x,y).
        M5.Lcd.setTextColor(WHITE , BLACK); //Set the font color to white.  
        M5.Lcd.printf("Error reading energy",power);  //Serial output format string.
    }

    
    if(current != NAN)
    {
        M5.Lcd.setCursor(0, 210); //Move the cursor position to (x,y).
        M5.Lcd.setTextColor(WHITE , BLACK); //Set the font color to white.  
        M5.Lcd.printf("Frequency : %6.2f Hz",frequency,1);  //Serial output format string.
    } 
    else 
    {
        Serial.println("Error reading frequency");
        M5.Lcd.setCursor(0, 210); //Move the cursor position to (x,y).
        M5.Lcd.setTextColor(WHITE , BLACK); //Set the font color to white.   
        M5.Lcd.printf("Error reading frequency");  //Serial output format string.
    }

//    if(current != NAN){
//        Serial.print("PF: "); Serial.println(pf);
//    } 
//    else 
//    {
//        Serial.println("Error reading power factor");
//    }
    delay(1000);
}
