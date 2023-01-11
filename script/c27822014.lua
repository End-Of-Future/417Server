--激流之送葬士
function c27822014.initial_effect(c) 
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)   
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end) 
	c:RegisterEffect(e1) 
	--Destroy 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c27822014.descon) 
	e2:SetCost(c27822014.descost)
	e2:SetTarget(c27822014.destg) 
	e2:SetOperation(c27822014.desop) 
	c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
	local e4=e2:Clone() 
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS) 
	c:RegisterEffect(e4) 
end
c27822014.XXSplash=true 
function c27822014.descon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)  
end 
function c27822014.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c27822014.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) and e:GetHandler():GetFlagEffect(27822014) end 
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())	
	e:GetHandler():RegisterFlagEffect(27822014,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end 
function c27822014.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())  
	if g:GetCount()>0 then 
	   local x=Duel.Destroy(g,REASON_EFFECT) 
	   if x>0 and c:IsRelateToEffect(e) and c:IsFaceup() then 
	   local e1=Effect.CreateEffect(c) 
	   e1:SetType(EFFECT_TYPE_SINGLE) 
	   e1:SetCode(EFFECT_UPDATE_ATTACK) 
	   e1:SetRange(LOCATION_MZONE) 
	   e1:SetValue(x*200) 
	   e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	   c:RegisterEffect(e1) 
	   end 
	end	 
end 







 