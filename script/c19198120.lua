--只因之指 无限鸡石坤哥
local m = 19198120
local cm = _G["c"..m]
local loc_mr=LOCATION_MZONE+LOCATION_REMOVED
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--不能特殊召换
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(cm.linklimit)
	c:RegisterEffect(e0)
	--特殊连接召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.linkcon)
	e1:SetOperation(cm.linkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--不受效果影响
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.econ)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--超级打架王
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(cm.atkcon)
	e3:SetCost(cm.atkcost)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
	--伤计送墓
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.tgcon)
	e4:SetTarget(cm.tgtg)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)
end
--不能特殊召唤
function cm.linklimit(e,se,sp,st)
	return st&SUMMON_TYPE_LINK==SUMMON_TYPE_LINK
end
--特殊连接召唤
function cm.linkfilter1(c)
	return c:IsSetCard(0x414) and c:IsType(TYPE_LINK) and c:IsLinkAbove(4)
end
function cm.linkfilter2(c,tp)
	return ((c:IsSetCard(0x414) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_LINK)) or (c:IsSummonLocation(LOCATION_EXTRA) and not c:IsSetCard(0x414))) and c:IsAbleToDeckOrExtraAsCost()
end
function cm.linkcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(cm.linkfilter1,tp,LOCATION_MZONE,0,1,1,nil,ft) and Duel.IsExistingMatchingCard(cm.linkfilter2,tp,loc_mr,LOCATION_MZONE,8,8,nil)
end
function cm.linkop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,cm.linkfilter1,tp,LOCATION_MZONE,0,1,1,nil,ft)
	local g2=Duel.SelectMatchingCard(tp,cm.linkfilter2,tp,loc_mr,LOCATION_MZONE,8,8,nil)
	Duel.SendtoGrave(g1,nil,REASON_COST+REASON_LINK+REASON_MATERIAL)
	Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_LINK+REASON_MATERIAL)
	Debug.Message("Link Summon!")
	Debug.Message("拥有六颗伟大的鸡石的坤坤")
	Debug.Message("一个响指即可抹杀50%黑子")
end
--不受效果影响
function cm.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x414)
end
--超级打架王
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:GetAttack()>0 and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and not Duel.IsPlayerAffectedByEffect(tp,19198104)
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
		e1:SetValue(bc:GetAttack()*2)
		c:RegisterEffect(e1)
	end
	Debug.Message("对拥有六颗无限鸡石的我")
	Debug.Message("你将毫无胜算")
end
--伤计炸卡
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if ph~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local ac=Duel.GetBattleMonster(tp)
	if not (ac and ac:IsFaceup() and ac:IsCode(m)) then return false end
	local tc=ac:GetBattleTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsControler(1-tp) and tc:IsRelateToBattle() and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.IsPlayerAffectedByEffect(tp,19198104)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1500)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsControler(1-tp) and tc:IsRelateToBattle() then
		if Duel.Damage(1-tp,1500,REASON_EFFECT)~=0 then
		Duel.SendtoGrave(tc,REASON_RULE)
	end
	Debug.Message("对拥有六颗无限鸡石的我")
	Debug.Message("你将毫无胜算")
	end
end