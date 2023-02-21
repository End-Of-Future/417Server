# Func-Document
你可以在这里查询到由 -k/3 整合的所有（共计736个）函数的信息。  
只有满足以下条件的函数被统计：
+ 使用 `.` 调用。即形如 `<something>.<function_name>(<something>`
+ 使用 `:` 调用。即形如 `<something>:<function_name>(<something>`

# 辅助脚本
该文件夹下的 `Functions-list.py` 和 `Find-String.py`。

# 类简介
## Card
该类表示1张卡。
### 获取类的实例
该类不存在构造函数。一般地，不能创造新的实例。常见的获取实例的方法是调用任意一个返回 `Card` 的函数。
## Effect
该类表示1个效果。
### 获取类的实例
该类不存在构造函数。常见的获取实例的方法是调用 `Effect.CreateEffect` 函数，或是任意一个返回 `Effect` 的函数。
## Group
该类表示1个卡片组。
### 获取类的实例
该类不存在构造函数。常见的获取实例的方法是调用 `Group.CreateGroup` 或 `Group` 类下任意一个函数首字母为 `_` 的函数，或是任意一个返回 `Group` 的函数。
### 实例的特征
每个实例实际上是数个卡片组成的。
#### 互异性
同一张卡片在同一个实例内只能出现 $1$ 次。
#### 有序性
同一个实例内的所有卡片的相对顺序不可更改。
### 特别的表示方法
为书写方便，在文档中定义一些特殊的表示方法。
#### $∀_c$ in x
表示对于x中的每一张卡。  
特别地，当a是 $∅$ 时，不表示任何卡。
#### $-$
a $-$ b 表示：$∀_c$ in a，如果 c $∈$ b，则从a中删除c。
#### $∈$
x $∈$ g 表示x在g中。
#### $∉$
x $∉$ g 表示x不在g中。
#### $∩$
a $∩$ b 表示在a**并**在b中存在的卡组成的 `Group`。
#### $∪$
a $∪$ b 表示在a**或**在b中存在的卡组成的 `Group`。
#### $∅$
当g中没有卡时，称g是 $∅$。
#### xor
a xor b 返回 (a $∪$ b) $-$ (a $∩$ b)。

# 函数列表
根据函数名的首字母分类。不根据函数的父类分类。  
若无特殊说明，`Card` 类、`Group` 类、`Duel` 类不在任何文件中定义。`aux` 表在 `utility.lua` 中定义。  
除去 `getMonsters` 和 `getTypes` 两个以小写字母为首字母的函数以外，所有函数均以字典序排列。
## A
### aux.AND
##### 声明语句(Lua)
```lua
function Auxiliary.AND(...)
```
##### 接受参数
数个 `function`。
##### 返回值
一个 `function`，接受数个参数，返回 `any`。  
该函数会执行每一个 `AND` 传入的函数，记录执行后的结果。执行时，填入该**返回的**函数接受的参数。  
该**返回的**函数会返回这些结果中第一个为假，**或**最后一个不为假的结果。

### AddCard
有歧义。
#### Group.AddCard
##### 声明语句(C++)
```cpp
void Group.AddCard(Group g, Card c)
```
##### 返回值
`nil`。
##### 用途
若c $∈$ g，则不执行任何操作。否则，在g中添加c。
#### Debug.AddCard
不在任何文件中定义。
##### 声明语句(C++)
```cpp
Card Debug.AddCard(int code, int owner, int player, int location, int seq, int pos bool proc)
```
##### 返回值
`Card`。
##### 用途
添加卡片，将卡号为 `code` 的卡片的持有者设置为 `owner` ，以表示形式 `pos` 放置在 `player` 的场上位于 `location` 上序号为 `seq` 的格子处。  
参数 `proc` 不传入时为 `false`。若 `proc` 为 `true`，则解除苏生限制。返回该添加的卡片。

