-- PINS
DATA_PIN = 6 -- data
SCK_PIN = 7 -- clock
RCK_PIN = 8 -- latch

gpio.mode(DATA_PIN, gpio.OUTPUT)
gpio.mode(SCK_PIN, gpio.OUTPUT)
gpio.mode(RCK_PIN, gpio.OUTPUT)
gpio.write(RCK_PIN, gpio.LOW)
gpio.write(RCK_PIN, gpio.HIGH)
gpio.write(SCK_PIN, gpio.LOW)
gpio.write(DATA_PIN, gpio.LOW)

anode = {128, -- digit 1 from right
         64,  -- digit 2 from right  
         32,  -- digit 3 from right  
         16,  -- digit 4 from right  
         8,  -- digit 5 from right  
         4,  -- digit 6 from right  
         2,  -- digit 7 from right  
         1  -- digit 8 from right       
        }

cathode = {192, -- char 0
             249,  -- char 1  
             164,  -- char 2
             176,  -- char 3 
             153,  -- char 4
             146,  -- char 5
             130,  -- char 6  
             248,  -- char 7
             128,  -- char 8
             144,  -- char 9
             127,  -- char .
             255,  -- blank
        }

function clockTick()
    gpio.write(SCK_PIN, gpio.HIGH)
    gpio.write(SCK_PIN, gpio.LOW)
end

function setLatch()
    gpio.write(RCK_PIN, gpio.HIGH)
    gpio.write(RCK_PIN, gpio.LOW)
end


function shiftOut(datapin, clockpin, value)
    for i=0,7 do
        val = bit.band(value, bit.lshift(1, (7-i)))
        if val > 0 then
            val = 1
        else 
            val = 0
        end
        gpio.write(datapin, val)
        clockTick()
    end
end

function display8x7segment(datapin, clockpin, latchpin, digit, number)
    shiftOut(datapin, clockpin, digit)
    shiftOut(datapin, clockpin, number)
    setLatch()
end


function loop()

    for a_pos, anode_itm in ipairs(anode) do
        for ca_pos, cathode_itm in ipairs(cathode) do
            display8x7segment(DATA_PIN, SCK_PIN, RCK_PIN, anode_itm, cathode_itm)
            tmr.delay(135000)
        end
    end

    for ca_pos, cathode_itm in ipairs(cathode) do
        display8x7segment(DATA_PIN, SCK_PIN, RCK_PIN, 0xff, cathode_itm) 
        tmr.delay(135000)
    end
end
print("start loop")

while true do
    loop()
end