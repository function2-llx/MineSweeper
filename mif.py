from random import randint, shuffle

n = 5
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

def get_neighbor(pos):
    global n, tot
    c, r = decode(pos)
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
        for neighbor in get_neighbor(i):
            assert i in get_neighbor(neighbor)

lei_num = 10

lei = [1] * lei_num + [0] * (tot - lei_num)
shuffle(lei)
print(lei)

if __name__ == "__main__":
    test_id()
    test_neighbor()

    import sys
    with open('grid.mif', 'w') as f:
        # lei = 0
        sys.stdout = f

        print('depth = {};'.format(tot))
        print('width = 4;')
        print('address_radix = uns;')
        print('data_radix = bin;')

        print('content begin')
        
        for i in range(tot):
            print('    {}: {};'.format(i, ('0000' + bin(lei[i] << 3 | sum(lei[n] for n in get_neighbor(i))).replace('0b', ''))[-4:]))

        print('end;')

    sys.stderr.write('sum: {}'.format(sum(lei)))