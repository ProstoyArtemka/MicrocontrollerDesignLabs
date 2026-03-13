import math

r0 = -10
r1 = -5
r2 = 25

result = 0

for k in range(8):
    subtract = r0 - math.pow(r1, k)

    sum = math.sqrt(abs(2.56 + (r2 * k)))

    if (sum == 0): continue

    result += subtract / sum

    print(f"Iter {k} = {subtract / sum}")

print(f"Result: {result}")