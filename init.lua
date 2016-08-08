function startup()
    print('in startup (6 sec)')
    dofile('led7x8.lua')
    end

tmr.alarm(0,6000,0,startup)