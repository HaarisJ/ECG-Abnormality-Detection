#include <WiFiNINA.h>
#include <Ethernet.h>
#include <MySQL_Connection.h>
#include <MySQL_Cursor.h>
#include <Dns.h>
#include "arduino_secrets.h"

#define Sprintln(a) //(Serial.println(a))
#define Sprint(a) //(Serial.print(a))
#define SAMPLES 3000

int start;
int done;

// Wifi Stuff
char ssid[] = SECRET_SSID;        // your network SSID (name)
char pass[] = SECRET_PASS;    // your network password (use for WPA, or use as key for WEP)
int status = WL_IDLE_STATUS;     // the Wifi radio's status

// SQL Stuff
byte mac_addr[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
IPAddress server_addr(18,217,145,113);  // IP of the MySQL *server* here
char user[] = "arduino";               // MySQL user login username
char password[] = "secret";         // MySQL user login password
WiFiClient client;            // Use this for WiFi instead of EthernetClient
MySQL_Connection conn((Client *)&client);

char INSERT_DATA[] = "INSERT INTO testing.realset_data (id, `index`, `value`) VALUES (%d,%d,%d)";
char query[512];

char INSERT_REALSET[] = "INSERT INTO testing.realset (id) VALUES (%d)";

char SET_FLAG[] = "UPDATE testing.flag SET flag.flag=1 WHERE flag.flag=0;";

char SELECT_DATA[] = "SELECT MAX(id) FROM testing.realset_data;";

// Heartbeat variables
int voutPin = A1;
int sensorValue;

u_int32_t lastMicros = 0;
short reading[SAMPLES];

// Function shows Wifi connection status
void printData() {
  Sprintln("Board Information:");
  // print your board's IP address:
  IPAddress ip = WiFi.localIP();
  Sprint("IP Address: ");
  Sprintln(ip);

  Sprintln();
  Sprintln("Network Information:");
  Sprint("SSID: ");
  Sprintln(WiFi.SSID());

  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Sprint("signal strength (RSSI):");
  Sprintln(rssi);

}

void setup() {
  
  // Getting heartbeat reading
  for (int i=0; i<SAMPLES; i++){
    while(true){
      if (micros() - lastMicros >= 3333) {
        lastMicros = micros();
        sensorValue = analogRead(voutPin);
        reading[i] = sensorValue;
        break;
      }
    }
  }

  analogReadResolution(12);
  delay(1000);
  
  // attempt to connect to Wifi network:
  while (status != WL_CONNECTED) {
    Sprint("Attempting to connect to network: ");
    Sprintln(ssid);
    // Connect to WPA/WPA2 network:
    status = WiFi.begin(ssid, pass);

    // wait 10 seconds for connection:
    delay(10000);
  }

  // you're connected now, so print out the data:
  Sprintln("You're connected to the network");

  Sprintln("----------------------------------------");
  printData();
  Sprintln("----------------------------------------");
  
  // Connecting to SQL database
  Sprintln("Connecting...");
  if (conn.connect(server_addr, 3306, user, password)) {
    delay(2000);

    // Gets last ID from database
    row_values *row = NULL;
    int last_id = 0;

    // Initiate the query class instance
    MySQL_Cursor *cur_mem = new MySQL_Cursor(&conn);
    // Execute the query
    cur_mem->execute(SELECT_DATA);
    // Fetch the columns (required) but we don't use them.
    column_names *columns = cur_mem->get_columns();
  
    // Read the row (we are only expecting the one)
    do {
      row = cur_mem->get_next_row();
      if (row != NULL) {
        last_id = atol(row->values[0]);
      }
    } while (row != NULL);
    // Deleting the cursor also frees up memory used
    delete cur_mem;

    start = millis();
    // Writes data to database
    MySQL_Cursor *cur_mem2 = new MySQL_Cursor(&conn);
    for (int j=0;j<SAMPLES;j=j+1){
      // Save
      sprintf(query, INSERT_DATA, last_id+1, j, reading[j]);
      for (int k=1;k<20;k++){
        sprintf(query, "%s, (%d,%d,%d)", query, last_id+1, j+k, reading[j+k]);
      }
      j=j+19;
      // Execute the query
      cur_mem2->execute(query);
      // Note: since there are no results, we do not need to read any data
      // Deleting the cursor also frees up memory used
    }
    delete cur_mem2;

    done = millis()-start;
    Serial.println(done/1000);

    // Update realset
    MySQL_Cursor *cur_mem3 = new MySQL_Cursor(&conn);
      // Save
      sprintf(query, INSERT_REALSET, last_id+1);
      // Execute the query
      cur_mem2->execute(query);
      // Note: since there are no results, we do not need to read any data
      // Deleting the cursor also frees up memory used
    delete cur_mem3;
    
    // Updates flag for new information
    MySQL_Cursor *cur_mem4 = new MySQL_Cursor(&conn);
    // Save
    sprintf(query, SET_FLAG);
    // Execute the query
    cur_mem3->execute(query);
    // Note: since there are no results, we do not need to read any data
    // Deleting the cursor also frees up memory used
    delete cur_mem4;
    Sprintln("Flag set.");
  }
  else
    Sprintln("Connection failed.");
  conn.close();
}

void loop() {
}
