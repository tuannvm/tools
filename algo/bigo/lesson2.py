# https://bigocoder.com/courses/74/lectures/1139/problems/523?view=statement
# O(n)
def practice1():
    n, t = map(int, input().split())
    arr = list(map(int, input().split()))
    total = cnt = 0
    total_book = 0
    read_book = 0

    for i in range(n):
        # increase the time per each book
        total += arr[i]
        # if total so far > t time
        if total > t:
            # remove the time to read the first book in the series
            total -= arr[cnt]
            # mark the new first book in the series
            cnt += 1
            # don't count as we read 1 new and remove 1 old
            continue
        # count the book
        read_book += 1
        # compare the current read & previous read, take max
        total_book = max(total_book, read_book)

    print(total_book)


# https://bigocoder.com/courses/74/lectures/1139/problems/522?view=statement
# O(n + m)
def practice2():
    n, m = map(int, input().split())
    a = list(map(int, input().split()))
    b = list(map(int, input().split()))
    cnt = index = 0

    # 2 pointers
    while cnt < n and index < m:
        # if component in a < b', move on
        if a[cnt] <= b[index]:
            cnt += 1
        # if not? ==> a > b, increase b to compare a <> b[i+1]
        index += 1

    # total - (excluded records) = result records
    print(n - cnt)


# https://bigocoder.com/courses/74/lectures/1139/problems/524?view=submissions
# https://codeforces.com/problemset/status/161/problem/A?order=
# O(max(n, m))
def practice3():
    n, m, x, y = map(int, input().split())
    a = list(map(int, input().split()))
    b = list(map(int, input().split()))
    result = []
    i = j = 0

    while i < n and j < m:
        # if condition matches, add to result list
        # move to next desired & available size
        if a[i] - x <= b[j] <= a[i] + y:
            result.append([i + 1, j + 1])
            i += 1
            j += 1
        # if available size < min desired size
        # move to next available size
        elif b[j] < a[i] - x:
            j += 1
        # if available size > max desired size
        # move to next desired size
        elif b[j] > a[i] + y:
            i += 1

    print(len(result))
    for r in result:
        print(' '.join(map(str, r)))


# https://codeforces.com/problemset/problem/224/B
# O(n)
def practice4():
    n, k = map(int, input().split())
    a = list(map(int, input().split()))
    unique = i = j = 0
    # A way to create dict with predefine value
    count = [0] * 100001

    # If the required unique records > actual unique records
    # print -1 -1
    if k > len(list(set(a))):
        print("-1 -1")
        exit()

    while i < n:
        # if the record is unique
        if count[a[i]] == 0:
            # increase total unique count
            unique += 1
        # keep track of the record appearance
        count[a[i]] += 1
        # if the total unique count match the requirement
        if unique == k:
            # infinite loop
            while True:
                # if the appearance for the particular record > 1
                if count[a[j]] > 1:
                    # decrease by 1
                    count[a[j]] -= 1
                    # move the pointer to right
                    j += 1
                # if the appearance already = 1 --> can not move further
                else:
                    print(j + 1, i + 1)
                    exit()
        i += 1


def practice5():
    n = int(input())
    a = list(map(int, input().split()))
    i = 0
    j = n - 1
    # away to create a dict with predefined value
    result = [0] * 2
    player = 0

    # if array len still > 0
    while n > 0:
        # check which card is bigger
        if a[i] > a[j]:
            result[player] += a[i]
            # leftmost card bigger --> remove
            i += 1
        else:
            result[player] += a[j]
            # rightmost card bigger --> remove
            j -= 1

        # decrease length
        n -= 1
        if n < 1:
            break

        # switch player
        player = 1 - player

    print(result[0], result[1])


def practice6():
    n = int(input())
    a = list(map(int, input().split()))

    # initiate the array to keep track of the appearance
    count = [0] * (10 ** 5 + 1)
    i = j = 0
    # variable to count the difference, the difference need to <= 2 in order to match the requirement
    diff = 0
    value = 0

    while i < n:
        # if not appear yet
        if count[a[i]] == 0:
            # the subset diff += 1
            diff += 1
        # count the appearance
        count[a[i]] += 1

        # if diff in subset > 2 --> no match requirement --> increase j
        while diff > 2:
            # if the component appears only one
            # which means, remove it with decrease the difference
            # if the component appears twice or more, remove one doesn't change the diff
            if count[a[j]] == 1:
                diff -= 1
            # decrease the appearance of the component at j
            count[a[j]] -= 1
            # increase j
            j += 1

        value = max(value, i - j + 1)
        i += 1

    print(value)


def practice7():
    n = int(input())
    a = list(map(int, input().split()))
    count = 0
    remain = n
    i = n
    while i > 0:
        # going backward in the list
        i -= 1
        # Check if the person still alive or not
        # If yes, count
        if i < remain:
            count += 1
        # kill the people in front
        # In a case the the claw is too long, might not enough ppl to kill
        # So that just take minimum
        # Also, at the beginning least always > i - a[i]
        remain = min(i - a[i], remain)
    print(count)


def practice8():
    n = int(input())
    t = list(map(int, input().split()))
    i = a = b = 0
    j = n - 1

    # Alice eats from the left, Bob eats from the right
    # i & j come toward each other
    while i <= j:
        # If the total time Alice use to eat is less, she can move on and eat the next one
        if a < b:
            a += t[i]
            i += 1
        # If the total time Bob use to eat is less, he can move on and eat the next one
        elif a > b:
            b += t[j]
            j -= 1
        # If the time is equal for the ith pie, both of them move on
        else:
            a += t[i]
            b += t[j]
            i += 1
            j -= 1

    print(i, n - i)


if __name__ == "__main__":
    practice8()
