from machine import Pin, SPI
import struct, time

spi = SPI(1,
          baudrate=1_000_000,
          polarity=0,
          phase=0,
          sck=Pin(14),
          mosi=Pin(13),
          miso=Pin(12))

cs = Pin(15, Pin.OUT)
cs.value(1)

def send_param(value):
    cs.value(0)
    spi.write(struct.pack('>H', value))   # big endian 16-bit
    cs.value(1)
    time.sleep_ms(5)

def read_result():
    cs.value(0)
    result = spi.read(2)  # read 2 bytes
    cs.value(1)
    return struct.unpack('>H', result)[0]

# Example values
S     = 1000
K     = 800
r     = 50
sigma = 20
T     = 1000

while True:
    print("Sending parameters...")
    send_param(S)
    send_param(K)
    send_param(r)
    send_param(sigma)
    send_param(T)

    time.sleep(0.5)

    cp = read_result()
    print("Call price =", cp)

    time.sleep(1)
