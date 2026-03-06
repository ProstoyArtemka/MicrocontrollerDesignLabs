import random

arr = []

for i in range(16):
    val = random.randint(-127, 127)

    print("\tldi r16,\t", val)
    print("\tst X+,		 r16")

    arr.append(val)

arr = sorted(arr)

print("\n\t; Отсортированный массив должен быть:", arr)
