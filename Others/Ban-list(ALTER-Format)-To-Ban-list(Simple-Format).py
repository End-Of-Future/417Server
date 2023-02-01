f = open("审核报告.txt", mode='r', encoding="utf-8")
sl = f.readlines()
rl = []
tl = []
for item in sl:
	i = item[0:item.index('\n')]
	rl.append(i.split(" "))
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
