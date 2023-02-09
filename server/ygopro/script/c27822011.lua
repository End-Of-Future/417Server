--激流飞龙之心
function c27822011.initial_effect(c)
	--search 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE) 
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,27822011)
	e1:SetTarget(c27822011.srtg)
	e1:SetOperation(c27822011.srop)
	c:RegisterEffect(e1)	 
	--To hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,17822011)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c27822011.thtg)
	e4:SetOperation(c27822011.thop)
	c:RegisterEffect(e4)
end
c27822011.XXSplash=true  
function c27822011.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27822011.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27822011.filter(c)
	return c.XXSplash and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c27822011.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c27822011.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c27822011.thfilter(c)
	return c.XXSplash and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c27822011.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c27822011.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27822011.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c27822011.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27822011.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end


