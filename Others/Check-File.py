import os
path1 = r"D:\Games\417Server\server\ygopro\script"
path2 = r"D:\Games\script"
fl1 = os.scandir(path1)
fl2 = os.scandir(path2)
for file in fl2:
    if not os.path.exists(path1 + '\\' + file.name):
        os.remove(path2 + '\\' + file.name)
