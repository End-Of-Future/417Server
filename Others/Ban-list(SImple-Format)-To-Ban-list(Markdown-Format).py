import Modules
bl = """
#forbidden
27819031 0 --圣光战士
27819019 0 --圣光飞龙-正义吟唱
27819023 0 --圣光女神-阿尔托莉雅
27819035 0 --圣光之勇者 哉佩利敖
27819021 0 --圣光-含光承影
27822031 0 --圣光之源石
27819048 0 --圣光能转换
27819006 0 --圣光天域
27819015 0 --圣光终临
27819017 0 --圣光之矛
27819025 0 --圣水晶-圣光飞龙
27819080 0 --升阶魔法-五王凯旋
27819059 0 --五王的意志
27819078 0 --五王-天启修诺
27819089 0 --五王-启元极
27822036 0 --激流-冰流帝
27822027 0 --通往深渊的激流之路
27822003 0 --激流-后浪奔逐
15000121 0 --林中鹿
27822021 0 --激流海灵龙
27822019 0 --激流飞龙-裂变
27822004 0 --激流-后浪奔逐
95780032 0 --机械维度 矿物开采员
60001202 0 --炙热而冰冷的元素鸡尾酒
60001203 0 --冰冷而风暴的元素鸡尾酒
60001204 0 --风暴而炙热的元素鸡尾酒
60001205 0 --炙热难当的元素鸡尾酒
60001206 0 --冰冷刺骨的元素鸡尾酒
60001207 0 --风暴呼啸的元素鸡尾酒
10700003 0 --学园孤岛 若狭悠里
268947311 0 --德拉科尼亚·帝国统帅
274513330 0 --德拉科尼亚·潜匿部队
95780010 0 --机械维度 爱染明王
27822034 0 --激流之源石
88880101 0 --默契交锋
27819018 0 --圣光封印
95780026 0 --机械维度 快鲨艇
69969209 0 --交响曲·波来罗
69969186 0 --交响曲·胡桃夹子
60001220 0 --黄金之靴
88881660 0 --雾都重装兵械 生存维系者
88881666 0 --雾都纪实 雾都旧址
72100034 0 --惩戒鸟
95780022 0 --机械维度 异维度神 阎
95780021 0 --机械维度 异维度神 亡
10703003 0 --战华阴鬼-神甘宁
88881746 0 --废墟兵械 风神翼龙
#limit
15003023 1 --虚空孔穴·格利扎
15004110 1 --四次元洞·布鲁顿
15004108 1 --壹世坏交织的细波
07409797 1 --风驰电掣
10703000 1 --战华大宝-界徐盛
10703006 1 --战华大妖-神郭嘉
10703009 1 --战华老宝-谋黄忠
10703012 1 --战华大苟-神荀彧
27822012 1 --激流之界士
27822010 1 --激流之共鸣灵
27822011 1 --激流飞龙之心
27822014 1 --激流之送葬士
27822024 1 --激流海灵龙
27822013 1 --激流之叠光灵
01543673 1 --原子龙
10105723 1 --盖亚记忆体-极限
10105720 1 --风车都市-风都
10105408 1 --秀逗缝合灵·冷酷姨妈
10105402 1 --秀逗缝合灵·爱杀老妹
10105403 1 --秀逗缝合灵·肢离破碎女仆团
91460007 1 --设酒杀鸡作食
10105603 1 --流星黑龙·世界熔坏
10105600 1 --真红眼黑龙·烧灭一切
10105636 1 --光道恶魔 欧格里
10105650 1 --命运英雄 惊慌人
10105646 1 --装备了武器手套的超级小蓝
10105649 1 --未来龙皇·洗衣龙女
10105640 1 --破坏剑的转生妖龙
10105645 1 --小蓝骑龙
10105637 1 --正义到临
10105648 1 --洗衣龙龙强强联合
10105656 1 --学习忍术归来的小蓝
10700000 1 --学园孤岛 惠飞须泽胡桃
10700090 1 --新年祈愿 若狭悠里
87498096 1 --屠戮生将军 阿罗娑迦鬼
95780016 1 --机械维度 尖塔
95780019 1 --机械维度 暴走蟹
95780020 1 --机械维度 炮击兵
27819039 1 --圣光之神女-诺雅
27819044 1 --圣光飞龙的言灵
27819037 1 --圣光追逐者
27819002 1 --圣光飞龙的灵魂
27819043 1 --圣光飞龙的圣灵
27819022 1 --圣光救赎天使
27819012 1 --圣光-守望之碑
27819016 1 --通往天堂的圣光之路
60001000 1 --调酒师 卢娜
10700009 1 --学园孤岛 直树美纪
10700012 1 --学园孤岛 丈枪由纪
213452914 1 --德拉科尼亚的征召命令
213452974 1 --德拉科尼亚帝国
923154627 1 --通常融合
66300007 1 --烈火战神·炙烧结界
88880103 1 --恐啡肽狂龙·钉状龙
10105623 1 --青眼白龙，哈哈哈
914206451 1 --真龙斗士 十二宫·天秤
66300004 1 --烈火战神·红缨
30679180 1 --自律部队·补给中枢
88885503 1 --龙剑士 星辰·灵摆
60001200 1 --调酒师 卢娜
10105644 1 --传说中的白石（迫真）
69969178 1 --交响的强援
69969205 1 --交响的序曲·原初之种
69969159 1 --交响的旅途
69969213 1 --交响曲·幻想即兴曲
69969184 1 --交响曲·奥菲欧
69969155 1 --交响的序曲·庆典
69969154 1 --命运的继承
69969174 1 --交响的偶遇
69969212 1 --交响曲·卡门
69969204 1 --交响曲·威风堂堂
88881100 1 --灭龙剑士 阿耆尼马兹德·消灭
88881104 1 --真龙剑凰 玛丽亚姆内
60001221 1 --战栗的海盗旗
60001212 1 --空绝的崇拜者
60001225 1 --海潮炮手
60001219 1 --大洋斥候
88881662 1 --雾都纪实 塔罗兰
88881664 1 --雾都纪实 星列入侵
88881676 1 --星魔·无想
03654000 1 --机怪操使
72100031 1 --大鸟
72100030 1 --审判鸟
66000000 1 --夜行的领路人 滑头鬼
66060008 1 --幻星集 力量
66060015 1 --幻星集 恶魔
66060004 1 --幻星集 皇帝
88881730 1 --废墟兵械 剑龙
88881732 1 --废墟兵械 迅猛龙
88881740 1 --废墟兵械 伶盗龙
88881700 1 --蚀暗兽 圣印鹿
88881780 1 --星魔·无限
88881782 1 --雾都重装兵械 星理捍卫者
04878130 1 --清净圣天使
213880024 1 --血魄树 温迪戈
14770001 1 --冻原之影 寒灾
98910507 1 --武林神兵
#semi-limit
10703015 2 --奇正相生
13131359 2 --奥西里斯的天空龙-神之盾
914206454 2 --真龙斗士 十二宫·狮子
88880100 2 --倪克斯神谕
27822001 2 --激流之先灵
15004459 2 --终诞唤核士·泽内妲
15004466 2 --终诞唤核士·伊芙琳
15004493 2 --始于终世的救赎之核
10105409 2 --缝合灵谜家墓园
10105406 2 --秀逗缝合灵·黑化老爹
66300000 2 --烈火战神 藏身处
91460003 2 --小口
91460005 2 --村舍
95780024 2 --机械维度 冲锋兵
95780017 2 --机械维度 风巫
95780028 2 --机械维度 刃牙·苍翔
27819036 2 --圣光飞龙的御主
27819004 2 --圣光飞龙的使者
60002114 2 --神秘皇后·梅迪
66300001 2 --烈火战神·烈焰
60002113 2 --奇幻士兵
914206452 2 --真龙斗士 十二宫·处女
91460010 2 --太守
91460011 2 --刘子骥
95780014 2 --机械维度 海妖
10105620 2 --狗子
10105638 2 --破坏之剑士-狂斩
91460002 2 --忽逢桃花林
69969170 2 --来发大的？
69969157 2 --交响曲·泰坦
88881652 2 --雾都小队 异能轻剑士
88881654 2 --雾都小队 轻装刀戟士
88881656 2 --雾都小队 剑装改造人
69969156 2 --交响的协奏
66060021 2 --幻星集 审判
88881744 2 --废墟兵械的起源地
00189122 2 --皓端之机界骑士
98910514 2 --群侠聚金庸
66060002 2 --幻星集 女祭司
66060030 2 --幻星集 命运之占卜
"""
bcs = bl.split("#")
bcs[1] = bcs[1].split("\n")[1:-1]
bcs[2] = bcs[2].split("\n")[1:-1]
bcs[3] = bcs[3].split("\n")[1:-1]
Modules.pnt_Simple(bcs[1], bcs[2], bcs[3])

