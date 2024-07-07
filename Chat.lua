local function CheckRednet(modemToTry)
    rednet.open(modemToTry)
end

local modem
local sides = {"top", "bottom", "left", "right", "front", "back"}

local function IN()
    print("Reading All Incoming Traffic:")
    while true do
        --[[
        string: The event name.
        number: The ID of the sending computer.
        any: The message sent.
        string|nil: The protocol of the message, if provided.

        im using the protocal for the userName here.
        ]]
        local event, sender, message, userName = os.pullEvent("rednet_message")
        if userName ~= "" then
            print(userName.." (ID "..sender.."): "..tostring(message))
        else
            print("ID "..sender..": "..tostring(message))
        end
    end
end

local function OUT(modem)
    print("\nType a username! (leave blank for none):")
    local protocal = io.read()
    print("\nSpecify ID to Send:")
    local ID = io.read()
    print("\nNow type away!: (type RETURN to exit to menu)")
    local function MessageSending()
        local message = io.read()
        if tostring(message) == "RETURN" then
            rednet.close(modem)
            MainMenu()
            return
        end
        local messageSent = (rednet.send(tonumber(ID), message, protocal))
        if messageSent == false then
            print("There was an error sending your message!")
        end
    end
    while true do
        MessageSending()
    end
end

function MainMenu()
    while true do
        for iterations,modemTry in pairs(sides) do
            -- no error
            if modemTry ~= nil and pcall(CheckRednet, modemTry) then
                modem = modemTry
                break
            -- there is an error
            elseif iterations == 6 then
                print("Please connect a modem to your computer and try again!")
                return
            end
        end
        rednet.open(modem)
        print("\nChatting System:")
        print("1. Recieving messages.")
        print("2. Sending messages.")
        local InOrOut = io.read()
        if InOrOut == "1" then
            IN()
        elseif InOrOut == "2" then
            OUT(modem)
        else
            print("That wasn\'t one of the options! (1, 2) did you make a typo?")
        end
    end
end

print("Computer ID: ", os.getComputerID())
MainMenu()
