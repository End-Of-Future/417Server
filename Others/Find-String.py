import os
import re

path = r"D:\Games\YGOPro\script"
dic = os.listdir(path)
ptn = r"[.:](.*?)[(]"
string = input()
for file in dic:
    if not os.path.isdir(file):
        f = open(path+"/"+file, encoding="utf-8")
        s = ''
        i = iter(f.readlines())
        for ln in i:
            s += ln
        if s.find("." + string + "(") != -1 or s.find(":" + string + "(") != -1:
            print(file)
