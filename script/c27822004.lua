--激流-呼召灵
function c27822004.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_WATER),2,2)	
	--search 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,27822004) 
	e1:SetCondition(c27822004.srcon)
	e1:SetTarget(c27822004.srtg) 
	e1:SetOperation(c27822004.srop) 
	c:RegisterEffect(e1) 
end
c27822004.XXSplash=true   
function c27822004.ckfil(c,e,tp) 
	local lg=e:GetHandler():GetLinkedGroup() 
	return lg:IsContains(c) and c:IsAttribute(ATTRIBUTE_WATER) 
end 
function c27822004.srcon(e,tp,eg,ep,ev,re,r,rp)   
	return eg:IsExists(c27822004.ckfil,1,nil,e,tp)
end 
function c27822004.thfil(c,e,tp,eg) 
	local cg=eg:Filter(c27822004.ckfil,nil,e,tp) 
	if cg:IsExists(Card.IsCode,1,nil,c:GetCode()) then return false end 
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER)
end 
function c27822004.srtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c27822004.thfil,tp,LOCATION_DECK,0,1,nil,e,tp,eg) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c27822004.xckfil(c) 
	return c.XXSplash  
end 
function c27822004.xthfil(c) 
	return c:IsAbleToHand() and c.XXSplash 
end 
function c27822004.srop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local cg=eg:Filter(c27822004.ckfil,nil,e,tp)  
	local g=Duel.GetMatchingGroup(c27822004.thfil,tp,LOCATION_DECK,0,nil,e,tp,eg) 
	if g:GetCount()>0 then 
	   local sg=g:Select(tp,1,1,nil) 
	   Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	   Duel.ConfirmCards(1-tp,sg) 
	   if cg:IsExists(c27822004.xckfil,1,nil) and Duel.IsExistingMatchingCard(c27822004.xthfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(27822004,1)) then 
	   local dg=Duel.SelectMatchingCard(tp,c27822004.xthfil,tp,LOCATION_GRAVE,0,1,1,nil)
	   Duel.SendtoHand(dg,nil,REASON_EFFECT)
	   end 
	end 
end 


