### aux.AddCodeList
#### 声明语句(Lua)
```lua
function Auxiliary.AddCodeList(c,...)
```
#### 接受参数
一个 `Card`，数个 `number`。
#### 返回值
`nil`。
#### 用途
使c变成有传入所有参数卡号的记述的卡。
### AddContactFusionProcedure
#### 声明语句(Lua)
```lua
function Auxiliary.AddContactFusionProcedure(c,filter,self_location,opponent_location,mat_operation,...)
```
#### 接受参数
按照顺序：一个 `Card`，一个 `function`，两个表示位置的 `number`，一个 `function`，数个 `any`。  
参数 `self_location` 与 `opponent_location` 不传入时为 $0$。  
参数 `filter` 表示素材的过滤条件。  
参数 `self_location`, `opponent_location` 表示以 c:GetControler() 来看的自己，对方的区域。
参数 `mat_operation` 表示要对素材进行的操作。
#### 返回值
一个 `Effect`。该 `Effect` 可以让c从额外卡组特殊召唤。
#### 用途
为c添加接触融合手续。

### Card.AddCounter
#### 声明语句
```cpp
bool Card.AddCounter(Card c, int countertype, int count, bool singly)
```
#### 接受参数
按照顺序：一个 `Card`，一个表示指示物的 `number`，一个表示数量的 `number`，一个 `boolean`。
参数 `singly` 不传入时为 `false`。若参数 `singly` 为 `true`，则逐个添加。否则，一次性添加。
#### 返回值
返回是否成功。

### Duel.AddCustomActivityCounter
#### 声明语句(C++)
```cpp
void Duel.AddCustomActivityCounter(int counter_id, int activity_type, function f)
```
#### 接受参数
按照顺序：两个 `number`，一个 `function`。  
参数 `counter_id` 一般填写该卡的卡号。  
枚举 `activity_type`：
|值|意义|
|:--|---|
|常量 `ACTIVITY_SUMMON`、$1$|召唤时计数。不包括盖放。|
|常量 `ACTIVITY_NORMALSUMMON`、$2$|通常召唤时计数。包括盖放。|
|常量 `ACTIVITY_SPSUMMON`、$3$|特殊召唤时计数。|
|常量 `ACTIVITY_FLIPSUMMON`、$4$|反转召唤时计数。|
|常量 `ACTIVITY_ATTACK`、$5$|攻击宣言时计数。|
|常量 `ACTIVITY_CHAIN`、$7$|作效果的发动时计数。|
#### 返回值
`nil`。
#### 用途
设置操作类型为 `activity_type`、代号为 `counter_id` 的计数器。  
参数 `f` 为过滤函数，以一个 `Card` 为参数。返回值为 `false` 的卡片计数，计数器增加1（目前最多为1）。

### aux.AddDrytronSpSummonEffect
#### 声明语句
```lua
function Auxiliary.AddDrytronSpSummonEffect(c,func)
```
#### 接受参数
一个 `Card`，一个 `function`。
#### 用途
实现以下效果并返回：  
从自己的手卡·场上把1只这张卡以外的「龙辉巧」怪兽或者仪式怪兽解放才能发动。这张卡从手卡·墓地守备表示特殊召唤。那之后，可以 `<function>` 。这个效果发动的回合，自己若非不能通常召唤的怪兽则不能特殊召唤。  
其中 `<function>` 为参数 `func`。

### aux.AddFusionProcCodeFun
#### 声明语句
```lua
function Auxiliary.AddFusionProcCodeFun(c,code1,f,cc,sub,insf)
```
#### 接受参数
按照顺序：一个 `Card`，一个表示卡号的 `number`，一个 `function`，一个 `number`，两个 `boolean`。  
参数 `sub` 表示能否使用替代的融合素材。  
参数 `insf` 为 `false` 时，不能使用接触融合。
#### 返回值
`nil`。
#### 用途
为c添加融合召唤手续：  
用卡号为 `code` 的1只怪兽，和 `cc` 个满足条件 `f` 的怪兽为融合素材的融合召唤。

