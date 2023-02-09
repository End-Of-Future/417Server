--圣光战士
function c27819031.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit) 
	e1:SetCondition(c27819031.syncon)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetHintTiming(0,TIMING_STANDBY_PHASE)  
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)  
	e2:SetTarget(c27819031.atktg) 
	e2:SetOperation(c27819031.atkop) 
	c:RegisterEffect(e2) 
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27819031,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)   
	e2:SetCountLimit(1,27819031+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c27819031.sptg)
	e2:SetOperation(c27819031.spop)
	c:RegisterEffect(e2)
end
c27819031.SetCard_XXLight=true  
function c27819031.syncon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) 
end 
function c27819031.ctfil(c) 
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_SYNCHRO) 
end 
function c27819031.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27819031.ctfil,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end 
	local tc=Duel.SelectMatchingCard(tp,c27819031.ctfil,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil):GetFirst() 
	Duel.Remove(tc,POS_FACEUP,REASON_COST) 
	e:SetLabelObject(tc) 
end 
function c27819031.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=e:GetLabelObject() 
	local atk=tc:GetAttack()
	if c:IsRelateToEffect(e) then 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
	c:RegisterEffect(e1)
	end 
end 
function c27819031.filter(c,e,tp)
	return c.SetCard_XXLight and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c27819031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local g=Duel.SelectTarget(tp,c27819031.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c27819031.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if tc then 
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
end











