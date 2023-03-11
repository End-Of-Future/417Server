--写魂镜的半成品
function c85809913.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(85809913,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,85809913)
	e1:SetTarget(c85809913.target)
	e1:SetOperation(c85809913.activate)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(85809913,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,85809913)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c85809913.thtg)
	e3:SetOperation(c85809913.thop)
	c:RegisterEffect(e3)
	
end
function c85809913.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x3a) and c:IsReleasableByEffect()
		and Duel.IsExistingMatchingCard(c85809913.ffilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c:GetOriginalLevel(),e,tp,c)
end
function c85809913.ffilter(c,lv,e,tp,tc)
	return c:IsSetCard(0x3a) and c:IsType(TYPE_RITUAL) and (c:GetOriginalLevel()==lv+2 or c:GetOriginalLevel()==lv+4)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c85809913.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsReleasableByEffect()
		and chkc:IsFaceup() and chkc:IsSetCard(0x3a) end
	if chk==0 then return Duel.IsExistingTarget(c85809913.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c85809913.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c85809913.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetOriginalLevel()
	if Duel.Release(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c85809913.ffilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,lv,e,tp,nil)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		sg:GetFirst():SetMaterial(nil)
		Duel.SpecialSummon(sg,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
	end
end
function c85809913.thfilter(c)
	return c:IsCode(9236985) and c:IsAbleToHand()
end
function c85809913.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c85809913.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c85809913.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c85809913.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
