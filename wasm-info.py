#!/usr/bin/env python3
import sys, struct

def uleb(d, p):
    r = s = 0
    while True:
        b = d[p]; p += 1
        r |= (b & 0x7f) << s
        if not (b & 0x80): break
        s += 7
    return r, p

def name(d, p):
    n, p = uleb(d, p)
    return d[p:p+n].decode('utf-8','replace'), p+n

path = sys.argv[1]
data = open(path, 'rb').read()
assert data[:4] == b'\x00asm', f"{path} is not wasm"
print(f"\n=== {path}  ({len(data)} bytes) ===")

pos = 8
while pos < len(data):
    sid = data[pos]; pos += 1
    size, pos = uleb(data, pos)
    body = data[pos:pos+size]; end = pos + size
    if sid == 0:
        cname, q = name(body, 0)
        if cname == 'target_features':
            cnt, q = uleb(body, q)
            feats = []
            for _ in range(cnt):
                pfx = body[q]; q += 1
                fl, q = uleb(body, q)
                feats.append(body[q:q+fl].decode()); q += fl
            print(f"  custom: target_features -> {', '.join(feats)}")
        elif cname == 'producers':
            print(f"  custom: producers")
            fcount, q = uleb(body, q)
            for _ in range(fcount):
                fname, q = name(body, q)
                vcount, q = uleb(body, q)
                for _ in range(vcount):
                    vn, q = name(body, q)
                    vv, q = name(body, q)
                    print(f"      {fname}: {vn} {vv}")
        else:
            print(f"  custom: {cname}  (size {size})")
    pos = end
