from random import randint

n = 4
tot = 3 * n ** 2 - 3 * n + 1

c_size = [i + 1 for i in range(n)] + [n - 1, n] * (n - 1) + [i + 1 for i in reversed(range(n - 1))]
assert sum(c_size) == tot

def get_id(c, r):
    global n, tot

    if c <= n - 1:
        return c * (c + 1) // 2 + r
    
    if c <= 3 * n - 3:
        return n * (n + 1) // 2 + (2 * n - 1) * ((c - n) >> 1) + ((c - n) & 1) * (n - 1) + r
    
    return (n + 1) * n // 2 + (n - 1) * (2 * n - 1) + (c - 3 * n + 2) * (5 * n - c - 3) // 2 + r

def decode(id):
    for c in range(4 * n - 3):
        for r in range(c_size[c]):
            if get_id(c, r) == id:
                return c, r

    raise Exception("illegal input")

def get_neighbor(c, r):
    global n, tot

    ret = []
    
    if r > 0 or c in ([n + 2 * i for i in range(n - 1)] + [3 * n - 2 + i for i in range(n - 1)]):
        ret.append(get_id(c - 1, r - (c in ([i for i in range(n)] + [n + 2 * i +1 for i in range(n - 1)]))))

    if r > 0 or c in ([i for i in range(n - 1)] + [n + 2 * i for i in range(n - 1)]):
        ret.append(get_id(c + 1, r - (c in ([n + 2 * i - 1 for i in range(n - 1)] + [3 * n - 3 + i for i in range(n)]))))

    if c < 3 * n - 3 or (0 < r < c_size[c] - 1):
        if c + 2 < n:
            ret.append(get_id(c + 2, r + 1))
        elif c < 3 * n - 3:
            ret.append(get_id(c + 2, r))
        else:
            ret.append(get_id(c + 2, r - 1))

    if r < c_size[c] - 1 or c in ([i for i in range(n - 1)] + [n + 2 * i for i in range(n - 1)]):
        ret.append(get_id(c + 1, r + (c in ([i for i in range(n - 1)] + [n + 2 * i for i in range(n - 1)]))))

    if r < c_size[c] - 1 or c in ([n + 2 * i for i in range(n - 1)] + [3 * n - 2 + i for i in range(n - 1)]):
        ret.append(get_id(c - 1, r + (c in ([n + 2 * i for i in range(n - 1)] + [3 * n - 2 + i for i in range(n - 1)]))))
    
    if c >= n or (r != 0 and r != c_size[c] - 1):
        if c < n:
            ret.append(get_id(c - 2, r - 1))
        elif c <= 3 * n - 2:
            ret.append(get_id(c - 2, r))
        else:
            ret.append(get_id(c - 2, r + 1))

    return ret

def test_id():
    global n, tot

    test = []
    for i in range(n):
        for j in range(i + 1):
            test.append(get_id(i, j))

    for i in  range(n - 1):
        for j in range(n - 1):
            test.append(get_id(n + 2 * i, j))

        for j in range(n):
            test.append(get_id(n + 2 * i + 1, j))


    for i in range(n - 1):
        for j in range(n - 1 - i):
            test.append(get_id(3 * n - 2 + i, j))

    assert [i for i in range(tot)] == test



def test_neighbor():
    for i in range(tot):
        c, r = decode(i)
        for neighbor in get_neighbor(c, r):
            assert i in get_neighbor(*decode(neighbor))


if __name__ == "__main__":
    test_id()
    test_neighbor()