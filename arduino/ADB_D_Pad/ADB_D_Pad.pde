#include <SPI.h>
#include <Adb.h>

#define  BUTTON_LEFT  2
#define  BUTTON_UP    3
#define  BUTTON_DOWN  4
#define  BUTTON_RIGHT  5

Connection * connection;

// Bytes for each button state
byte b1, b2, b3, b4;

// Event handler for shell connection; called whenever data sent from Android to Microcontroller
void adbEventHandler(Connection * connection, adb_eventType event, uint16_t length, uint8_t * data)
{
  if (event == ADB_CONNECTION_RECEIVE)
  {
    // Unused in this case
  }
}

void setup()
{
  // Set pins as input
  pinMode(BUTTON_UP, INPUT);
  pinMode(BUTTON_LEFT, INPUT);
  pinMode(BUTTON_DOWN, INPUT);
  pinMode(BUTTON_RIGHT, INPUT);

  // Enable the internal pullups
  digitalWrite(BUTTON_UP, HIGH);
  digitalWrite(BUTTON_LEFT, HIGH);
  digitalWrite(BUTTON_DOWN, HIGH);
  digitalWrite(BUTTON_RIGHT, HIGH);

  // Init serial port for debugging
  Serial.begin(57600);

  // Init the ADB subsystem.  
  ADB::init();

  // Open an ADB stream to the phone's shell. Auto-reconnect. Use port number 4568
  connection = ADB::addConnection("tcp:4567", true, adbEventHandler);  
}

void loop()
{
  byte b;
  byte msg[2];

  b = digitalRead(BUTTON_UP);
  if (b != b1) {
    msg[0] = BUTTON_UP;
    msg[1] = b ? 0 : 1;
    Serial.println(msg[0],DEC);
    connection->write(2, (uint8_t*)&msg);
    b1 = b;
  }

  b = digitalRead(BUTTON_LEFT);
  if (b != b2) {
    msg[0] = BUTTON_LEFT;
    msg[1] = b ? 0 : 1;
    Serial.println(msg[0],DEC);
    connection->write(2, (uint8_t*)&msg);
    b2 = b;
  }

  b = digitalRead(BUTTON_DOWN);
  if (b != b3) {
    msg[0] = BUTTON_DOWN;
    msg[1] = b ? 0 : 1;
    Serial.println(msg[0],DEC);
    connection->write(2, (uint8_t*)&msg);
    b3 = b;
  }

  b = digitalRead(BUTTON_RIGHT);
  if (b != b4) {
    msg[0] = BUTTON_RIGHT;
    msg[1] = b ? 0 : 1;
    Serial.println(msg[0],DEC);
    connection->write(2, (uint8_t*)&msg);
    b4 = b;
  }
  // Poll the ADB subsystem.
  ADB::poll();
}


