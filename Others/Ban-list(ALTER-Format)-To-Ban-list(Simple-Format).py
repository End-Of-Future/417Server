f = """
69969178 交响的强援 1
69969205 交响的序曲·原初之种 1
69969209 交响曲·波来罗 0
69969186 交响曲·胡桃夹子 0
69969159 交响的旅途 1
69969170 来发大的？ 2
69969213 交响曲·幻想即兴曲 1
69969184 交响曲·奥菲欧 1
69969155 交响的序曲·庆典 1
69969154 命运的继承 1
69969174 交响的偶遇 1
69969212 交响曲·卡门 1
69969157 交响曲·泰坦 2
69969156 交响的协奏 0
69969204 交响曲·威风堂堂 1
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
