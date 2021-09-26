def lesson1():
    # Use a breakpoint in the code line below to debug your script.
    a = [1, 2, 3, 4]

    # append at the end
    a.append(5)

    # insert(x, y) - add y after index x
    a.insert(2, 9)

    # get length
    n = len(a)

    # delete at index
    a.pop(1)

    # extend the list a with [x]
    a.extend([1])

    # resize with index
    a = a[0:len(a)-1]

    for i in range(len(a)):
        break

    print(a)

    # range
    for i in range(len(a)-1, -2, -2):
        print(a[i])

    # ord convert char to ASCII code, also:
    print(ord("s"))

    # isalpha
    "s".isalpha()
    "abc"[0].isalpha()
    # isdigit / islower / isupper

    # type conversion
    # int(s)
    # float(s)
    # str(s)
    int("1")

    # case conversion
    # lower(s)
    # upper(s)

    # ASCII upper / lowercase
    # chr converts ASCII to char
    chr(ord("s") - 32)

    # input() Accept stdin
    # split() split string into list
    line = input().split()
    print(line)

    print(f'Hi, {a} - {n}')  # Press ⌘F8 to toggle the breakpoint.

# https://bigocoder.com/courses/74/lectures/1138/problems/487?view=statement
def practice1():
    total = 0
    button = input()
    buttons = input().split()

    if int(button) == 1:
        if int(buttons[0]) == 1:
            print("YES")
        else:
            print("NO")
        exit(0)

    for i in buttons:
        if int(i) == 1:
            total += 1

    if total == int(button) - 1:
        print("YES")
    else:
        print("NO")

# https://bigocoder.com/courses/74/lectures/1138/problems/492?view=statement
def practice2():
    value = list(input())
    total = 0

    value.insert(0, "a")

    for i in range(len(value)-1):
        distance = abs(ord(value[i]) - ord(value[i+1]))
        total += 26 - distance if 26 - distance < distance else distance
    print(total)

# https://bigocoder.com/courses/74/lectures/1138/problems/528?view=statement
def practice3():

    minutes_count = input()
    minutes = input().split()

    consecutive_period = 0

    minutes.insert(0, '0')
    minutes.insert(int(minutes_count) + 1, '90')

    # how to convert whole list to int
    minutes = [int(x) for x in minutes]

    for i in range(int(minutes_count) + 1):
        difference = 0
        difference = minutes[i+1] - minutes[i]
        if difference <= 15:
            consecutive_period += difference
        else:
            consecutive_period += 15
            break

    print(consecutive_period)

# https://bigocoder.com/courses/74/lectures/1138/problems/493?view=statement
def practice4():

    first_string = list(input())
    second_string = list(input())
    count = 0

    first_string = [ord(x) for x in first_string]
    second_string = [ord(x) for x in second_string]
    third_string = first_string

    # print(first_string)
    # print(second_string)
    if len(first_string) < 2 and (second_string[0] - first_string[0] > 1):
        print(chr(first_string[0]+1))
        exit(0)

    for i in range(len(first_string)):
        if (second_string[i] - first_string[i] != 0) and (i < len(first_string) - 1):
            count += 1
            if third_string[i+1] < ord('z'):
                third_string[i+1] += 1
            else:
                third_string[i+1] = ord('a')
                third_string[i] = second_string[i]
                continue
            break

    # print(third_string)
    if count == 0:
        print("No such string")
        exit(0)
    third_string = [chr(x) for x in third_string]
    print(''.join(third_string))


def practice5():
    array_lengths = input().split()
    pick_count = input().split()
    array0 = input().split()
    array1 = input().split()

    array_lengths = [int(x) for x in array_lengths]
    pick_count = [int(x) for x in pick_count]
    array0 = [int(x) for x in array0]
    array1 = [int(x) for x in array1]

    # To get first x elements from list
    # To get last x elements from list
    if not array_compare(array0[:pick_count[0]], array1[-pick_count[1]:]):
        print('NO')
    else:
        print('YES')


def array_compare(array0, array1):
    if len(array0) == 0 or len(array1) == 0:
        return False

    # Iterate the smaller one to the bigger one
    for a1 in range(len(array1)):
        for a0 in range(len(array0)):
            if array0[a0] >= array1[a1]:
                return False
        return True


def practice6():
    num = int(input())
    segments = []

    if num == 1:
        print(1)
        exit()
    if num == 0:
        print(-1)
        exit()
    for i in range(num):
        segments.append([int(x) for x in input().split()])

    i = 0
    j = 0

    for i in range(num):
        count = 0
        for j in range(num):
            if i == j:
                # This continue on the current loop
                continue
            if segments[i][0] <= segments[j][0] and segments[i][1] >= segments[j][1]:
                count += 1
            else:
                # this break will exit the inner loop, but continue with the outer loop!
                break
            if count == int(num) - 1:
                print(i+1)
                exit()

    print(-1)


# https://bigocoder.com/courses/74/lectures/1138/problems/1052?view=submissions
def practice7():
    input_value = input().split()
    num = int(input_value[0])

    passwords = []
    for i in range(num):
        passwords.append(input())

    fail = int(input_value[1])
    correct_password = input()

    best = 0
    worst = 0
    count = 0

    passwords.sort(key=len)

    # best
    for password in passwords:
        if len(passwords[0]) == len(correct_password):
            best = 1
            break
        best += 1
        count += 1
        if count == fail:
            best += 5
            count = 0
        if len(password) == len(correct_password):
            break
        elif len(password) < len(correct_password):
            pass

    count = 0
    # worst
    for password in passwords:
        worst += 1
        count += 1
        if count == fail:
            worst += 5
            count = 0
        if len(password) <= len(correct_password):
            pass
        else:
            worst -= 1
            break

    # edge cases
    if num == fail or fail == 1:
        worst -= 5

    print(f'{best} {worst}')

# https://bigocoder.com/courses/74/lectures/1138/problems/1053?view=submissions
def practice8():
    str1 = input()
    str2 = input()

    # dict to count # of char
    ch_str1 = {}
    ch_str2 = {}

    for ch in str1:
        # Set default value for key with no value
        ch_str1.setdefault(ord(ch) - 97, 0)
        ch_str1[ord(ch) - 97] += 1
    for ch in str2:
        ch_str2.setdefault(ord(ch) - 97, 0)
        ch_str2[ord(ch) - 97] += 1

    need_tree = False
    automaton = False
    array = False

    for i in range(25):
        ch_str1.setdefault(i, 0)
        ch_str2.setdefault(i, 0)
        if ch_str1[i] < ch_str2[i]:
            need_tree = True
            break
        if ch_str1[i] > ch_str2[i]:
            automaton = True

    match = -1
    for i in range(len(str2)):
        pos = str1.find(str2[i], match + 1, len(str1))
        if pos == -1:  # not found
            array = True
            break
        match = pos

    if need_tree:
        # When char in t but not in s
        # When # char in t more than s
        print('need tree')
    elif array and automaton:
        print('both')
    elif array:
        # See https://docs.google.com/document/d/1Y1xclob9h-m-44CkOermRpJzogT29q5eWgaoGpnD0DY/edit
        print('array')
    else:
        print('automaton')


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    practice8()
