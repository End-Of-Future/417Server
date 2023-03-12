import sqlite3 as s

conn = s.connect(r"D:\QQ Ducument\D卡\整合包\417整合包.cdb")
datas = conn.execute("SELECT setcode from datas;")
ss1 = set()
ss2 = set()

for row in datas:
    ss1.add(row[0])

for item in sorted(ss1):
    ns = hex(item)
    ns = str(ns)
    ns = ns[2:]
    sl = []
    if len(ns) > 0:
        sl.append(ns[-4:])
        ns = ns[0:-4]
    if len(ns) > 0:
        sl.append(ns[-4:])
        ns = ns[0:-4]
    if len(ns) > 0:
        sl.append(ns[-4:])
        ns = ns[0:-4]
    if len(ns) > 0:
        sl.append(ns[-4:])
        ns = ns[0:-4]
    for i in sl:
        ss2.add(int(i, 16))
for item in sorted(ss2):
    print(hex(item))
