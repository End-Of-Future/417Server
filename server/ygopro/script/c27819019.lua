--圣光飞龙-正义吟唱
function c27819019.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c27819019.mfilter),1)
	c:EnableReviveLimit()   
	-- 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetTarget(c27819019.indtg) 
	e1:SetOperation(c27819019.indop) 
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27819019,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetCountLimit(1,27819019)
	e2:SetCondition(c27819019.spcon)
	e2:SetCost(c27819019.spcost)
	e2:SetTarget(c27819019.sptg)
	e2:SetOperation(c27819019.spop)
	c:RegisterEffect(e2)
end
c27819019.SetCard_XXLight=true  
c27819019.SetCard_XXLightDragon=true 
function c27819019.mfilter(c) 
	return c.SetCard_XXLight 
end  
function c27819019.ckfil(c) 
	return c:IsFaceup() and c.SetCard_XXLight 
end 
function c27819019.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27819019.ckfil,tp,LOCATION_MZONE,0,1,nil) end 
end 
function c27819019.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c27819019.ckfil,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then 
	local tc=g:GetFirst() 
	while tc do 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	tc=g:GetNext() 
	end 
	end 
end 
function c27819019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) 
end
function c27819019.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c27819019.spfilter(c,e,tp,mc) 
	local race=mc:GetRace()
	local att=mc:GetAttribute()  
	local code=mc:GetCode()
	return not c:IsCode(code) and  c:IsRace(race) and c:IsAttribute(att) and c:IsType(TYPE_SYNCHRO)
		and c:IsLevelBelow(9) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false,POS_FACEUP_DEFENSE)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c27819019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27819019.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c27819019.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c27819019.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then  
		tc:CompleteProcedure()
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(27819019,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c27819019.descon)
		e1:SetOperation(c27819019.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c27819019.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(27819019)==e:GetLabel()
end
function c27819019.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end










