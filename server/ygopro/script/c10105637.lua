function c10105637.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10105637+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10105637.cost)
	e1:SetTarget(c10105637.target)
	e1:SetOperation(c10105637.activate)
	c:RegisterEffect(e1)
  --indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c10105637.indcon)
	e2:SetTarget(c10105637.settg)
	e2:SetOperation(c10105637.indop)
	c:RegisterEffect(e2)
end
function c10105637.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c10105637.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x38) and c:IsAbleToHand()
end
function c10105637.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105637.filter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c10105637.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10105637.filter,tp,LOCATION_DECK,0,2,2,nil)
   	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
       	Duel.Draw(p,d,REASON_EFFECT)
    	Duel.BreakEffect()
    	Duel.DiscardDeck(tp,2,REASON_EFFECT)
    end
end
function c10105637.indcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x38)
		and bit.band(r,REASON_EFFECT)~=0
end
function c10105637.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c10105637.indop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end