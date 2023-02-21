--迷夜璃幻蛛
function c64000003.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,64000003+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c64000003.hspcon)
	e1:SetOperation(c64000003.hspop)
	c:RegisterEffect(e1)
--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c64000003.efilter)
	c:RegisterEffect(e2)
--negative
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c64000003.cost)
	e3:SetCountLimit(1,64000010)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetOperation(c64000003.ngop)
	c:RegisterEffect(e3)
end
function c64000003.hspfilter(c,tp,sc)
	return c:IsLevelAbove(5) and c:GetOriginalRace()==RACE_INSECT and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and not c:IsCode(64000003)
end
function c64000003.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c64000003.hspfilter,1,nil,c:GetControler(),c)
end
function c64000003.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local sug=Duel.SelectReleaseGroup(tp,c64000003.hspfilter,1,1,nil,tp,c)
	c:SetMaterial(sug)
	Duel.Release(sug,REASON_COST)
end
function c64000003.efilter(e,te)
	if te:GetOwner()==e:GetOwner() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local mc=tg:GetCount()
	if mc~=1 then return true end
	return not tg or not tg:IsContains(e:GetHandler())
end
function c64000003.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) or (c:IsType(TYPE_MONSTER) and c:IsReleasable())
end
function c64000003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64000003.filter1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) end
	local fg=Duel.GetMatchingGroup(c64000003.filter1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,e:GetHandler())
	if fg:GetCount()==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local og=fg:Select(tp,1,1,nil)
	Duel.HintSelection(og)
	local nc=og:GetFirst()
	Duel.Release(nc,REASON_COST)
end
function c64000003.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if g:GetCount()==0 then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
end