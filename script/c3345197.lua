--原子分离技术
function c3345197.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3345197,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,3345197+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c3345197.sptg)
	e1:SetOperation(c3345197.spact)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3345197,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,3345197+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c3345197.thtg)
	e2:SetOperation(c3345197.thact)
	c:RegisterEffect(e2)
end
function c3345197.spfi(c,e,tp)
	return c:IsSetCard(0x1093,0xaa9) and c:IsCanBeSpecialSummoned(e,0,tp,0,0)
end
function c3345197.sptg(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c3345197.spfi,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())
end
function c3345197.spact(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c3345197.spfi,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,0,0,POS_FACEUP)
	end
end
function c3345197.thfi(c)
	return c:IsCode(3659803) and c:IsAbleToHand()
end
function c3345197.thtg(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c3345197.thfi,tp,LOCATION_DECK,0,1,nil)
		and Duel.CheckLPCost(tp,1000)
end
function c3345197.thact(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)<1000 then return end
	Duel.PayLPCost(tp,1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c3345197.thfi,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end