### aux.AddFusionProcCodeFunRep
#### 声明语句(Lua)
```lua
function Auxiliary.AddFusionProcCodeFunRep(c,code1,f,minc,maxc,sub,insf)
```
#### 接受参数
按照顺序：一个 `Card`，一个表示卡号的 `number`，一个 `function`，两个 `number`，两个 `boolean`。  
若 `minc > maxc`，不保证该函数有意义。  
参数 `sub` 表示能否使用替代的融合素材。  
参数 `insf` 为 `false` 时，不能使用接触融合。
#### 返回值
`nil`。
#### 用途
为c添加融合召唤手续：  
用卡号为 `code` 的1只怪兽，和 `minn` 到 `maxn` 个满足条件 `f` 的怪兽为融合素材的融合召唤。

### aux.AddFusionProcCodeRep
#### 声明语句(Lua)
```lua
function Auxiliary.AddFusionProcCodeRep(c,code1,cc,sub,insf)
```
#### 接受参数
按照顺序：一个 `Card`，一个表示卡号的 `number`，一个 `number`，两个 `boolean`。  
参数 `sub` 表示能否使用替代的融合素材。  
参数 `insf` 为 `false` 时，不能使用接触融合。
#### 返回值
`nil`。
#### 用途
为c添加融合召唤手续：  
用卡号为 `code` 的 `cc` 只怪兽为融合素材的融合召唤。

### aux.AddFusionProcFunFun
#### 声明语句(Lua)
```lua
function Auxiliary.AddFusionProcFunFun(c,f1,f2,cc,insf)
```
#### 接受参数
按照顺序：一个 `Card`，两个 `function`，一个 `number`，一个 `boolean`。  
参数 `insf` 为 `false` 时，不能使用接触融合。
#### 返回值
`nil`。
#### 用途
为c添加融合召唤手续：  
用满足 `f1` 的 $1$ 只怪兽，和满足 `f2` 的 `cc` 只怪兽为融合素材的融合召唤。

### aux.AddFusionProcFunFunRep
#### 声明语句(Lua)
```lua
function Auxiliary.AddFusionProcFunFunRep(c,f1,f2,minc,maxc,insf)
```
#### 接受参数
按照顺序：一个 `Card`，两个 `function`，两个 `number`，一个 `boolean`。  
若 `minc > maxc`，不保证该函数有意义。  
参数 `insf` 为 `false` 时，不能使用接触融合。
#### 返回值
`nil`。
#### 用途
为c添加融合召唤手续：  
用满足 `f1` 的 $1$ 只怪兽，和满足 `f2` 的 `minn` 到 `maxn` 只怪兽为融合素材的融合召唤。

### aux.AddFusionProcFunRep
#### 声明语句(Lua)
```lua
function Auxiliary.AddFusionProcFunRep(c,f,cc,insf)
```
#### 接受参数
按照顺序：一个 `Card`，一个 `function`，一个 `number`，一个 `boolean`。  
参数 `insf` 为 `false` 时，不能使用接触融合。
#### 返回值
`nil`。
#### 用途
为c添加融合召唤手续：  
用满足 `f` 的 `cc` 只怪兽为融合素材的融合召唤。

### aux.AddFusionProcMix
#### 声明语句(Lua)
```lua
function Auxiliary.AddFusionProcMix(c,sub,insf,...)
```
#### 接受参数
按照顺序：一个 `Card`，两个 `boolean`，数个 `function` 或 `number`。  
参数 `sub` 表示能否使用替代的融合素材。  
参数 `insf` 为 `false` 时，不能使用接触融合。
#### 返回值
`nil`。
#### 用途
记第4个参数及以后的参数为额外参数。  
为c添加融合召唤手续：  
用满足所有额外参数各 $1$ 只怪兽为融合素材的融合召唤。  
对于每个额外参数：  
若该参数为 `function`，则当该 `function` 返回非 `false` 或非 `nil` 时视为满足条件。  
若该参数为 `number`，则当卡号与该 `number` 相同时视为满足条件。  
若其他情况，不保证该函数有意义。

