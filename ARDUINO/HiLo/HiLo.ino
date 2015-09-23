#include <SPI.h>
#include <WiFi.h>
#include <WiFiClient.h>
#include <WiFiServer.h>
#include <WiFiUdp.h>
  
#include <Arduino.h>
#include "libgolgi.h"
#include "GolgiGen.h"
#include "GOLGI_KEYS.h"
#include <sys/stat.h>

#define WIFI_SSID "Guest_DCU_Innovation"     //  your network SSID (name)
#define WIFI_PASS "innovate5443"    // your network password



// ==============================================================================================
int tempSensorValue = 0;
int thermostatValue = 0;

static GolgiAPIImpl *golgiAPIImpl;
static GolgiNetInterface *netIf = NULL;


/*
 * Crash Reporting setup and classes
*/
class SetThermostatTempReceiver: public DemoSetThermostatTempRequestReceiver
{
public:
    SetThermostatTempReceiver()
    {
        //Serial.println("Initialise output pins");
	//pinMode(LED_PIN, OUTPUT);
	//digitalWrite(LED_PIN, LOW);
    };

    void registerReceivers(void)
    {
        DemoRegisterSetThermostatTempRequestReceiver(this);
    };
    
    void inboundSetThermostatTemp(DemoSetThermostatTempResultSender *resultSender, Demo_setThermostatTemp_reqArg *arg)
    {
        Serial.print("Set ThermoStat to value: ");
        Serial.println(arg->getTemp()->getValue());
        
        thermostatValue = arg->getTemp()->getValue();
        
	resultSender->success();
    };
    
    ~SetThermostatTempReceiver()
    {
    };
};


/*
 * Sending Temperature
*/

class TempResultReceiver: public DemoReportTempResultReceiver
{
  public:
    TempResultReceiver(void)
    {
    }
    ~TempResultReceiver(void)
    {
    }
    void success(void)
    {
        Serial.println("Temp reported: successfully");
       delete this;
    }
    void errorWithGolgiException(GolgiException *gex)
    {
        Serial.println("Temp reported: " + String(gex->getErrType()) + "/" + String(gex->getErrText()));
        delete this;
    }
};


void sendTempSensorValue(int tsv)
{
  Demo_reportTemp_reqArg *reqArg = new Demo_reportTemp_reqArg();
  Temp *temp = new Temp();
  temp->setValue(tsv);

  reqArg->setTemp(temp);
  DemoReportTemp_sendTo(new TempResultReceiver(),
                       "IOS",
                       reqArg);
  delete(reqArg);
}

// =====================================================================================

GolgiNetInterface *setupNetwork(){
    Serial.print("Waiting for WiFi shield to spin up:");
    for(int i = 0; i < 5; i++){
        Serial.print(".");
        delay(1000);
    }
    Serial.println("DONE");
    Serial.println("Firmware Version: " + String(WiFi.firmwareVersion()));

    Serial.println("Attempting to connect to WPA network: ");

    int wifiStatus = WL_IDLE_STATUS;
    wifiStatus = WiFi.begin(WIFI_SSID, WIFI_PASS);

    // if you're not connected, stop here:

    if ( wifiStatus != WL_CONNECTED) {
      Serial.println(String("Couldn't get a wifi connection ") + String(wifiStatus)) ;
      while(true);
    }

    return new GolgiNetWifi();
}


bool exists_test () 
{
  struct stat buffer;   
  return (stat ("/sketch/sendmsg", &buffer) == 0); 
}

// the setup function runs once when you press reset or power the board
void setup()
{
  Serial.begin(115200);
  
  Serial.println("Setup Network Interface to use and register with Golgi");
  system("/home/root/anaconda/bin/python /home/root/twillo/serial_call.py &");
  
  netIf = setupNetwork();  
  golgiAPIImpl = new GolgiAPIImpl(netIf, GOLGI_APPKEY, GOLGI_DEVKEY, "ARDUINO");
}


// the loop function runs over and over again forever
void loop()
{  
   tempSensorValue = 300;
    
  Serial.print("Temperature Sensor Value: ");
  Serial.println(tempSensorValue);
  
  // Only Send a Notification of a crash if there exists a file /sketch/sendmsg
  // If there is, send notification to App and delete the file so as not to get further positive
  
  if (exists_test())
  {
      sendTempSensorValue(tempSensorValue);
      //Delete File
      system("rm /sketch/sendmsg");
  }
  
  delay(2000);
      
  golgiAPIImpl->service();
  netIf->service();
}
