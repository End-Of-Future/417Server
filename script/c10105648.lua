function c10105648.initial_effect(c)
	c:SetSPSummonOnce(10105648)
	--link summon
	aux.AddLinkProcedure(c,c10105648.mfilter,1,1)
	c:EnableReviveLimit()
     	--code
	aux.EnableChangeCode(c,13171876,LOCATION_MZONE+LOCATION_GRAVE)
    	--Summon Launch Effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10105648,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,10105648)
	e3:SetCost(c10105648.cost)
	e3:SetTarget(c10105648.target)
	e3:SetOperation(c10105648.operation)
	c:RegisterEffect(e3)
    end
function c10105648.mfilter(c)
	return c:IsCode(13171876)
end
function c10105648.cfilter(c)
	return c:IsCode(14558127,23434538,10045474,24224830) and c:IsAbleToGraveAsCost()
end
function c10105648.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105648.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10105648.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10105648.thfilter(c)
	return c:IsSetCard(0x133) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c10105648.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105648.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10105648.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10105648.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end