### aux.AddFusionProcMixRep
#### 声明语句(Lua)
```lua
function Auxiliary.AddFusionProcMixRep(c,sub,insf,fun1,minc,maxc,...)
```
#### 接受参数
按照顺序：一个 `Card`，两个 `boolean`，一个 `function`，两个 `number`，数个 `function` 或 `number`。  
若 `minc > maxc`，不保证该函数有意义。  
参数 `sub` 表示能否使用替代的融合素材。  
参数 `insf` 为 `false` 时，不能使用接触融合。
#### 返回值
`nil`。
#### 用途
记第4个参数及以后的参数为额外参数。  
为c添加融合召唤手续：  
用满足 `fun1` 的 `minc` 到 `maxc` 只怪兽，和满足所有额外参数各 $1$ 只怪兽为融合素材的融合召唤。  
对于每个额外参数：  
若该参数为 `function`，则当该 `function` 返回非 `false` 或非 `nil` 时视为满足条件。  
若该参数为 `number`，则当卡号与该 `number` 相同时视为满足条件。  
若其他情况，不保证该函数有意义。

### aux.AddFusionProcShaddoll
#### 声明语句(Lua)
```lua
function Auxiliary.AddFusionProcShaddoll(c,attr)
```
#### 接受参数
一个 `Card`，一个表示属性的 `number`。  
若 `attr` 不表示任何属性，不保证该函数有意义。
#### 返回值
`nil`。
#### 用途
为c添加融合召唤手续：  
「影依」怪兽＋属性为 `attr` 的怪兽各1只为融合素材的融合召唤。

### aux.AddLinkProcedure
#### 声明语句(Lua)
```lua
function Auxiliary.AddLinkProcedure(c,f,min,max,gf)
```
#### 接受参数
按照顺序：一个 `Card`，一个 `function`，两个 `number`，一个 `function`。
参数 `gf` 可不填写。
#### 返回值
一个 `Effect`。该 `Effect`可以让c从额外卡组连接召唤。
#### 用途
为c添加连接召唤手续：  
用 `min` 到 `max` 只满足 `f` 的怪兽为连接素材的连接召唤。  
若 `not gf` 为 `false`，则还应满足 `gf`。

### aux.AddMaterialCodeList
#### 声明语句(Lua)
```lua
function Auxiliary.AddMaterialCodeList(c,...)
```
#### 接受参数
一个 `Card`，数个 `number`。  
若参数 `c` 不为融合怪兽，不保证该函数有意义。
#### 返回值
`nil`。
#### 用途
使c变成素材有传入所有参数卡号的记述的卡，并使c变成有传入所有参数卡号的记述的卡。

### Card.AddMonsterAttribute
#### 声明语句(C++)
```cpp
void Card.AddMonsterAttribute(Card c, int type, int attribute, int race, int level, int atk, int def)
```
#### 接受参数
一个 `Card`，一个表示卡片类型的 `number`，一个表示属性的 `number`，一个表示种族的 `number`，一个表示攻击力的 `number`，一个表示守备力的 `number`。  
参数 `c` 不为魔法·陷阱卡时，不保证该函数有意义。
#### 返回值
`nil`。
#### 用途
为魔陷卡c添加怪兽数值,参数 `type` 为怪兽类型。  
参数 `level` $\neq 0$。  
若在数据库中有记录的数值，那些视为原本数值

