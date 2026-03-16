import math
import random

r19_18 = 31808
r1_0 = -18182
r2 = 49

print(f"Input: r19:r18 = {r19_18}, r1:r0 = {r1_0}, r2 = {r2}")

up = r19_18 - (3 * r1_0)
bot = 2 + abs(r2)

print(f"Up: {up}")
print(f"Bot: {bot}")

if (bot != 0): 
    print(f"Result: {round(up / bot, 2)}")