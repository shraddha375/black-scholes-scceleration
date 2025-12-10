from machine import Pin, SPI
import time

# SPI setup - HSPI (SPI1)
spi = SPI(1,
    baudrate=1_000_000,
    polarity=0,
    phase=0,
    sck=Pin(14),
    mosi=Pin(13),
    miso=Pin(12)
)

cs = Pin(15, Pin.OUT)
cs.value(1)

def spi_send(byte_val):
    cs.value(0)
    spi.write(bytes([byte_val]))
    cs.value(1)
    print("Sent:", hex(byte_val))
    time.sleep(0.1)

while True:
    spi_send(0xA5)
    time.sleep(1)
    spi_send(0x5A)
    time.sleep(1)
