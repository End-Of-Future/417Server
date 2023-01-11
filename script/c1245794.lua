--原子核龙
function c1245794.initial_effect(c)
	aux.EnableChangeCode(c,1543673,LOCATION_MZONE+LOCATION_GRAVE)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,1245794)
	e1:SetTarget(c1245794.thtg)
	e1:SetOperation(c1245794.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1245794)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c1245794.sptg)
	e2:SetOperation(c1245794.spop)
	c:RegisterEffect(e2)
end
function c1245794.spfi(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaa9) and c:IsCanBeSpecialSummoned(e,0,tp,0,0)
end
function c1245794.thfi(c)
	return c:IsSetCard(0xa99) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c1245794.thtg(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1245794.thfi,tp,LOCATION_DECK,0,1,nil)
end
function c1245794.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1245794.thfi,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1245794.sptg(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1245794.spfi,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp)
end
function c1245794.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1245794.spfi,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end