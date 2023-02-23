--王牌竞赛 武内
function c88880526.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd88),4,2)
	c:EnableReviveLimit() 
	--to hand 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,88880526)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end) 
	e1:SetTarget(c88880526.thtg) 
	e1:SetOperation(c88880526.thop) 
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,18880526) 
	e2:SetCost(c88880526.xthcost) 
	e2:SetTarget(c88880526.xthtg) 
	e2:SetOperation(c88880526.xthop) 
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(function(e,te)
	return te:GetOwner()~=e:GetOwner() end) 
	e3:SetCondition(function(e) 
	return e:GetHandler():GetOverlayGroup():IsExists(function(c) return c:IsSetCard(0xd88) and c:IsType(TYPE_XYZ) end,1,nil) end)
	c:RegisterEffect(e3)
end
function c88880526.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD)
end 
function c88880526.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,2,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
	end 
end 
function c88880526.xthcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	local x=e:GetHandler():RemoveOverlayCard(tp,1,2,REASON_COST) 
	e:SetLabel(x)  
end 
function c88880526.xthfil(c) 
	return c:IsSetCard(0xd88) and c:IsAbleToHand()   
end 
function c88880526.xthtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c88880526.xthfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end 
function c88880526.xthop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88880526.xthfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil) 
	local x=e:GetLabel()
	if g:GetCount()>0 and x>0 then 
		local sg=g:Select(tp,1,x,nil) 
		Duel.SendtoHand(sg,nil,REASON_COST) 
	end 
end 







