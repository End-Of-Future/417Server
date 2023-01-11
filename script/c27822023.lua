--激流之少女-奥西恩
function c27822023.initial_effect(c) 
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_AQUA),1,1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27822023,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,27822023)
	e1:SetCondition(c27822023.thcon)
	e1:SetTarget(c27822023.thtg)
	e1:SetOperation(c27822023.thop)
	c:RegisterEffect(e1)
	--draw 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_REMOVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,17822023)
	e2:SetCondition(c27822023.drcon) 
	e2:SetTarget(c27822023.drtg) 
	e2:SetOperation(c27822023.drop) 
	c:RegisterEffect(e2) 
end 
c27822023.XXSplash=true 
function c27822023.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c27822023.thfilter(c)
	return c:IsCode(27822000,27822005) and c:IsAbleToHand()
end
function c27822023.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27822023.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27822023.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c27822023.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end 
function c27822023.drcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE) and re and re:GetHandler():IsControler(tp) and re:GetHandler().XXSplash and e:GetHandler():IsReason(REASON_EFFECT+REASON_REDIRECT+REASON_COST)	
end  
function c27822023.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end
function c27822023.drop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM) 
	Duel.Draw(p,d,REASON_EFFECT) 
end 














