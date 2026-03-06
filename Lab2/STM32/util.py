import random

arr = []

val = random.randint(0, 255)

print("\tMOV R1,\t#" + str(val))
print("\tSTRB R1, [R0]")

arr.append(val)

for i in range(15):
    val = random.randint(0, 255)

    print("\tMOV R1,\t#" + str(val))
    print("\tSTRB R1, [R0, #"+ str(i + 1) + "]")

    arr.append(val)

arr = sorted(arr)

print("\n\t; Отсортированный массив должен быть:", arr)
