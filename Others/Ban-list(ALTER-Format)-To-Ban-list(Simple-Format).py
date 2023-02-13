f = """
88881652 雾都小队 异能轻剑士 2
88881654 雾都小队 轻装刀戟士 2
88881656 雾都小队 剑装改造人 2
88881660 雾都重装兵械 生存维系者 0
88881662 雾都纪实 塔罗兰 1
88881664 雾都纪实 星列入侵 1
88881666 雾都纪实 雾都旧址 0
88881670 星魔·无心 2
88881676 星魔·无想 1
03654000 机怪操使 1
72100031 大鸟 1
72100034 惩戒鸟 0
72100030 审判鸟 1
"""
sl = f.split("\n")
rl = []
tl = []
for item in sl:
	rl.append(item.split(" "))
for item in rl:
	tl.append(item[0] + " " + item[-1] + " --" + " ".join(item[1:-1]))
for item in tl:
	if item.split(" ")[1] == "0":
		print(item)
for item in tl:
	if item.split(" ")[1] == "1":
		print(item)
for item in tl:
	if item.split(" ")[1] == "2":
		print(item)
