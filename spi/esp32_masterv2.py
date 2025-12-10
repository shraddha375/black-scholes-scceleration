from machine import Pin, SPI
import time

spi = SPI(1,
          baudrate=1_000_000,
          polarity=0,
          phase=0,
          sck=Pin(14),
          mosi=Pin(13),
          miso=Pin(12))

cs = Pin(15, Pin.OUT)
cs.value(1)

def send_black_scholes(S, K, r, sigma, T):
    payload = bytearray([
        0xA0,  # command
        (S >> 8) & 0xFF, S & 0xFF,
        (K >> 8) & 0xFF, K & 0xFF,
        (r >> 8) & 0xFF, r & 0xFF,
        (sigma >> 8) & 0xFF, sigma & 0xFF,
        (T >> 8) & 0xFF, T & 0xFF
    ])

    cs.value(0)
    spi.write(payload)
    cs.value(1)
    time.sleep(0.01)

    # Now read output
    cs.value(0)
    result = spi.read(2)  # two bytes
    cs.value(1)

    price = (result[0] << 8) | result[1]
    print("Call Price:", price)
    return price


while True:
    send_black_scholes(100, 100, 5, 20, 1)
    time.sleep(2)
