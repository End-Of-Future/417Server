f = """
189122 皓端之机界骑士 2
213880024 血魄树 温迪戈 1
14770001 冻原之影 寒灾 1
98910514 群侠聚金庸 2
98910507 武林神兵 1
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
