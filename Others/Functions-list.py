import re
import Modules as m
import os

path = r"D:\Games\YGOPro\script"
dic = os.listdir(path)
ptn = r"[.:](.*?)[(]"
fs = set()
for file in dic:
    if not os.path.isdir(file):
        f = open(path+"/"+file, encoding="utf-8")
        s = ''
        print(file)
        i = iter(f.readlines())
        for ln in i:
            s += ln
        l = re.findall(ptn, s)
        for i in l:
            if m.Check_Str(i):
                fs.add(i)
print('\n'.join(sorted(fs)))
