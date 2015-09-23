namespace java com.openmindnetworks.autoangel.gen


struct LocationInfo
{
       1:required	string	lat,
       2:required	string	lon,
       3:required	string	time
}


service autoangel
{
    void crashInfo(1:LocationInfo locationInfo, 2:string crashText)
}

// Client Side:
// sentTo - You send your Greeting struct here
// ResultReceiver - You get your response here with the Greeting struct
//
//
// Server Side:
// ReceiveFrom - You get the Greeting struct given to you here
// ResultSender - You send back your response in a Greeting struct here


// Adding in Thrift stuff for Arduino, Using this extra definitions to give a more realistic 
// Arduino Test Scenario, Will use J2SE Endpoint for automated communication 

struct Temp
{
    1:required i32 value
}
struct Led
{
    1:required i32 value
}

service Demo
{
    void setLed(1:Led led),
    void setThermostatTemp(1:Temp temp),
    void reportTemp(1:Temp temp),
}
