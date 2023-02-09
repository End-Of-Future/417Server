--无尽激流深渊
function c27822020.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1) 
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0xfe,0xff)
	e2:SetValue(LOCATION_REMOVED)
	e2:SetTarget(c27822020.rmtg)
	c:RegisterEffect(e2) 
	--sb 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e3:SetRange(LOCATION_SZONE) 
	e3:SetCondition(c27822020.sbcon) 
	e3:SetOperation(c27822020.sbop)
	c:RegisterEffect(e3) 
end
c27822020.XXSplash=true 
function c27822020.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer() and c:IsReason(REASON_DESTROY) 
end 
function c27822020.sbckfil(c,tp) 
	return c:IsControler(tp) and c:IsType(TYPE_LINK) and c.XXSplash and c:IsSummonType(SUMMON_TYPE_LINK)  
end 
function c27822020.sbcon(e,tp,eg,ep,ev,re,r,rp) 
	local b1=Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=not Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil) 
	return (b1 or b2) and eg:IsExists(c27822020.sbckfil,1,nil,tp) 
end  
function c27822020.sbop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local b1=Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=not Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil) 
	if b1 or b2 then 
	   Duel.Hint(HINT_CARD,0,27822020) 
	   if b1 then 
	   local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil) 
	   Duel.Destroy(dg,REASON_EFFECT)
	   elseif b2 then 
	   local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil) 
	   local dg=g:RandomSelect(tp,1) 
	   Duel.SendtoDeck(dg,nil,2,REASON_EFFECT) 
	   end 
	end 
end  







