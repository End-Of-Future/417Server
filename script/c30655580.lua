--究极魔导之页
local m=30655580
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	return not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(m,1-tp,ACTIVITY_CHAIN)>=6 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.relfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_SPELL)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.relfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 and Duel.GetMZoneCount(tp,g)>0 and Duel.GetMZoneCount(1-tp,g,tp)>0
		and Duel.IsPlayerCanRelease(tp)
		and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,30655581,0,TYPES_TOKEN_MONSTER,5000,5000,13,RACE_ROCK,ATTRIBUTE_WIND,POS_FACEUP_ATTACK,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),2,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.relfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	local c=e:GetHandler()
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
	local rg=Duel.GetOperatedGroup()
	if #rg>0 then
		local c=e:GetHandler()
		local rc=rg:GetFirst()
		while rc do 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
			e1:SetTarget(cm.distg)
			e1:SetLabelObject(rc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(cm.discon)
			e2:SetOperation(cm.disop)
			e2:SetLabelObject(rc)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			rc=rg:GetNext()
		end
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_SET_ATTACK)
		e4:SetReset(RESET_EVENT+0xff0000)
		e4:SetValue(g:GetCount()*800)
		c:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_SET_DEFENSE)
		c:RegisterEffect(e5)
		local og=Duel.GetOperatedGroup()
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
			if og:GetCount()==0 then return end
			if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
				and Duel.IsPlayerCanSpecialSummonMonster(tp,30655581,0,TYPES_TOKEN_MONSTER,5000,5000,13,RACE_ROCK,ATTRIBUTE_WIND,POS_FACEUP_ATTACK,1-tp) then
				local token=Duel.CreateToken(tp,30655581)
				Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
				local e11=Effect.CreateEffect(c)
				e11:SetType(EFFECT_TYPE_SINGLE)
				e11:SetCode(EFFECT_CHANGE_TYPE)
				e11:SetValue(TYPE_EFFECT+TYPE_MONSTER+TYPE_TOKEN)
				e11:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e11,true)
				--cannot be target
				local e6=Effect.CreateEffect(c)
				e6:SetType(EFFECT_TYPE_SINGLE)
				e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e6:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
				e6:SetRange(LOCATION_MZONE)
				e6:SetValue(aux.imval1)
				token:RegisterEffect(e6)
				local e7=e6:Clone()
				e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
				e7:SetValue(aux.tgoval)
				token:RegisterEffect(e7)
				local e8=Effect.CreateEffect(c)
				e8:SetType(EFFECT_TYPE_SINGLE)
				e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e8:SetRange(LOCATION_MZONE)
				e8:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
				e8:SetValue(1)
				token:RegisterEffect(e8)
				Duel.SpecialSummonComplete()
				end
			end
		end
	end
end
function cm.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
