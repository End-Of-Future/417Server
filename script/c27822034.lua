--激流之源石
function c27822034.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c27822034.mfilter,1,1)
	c:EnableReviveLimit()  
	--indes 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetRange(LOCATION_MZONE)   
	e1:SetCountLimit(1,27822034) 
	e1:SetTarget(c27822034.idtg) 
	e1:SetOperation(c27822034.idop) 
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,17822034) 
	e2:SetTarget(c27822034.sptg) 
	e2:SetOperation(c27822034.spop) 
	c:RegisterEffect(e2) 
end
c27822034.XXSplash=true  
function c27822034.mfilter(c)
	return c:IsLevelBelow(4) and c.XXSplash 
end 
function c27822034.idfil(c) 
	return c:IsFaceup() and c.XXSplash and c:IsType(TYPE_SPELL+TYPE_TRAP)
end 
function c27822034.idtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingTarget(c27822034.idfil,tp,LOCATION_ONFIELD,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c27822034.idfil,tp,LOCATION_ONFIELD,0,1,1,nil)
end  
function c27822034.idop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetValue(1) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_ONFIELD) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	end 
end 
function c27822034.sckfil(c,e,tp) 
	return c:IsLinkAbove(3) and c:IsType(TYPE_LINK) and c.XXSplash and c:IsSummonPlayer(tp)  
end 
function c27822034.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return eg:IsExists(c27822034.sckfil,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c27822034.spop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end  
end 