AddRitualProcEqual
AddRitualProcEqualCode
AddRitualProcGreater
AddRitualProcGreaterCode
AddRitualProcUltimate
AddSetNameMonsterList
AddSynchroMixProcedure
AddSynchroProcedure
AddThisCardInGraveAlreadyCheck
AddUrsarcticSpSummonEffect
AddXyzProcedure
AddXyzProcedureLevelFree
AdjustAll
AdjustInstantly
AnnounceAttribute
AnnounceCard
AnnounceCoin
AnnounceLevel
AnnounceNumber
AnnounceRace
AnnounceType
AssumeProperty
AtkEqualsDef
## B
BeginPuzzle
BreakEffect
## C
CalculateDamage
CanEquipFilter
CancelCardTarget
CancelToGrave
ChainAttack
ChainUniqueCost
ChangeAttackTarget
ChangeAttacker
ChangeBattleDamage
ChangeChainOperation
ChangePosition
ChangeTargetCard
ChangeTargetParam
ChangeTargetPlayer
CheckActivateEffect
CheckChainTarget
CheckChainUniqueness
CheckEquipTarget
CheckEvent
CheckFusionMaterial
CheckFusionSubstitute
CheckGroupRecursive
CheckGroupRecursiveCapture
CheckGroupRecursiveEach
CheckLPCost
CheckLocation
CheckMustMaterial
CheckPhaseActivity
CheckReleaseGroup
CheckReleaseGroupEx
CheckRemoveOverlayCard
CheckSubGroup
CheckSubGroupEach
CheckSynchroMaterial
CheckTribute
CheckTunerMaterial
CheckUnionEquip
CheckUnionTarget
CheckUniqueOnField
CheckWithSumEqual
CheckWithSumGreater
CheckXyzMaterial
Clear
ClearEffectRelation
ClearOperationInfo
ClearTargetCard
Clone
CompleteProcedure
ConfirmCards
ConfirmDecktop
ConfirmExtratop
ContactFusionCondition
ContactFusionMaterialFilter
ContactFusionOperation
CopyEffect
CreateChecks
CreateEffect
CreateEffectRelation
CreateGroup
CreateRelation
CreateToken
## D
Damage
DeleteGroup
Destroy
DisableSelfDestroyCheck
DisableShuffleCheck
DiscardDeck
DiscardHand
Draw
DrytronCostFilter
DrytronCounterFilter
DrytronExtraCostFilter
DrytronSpSummonCost
DrytronSpSummonLimit
DrytronSpSummonOperation
DrytronSpSummonTarget
DualNormalCondition
## E
EnableChangeCode
EnableCounterPermit
EnableDualAttribute
EnableDualState
EnableExtraDeckSummonCountLimit
EnableGlobalFlag
EnableNeosReturn
EnablePendulumAttribute
EnableReviveLimit
EnableReviveLimitPendulumSummonable
EnableSpiritReturn
EnableUnionAttribute
Equal
Equip
EquipComplete
ExceptThisCard
ExtraDeckSummonCountLimitReset
ExtraReleaseFilter
## F
FALSE
FCheckAdditional
FCheckMix
FCheckMixGoal
FCheckMixRep
FCheckMixRepFilter
FCheckMixRepGoal
FCheckMixRepGoalCheck
FCheckMixRepSelected
FCheckMixRepSelectedCond
FCheckMixRepTemplate
FCheckSelectMixRep
FCheckSelectMixRepAll
FCheckSelectMixRepM
FConditionFilterMix
FConditionMix
FConditionMixRep
FOperationMix
FOperationMixRep
FSelectMixRep
FShaddollCondition
FShaddollExFilter
FShaddollFilter
FShaddollOperation
Filter
FilterBoolFunction
FilterCount
FilterEqualFunction
FilterSelect
ForEach
FromCards
## G
GetActivateEffect
GetActivateLocation
GetActivateSequence
GetActiveType
GetActivityCount
GetAttack
GetAttackAnnouncedCount
GetAttackTarget
GetAttackableTarget
GetAttackedCount
GetAttacker
GetAttribute
GetAttributeCount
GetAttributeInGrave
GetBaseAttack
GetBaseDefense
GetBattleDamage
GetBattleMonster
GetBattlePosition
GetBattleTarget
GetBattledCount
GetBattledGroup
GetBattledGroupCount
GetCappedAttack
GetCappedLevel
GetCardTarget
GetCardTargetCount
GetCategory
GetChainInfo
GetChainMaterial
GetClassCount
GetCode
GetCoinResult
GetColumn
GetColumnGroup
GetColumnGroupCount
GetColumnZone
GetCondition
GetControl
GetControler
GetCost
GetCount
GetCounter
GetCurrentChain
GetCurrentPhase
GetCurrentScale
GetCustomActivityCount
GetDecktopGroup
GetDefense
GetDescription
GetDestination
GetDiceResult
GetDrawCount
GetEffectCount
GetEquipCount
GetEquipGroup
GetEquipTarget
GetExtraTopGroup
GetFieldCard
GetFieldGroup
GetFieldGroupCount
GetFieldID
GetFirst
GetFirstCardTarget
GetFirstMatchingCard
GetFirstTarget
GetFlagEffect
GetFlagEffectLabel
GetFusionCode
GetFusionMaterial
GetHandSynchro
GetHandler
GetHandlerPlayer
GetLP
GetLabel
GetLabelObject
GetLeaveFieldDest
GetLeftScale
GetLegalAttributesOnly
GetLevel
GetLink
GetLinkAttribute
GetLinkCode
GetLinkCount
GetLinkMaterials
GetLinkRace
GetLinkedGroup
GetLinkedGroupCount
GetLinkedZone
GetLocation
GetLocationCount
GetLocationCountFromEx
GetMZoneCount
GetMatchingGroup
GetMatchingGroupCount
GetMaterial
GetMaterialCount
GetMaterialListCount
GetMaxGroup
GetMinGroup
GetMultiLinkedZone
GetMustMaterial
GetMutualLinkedGroup
GetMutualLinkedGroupCount
GetNext
GetOperatedGroup
GetOperation
GetOperationCount
GetOperationInfo
GetOriginalAttribute
GetOriginalCode
GetOriginalCodeRule
GetOriginalLeftScale
GetOriginalLevel
GetOriginalRace
GetOriginalRank
GetOriginalRightScale
GetOriginalType
GetOverlayCount
GetOverlayGroup
GetOverlayTarget
GetOwner
GetOwnerPlayer
GetOwnerTargetCount
GetPosition
GetPreviousAttackOnField
GetPreviousAttributeOnField
GetPreviousCodeOnField
GetPreviousControler
GetPreviousDefenseOnField
GetPreviousEquipTarget
GetPreviousLevelOnField
GetPreviousLocation
GetPreviousPosition
GetPreviousRaceOnField
GetPreviousSequence
GetPreviousTypeOnField
GetProperty
GetRace
GetRaceInGrave
GetRank
GetRealFieldID
GetReason
GetReasonCard
GetReasonEffect
GetReasonPlayer
GetReleaseGroup
GetRightScale
GetRitualLevel
GetRitualMaterial
GetRitualMaterialEx
GetSequence
GetSum
GetSummonLocation
GetSummonPlayer
GetSummonType
GetSynMaterials
GetSynchroLevel
GetSynchroLevelFlowerCardian
GetSynchroType
GetTarget
GetTargetCount
GetTargetsRelateToChain
GetTextAttack
GetTextDefense
GetTributeRequirement
GetTunerLimit
GetTurnCount
GetTurnCounter
GetTurnID
GetTurnPlayer
GetType
GetUnionCount
GetUsableMZoneCount
GetValue
GetValueType
GetXyzNumber
GlobalEffect
GrabSelectedCard
getMonsters
getTypes
## H
Hint
HintSelection
## I
IsAbleToChangeControler
IsAbleToDeck
IsAbleToDeckAsCost
IsAbleToDeckOrExtraAsCost
IsAbleToEnterBP
IsAbleToExtra
IsAbleToExtraAsCost
IsAbleToGrave
IsAbleToGraveAsCost
IsAbleToHand
IsAbleToHandAsCost
IsAbleToRemove
IsAbleToRemoveAsCost
IsActivatable
IsActivated
IsActiveType
IsAllColumn
IsAttack
IsAttackAbove
IsAttackBelow
IsAttackPos
IsAttackable
IsAttribute
IsCanAddCounter
IsCanBeDisabledByEffect
IsCanBeEffectTarget
IsCanBeFusionMaterial
IsCanBeLinkMaterial
IsCanBeRitualMaterial
IsCanBeSpecialSummoned
IsCanBeSynchroMaterial
IsCanBeXyzMaterial
IsCanChangePosition
IsCanHaveCounter
IsCanOverlay
IsCanRemoveCounter
IsCanTurnSet
IsChainAttackable
IsChainDisablable
IsChainDisabled
IsChainNegatable
IsCode
IsCodeListed
IsContains
IsControler
IsControlerCanBeChanged
IsController
IsCostChecked
IsCounterAdded
IsDamageCalculated
IsDefense
IsDefenseAbove
IsDefenseBelow
IsDefensePos
IsDestructable
IsDirectAttacked
IsDisabled
IsDiscardable
IsDualState
IsEnvironment
IsExistingMatchingCard
IsExistingTarget
IsExists
IsExtraDeckMonster
IsExtraLinkState
IsFacedown
IsFaceup
IsFaceupEx
IsForbidden
IsFusionAttribute
IsFusionCode
IsFusionSetCard
IsFusionSummonableCard
IsFusionType
IsHasCardTarget
IsHasCategory
IsHasEffect
IsHasProperty
IsHasType
IsImmuneToEffect
IsInGroup
IsLevel
IsLevelAbove
IsLevelBelow
IsLink
IsLinkAbove
IsLinkAttribute
IsLinkBelow
IsLinkCode
IsLinkMarker
IsLinkRace
IsLinkSetCard
IsLinkState
IsLinkSummonable
IsLinkType
IsLocation
IsMSetable
IsMaterialListCode
IsMaterialListSetCard
IsMaterialListType
IsNonAttribute
IsNotDualState
IsNotTuner
IsOnField
IsOriginalCodeRule
IsOriginalSetCard
IsPlayerAffectedByEffect
IsPlayerCanAdditionalSummon
IsPlayerCanDiscardDeck
IsPlayerCanDiscardDeckAsCost
IsPlayerCanDraw
IsPlayerCanRelease
IsPlayerCanRemove
IsPlayerCanSSet
IsPlayerCanSendtoDeck
IsPlayerCanSendtoGrave
IsPlayerCanSpecialSummon
IsPlayerCanSpecialSummonCount
IsPlayerCanSpecialSummonMonster
IsPlayerCanSummon
IsPosition
IsPreviousControler
IsPreviousLocation
IsPreviousPosition
IsPreviousSetCard
IsPublic
IsRace
IsRank
IsRankAbove
IsRankBelow
IsReason
IsRelateToBattle
IsRelateToCard
IsRelateToChain
IsRelateToEffect
IsReleasable
IsReleasableByEffect
IsSSetable
IsSetCard
IsSetNameMonsterListed
IsSpecialSummonableCard
IsSpecialSummonedByEffect
IsStatus
IsSummonCancelable
IsSummonLocation
IsSummonPlayer
IsSummonType
IsSummonable
IsSummonableCard
IsSynchroSummonable
IsSynchroType
IsType
IsTypeInText
IsUnionState
IsXyzLevel
IsXyzSummonable
IsXyzType
## J
没有函数名首字母为 J 的函数。
## K
KeepAlive
## L
LCheckGoal
LCheckOtherMaterial
LConditionFilter
LExtraFilter
LExtraMaterialCount
LUncompatibilityFilter
LabrynthDestroyOp
LinkCondition
LinkOperation
LinkSummon
LinkTarget
## M
MSet
MZoneSequence
MajesticCopy
Merge
MoveSequence
MoveToField
MustMaterialCheck
MustMaterialCounterFilter
## N
NOT
NULL
NecroValleyFilter
NecroValleyNegateCheck
NegateActivation
NegateAnyFilter
NegateAttack
NegateEffect
NegateEffectMonsterFilter
NegateMonsterFilter
NegateRelatedChain
NegateSummon
NeosReturnConditionForced
NeosReturnConditionOptional
NeosReturnTargetForced
NeosReturnTargetOptional
Next
NonTuner
## O
OR
Overlay
## P
PConditionExtraFilter
PConditionExtraFilterSpecific
PConditionFilter
PSSCompleteProcedure
PayLPCost
PendCondition
PendOperation
PendOperationCheck
PendulumReset
PendulumSummonableBool
PlaceCardsOnDeckBottom
PlaceCardsOnDeckTop
PuzzleOp
## Q
没有函数名首字母为 Q 的函数。
## R
RDComplete
RaiseEvent
RaiseSingleEvent
RandomSelect
Readjust
Recover
RegisterEffect
RegisterFlagEffect
RegisterMergedDelayedEvent
Release
ReleaseEffectRelation
ReleaseRitualMaterial
Remove
RemoveCard
RemoveCounter
RemoveOverlayCard
ReplaceEffect
Reset
ResetEffect
ResetFlagEffect
ReturnToField
ReverseInDeck
RitualCheck
RitualCheckAdditional
RitualCheckAdditionalLevel
RitualCheckEqual
RitualCheckGreater
RitualExtraFilter
RitualUltimateFilter
RitualUltimateOperation
RitualUltimateTarget
RockPaperScissors
## S
SSet
SZoneSequence
Select
SelectDisableField
SelectEffectYesNo
SelectField
SelectFusionMaterial
SelectMatchingCard
SelectOption
SelectPosition
SelectReleaseGroup
SelectReleaseGroupEx
SelectSubGroup
SelectSubGroupEach
SelectSynchroMaterial
SelectTarget
SelectTribute
SelectTunerMaterial
SelectUnselect
SelectWithSumEqual
SelectWithSumGreater
SelectXyzMaterial
SelectYesNo
SendtoDeck
SendtoExtraP
SendtoGrave
SendtoHand
SequenceToGlobal
SetAbsoluteRange
SetCardTarget
SetCategory
SetChainLimit
SetChainLimitTillChainEnd
SetCode
SetCoinResult
SetCondition
SetCost
SetCostCheck
SetCountLimit
SetCounterLimit
SetDescription
SetDiceResult
SetFlagEffectLabel
SetFusionMaterial
SetHint
SetHintTiming
SetLP
SetLabel
SetLabelObject
SetMaterial
SetOperation
SetOperationInfo
SetOwnerPlayer
SetProperty
SetRange
SetReason
SetReset
SetSPSummonOnce
SetSelectedCard
SetStatus
SetSynchroMaterial
SetTarget
SetTargetCard
SetTargetParam
SetTargetPlayer
SetTargetRange
SetTurnCounter
SetType
SetUnionState
SetUniqueOnField
SetValue
ShuffleDeck
ShuffleExtra
ShuffleHand
ShuffleSetCard
SkipPhase
SortDecktop
SpecialSummon
SpecialSummonComplete
SpecialSummonStep
SpiritReturnConditionForced
SpiritReturnConditionOptional
SpiritReturnOperation
SpiritReturnReg
SpiritReturnTargetForced
SpiritReturnTargetOptional
Stringid
Sub
Summon
SwapControl
SwapDeckAndGrave
SwapSequence
SynCondition
SynLimitFilter
SynMaterialFilter
SynMixCheck
SynMixCheckGoal
SynMixCheckRecursive
SynMixCondition
SynMixOperation
SynMixTarget
SynOperation
SynTarget
SynchroSummon
## T
TRUE
TargetBoolFunction
TargetEqualFunction
ThisCardInGraveAlreadyCheckOperation
TossCoin
TossDice
TuneMagicianCheckAdditionalX
TuneMagicianCheckX
TuneMagicianFilter
Tuner
## U
UnionReplaceFilter
UrsarcticExCostFilter
UrsarcticReleaseFilter
UrsarcticSpSummonCondition
UrsarcticSpSummonCost
UrsarcticSpSummonLimit
UrsarcticSpSummonOperation
UrsarcticSpSummonTarget
UseCountLimit
UseExtraReleaseCount
## V
没有函数名首字母为 V 的函数。
## W
Win
## X
XyzAlterFilter
XyzCondition
XyzConditionAlter
XyzLevelFreeCondition
XyzLevelFreeConditionAlter
XyzLevelFreeFilter
XyzLevelFreeGoal
XyzLevelFreeOperation
XyzLevelFreeOperationAlter
XyzLevelFreeTarget
XyzLevelFreeTargetAlter
XyzOperation
XyzOperationAlter
XyzSummon
XyzTarget
XyzTargetAlter
## Y
没有函数名首字母为 Y 的函数。
## Z
没有函数名首字母为 Z 的函数。
