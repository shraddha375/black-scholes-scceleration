## Hardware connections

📌 ESP32 Pins

Using HSPI:

| Signal |  ESP32 GPIO |
|--------|-------------|
|  SCK   |      14     |
|  MOSI  |      13     |
|  MISO  |      12     |
|  CS    |      15     |
|  GND   |      GND    |


📌 Cmod A7-35T PINOUT (DIP Header)

Use these FPGA pins:

|  SPI Signal  |  Cmod A7 DIP Pin  |  FPGA Pin  |   Notes    |
|--------------|-------------------|------------|------------|
| SCK          | A5                |  G17       |SPI clock   |
| MOSI         | A6                |  J18       |ESP32 → FPGA|
| MISO         | A7                |  K15       |FPGA → ESP32|
| CS           | A8                |  L16       |Active-low  |
| GND          | Any GND           |  —         |Needed      |

                                     

