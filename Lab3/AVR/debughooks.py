import random
import System

# Configuration
random_reg = [
    {"registers": [18, 19], "range": [-32767, 32767]}, # 16-bit pair
    {"registers": [20, 21], "range": [-32767, 32767]}, # 16-bit pair
    {"registers": [22],      "range": [-127, 127]}     # 8-bit single
]

def math_round(n, decimals=2):
    multiplier = 10 ** decimals

    return int(n * multiplier + 0.5) / float(multiplier)

def calc_result(data, studio_interface):
    up = data["18_19"] - (3 * data["20_21"])
    bot = 2 + abs(data["22"])

    result = math_round(float(up) / float(bot), 2)

    studio_interface.Print("", "Debug")
    studio_interface.Print("Result: {}".format(result), "Debug")
    studio_interface.Print("Result (HEX): {}".format(hex(int(result * 100) & 0xFFFFFF)), "Debug")

def on_reset(studio_interface, reset_address):

    result = {}

    for data in random_reg:
        regs = data["registers"]
        low, high = data["range"]
        
        val = random.randint(low, high)

        studio_interface.Print("Pair {} set to {}".format(regs, val), "Debug")
        result["_".join(map(str, regs))] = val
        
        if len(regs) > 1:
            unsigned_val = val & 0xFFFF
            bytes_to_write = [unsigned_val & 0xFF, (unsigned_val >> 8) & 0xFF]
        else:
            unsigned_val = val & 0xFF
            bytes_to_write = [unsigned_val]

        for i in range(len(regs)):
            reg_addr = regs[i]
            byte_val = bytes_to_write[i]
            
            val_to_write = System.Array[System.Byte]([byte_val])
            
            studio_interface.WriteMemory(val_to_write, reg_addr, "data")

    calc_result(result, studio_interface)
