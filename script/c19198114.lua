--只因之Jo 究鸡生物坤
local m = 19198114
local cm = _G["c"..m]
function cm.initial_effect(c)
    --普通连接召唤
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,2)
    --不能特殊召换
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(cm.linksynchrolimit)
	c:RegisterEffect(e0)
    --特殊同调召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.synchrocon)
	e1:SetOperation(cm.synchroop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--改变类型
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--发动无效并破坏
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1,m)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.negcon)
	e3:SetTarget(cm.negtg)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
	--本家通天塔
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetCountLimit(2,m)
	e4:SetCondition(cm.con)
	e4:SetTarget(cm.negtg1)
	e4:SetOperation(cm.negop1)
	c:RegisterEffect(e4)
	--战破和ntr抗性
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	e5:SetCondition(cm.spcon)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e6)
	--效破和取对象抗性
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(cm.spcon2)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(cm.spcon2)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--超级打架王
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(m,4))
	e9:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e9:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e9:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e9:SetCondition(cm.atkcon)
	e9:SetCost(cm.atkcost)
	e9:SetOperation(cm.atkop)
	c:RegisterEffect(e9)
	--手卡除外
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(m,5))
	e10:SetCategory(CATEGORY_REMOVE)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e10:SetProperty(EFFECT_FLAG_DELAY)
	e10:SetCode(EVENT_BATTLE_DESTROYING)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1,m+100)
	e10:SetCondition(cm.hdcon)
	e10:SetTarget(cm.hdtg)
	e10:SetOperation(cm.hdop)
	c:RegisterEffect(e10)
	--本家通天塔2
	local e11=e10:Clone()
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetCondition(cm.con2)
	c:RegisterEffect(e11)
end
--不能特殊召唤
function cm.linksynchrolimit(e,se,sp,st)
	return st&SUMMON_TYPE_SYNCHRO==SUMMON_TYPE_SYNCHRO or st&SUMMON_TYPE_LINK==SUMMON_TYPE_LINK
end
--普通连接召唤
function cm.matfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSetCard(0x414)
end
--特殊同调召唤
function cm.synchrofilter(c)
	return c:IsFaceup() and c:IsLevel(8) and c:IsAbleToDeckOrExtraAsCost()
end
function cm.synchrofilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x414) and g:IsExists(cm.synchrofilter2,1,c,tp,c,sc,lv)
end
function cm.synchrofilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:IsLevel(lv) and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x414) and not c:IsType(TYPE_TUNER)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function cm.synchrocon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.synchrofilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(cm.synchrofilter1,1,nil,tp,g,c)
end
function cm.synchroop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.synchrofilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,cm.synchrofilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,cm.synchrofilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoDeck(g1,nil,2,REASON_COST+REASON_MATERIAL+REASON_SYNCHRO)
	Debug.Message("SYNCHRO SUMMON!")
	Debug.Message("超越了一切生物的坤坤")
	Debug.Message("沐浴在鸡鸣中")
end
--改变类型
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetValue(TYPE_TUNER+TYPE_MONSTER+TYPE_SYNCHRO)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
--发动无效并破坏
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev) and e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and not Duel.IsPlayerAffectedByEffect(tp,19198104)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
--本家通天塔
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_TEAP) or re:IsActiveType(TYPE_SPELL)) and Duel.IsChainNegatable(ev) and e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and Duel.IsPlayerAffectedByEffect(tp,19198104)
end
function cm.negtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.negop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
--效破和取对象抗性
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
--超级打架王
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:GetAttack()>0 and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(bc:GetAttack())
		c:RegisterEffect(e1)
	end
	Debug.Message("坤坤沐浴在小黑子树枝之下")
	Debug.Message("这就是究鸡生物坤坤吗，你食不食香精煎鱼")
end
--手卡除外
function cm.hdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and not Duel.IsPlayerAffectedByEffect(tp,19198104)
end
function cm.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function cm.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
--本家通天塔2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.IsPlayerAffectedByEffect(tp,19198104)
end