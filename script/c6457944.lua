--质子龙
function c6457944.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c6457944.splimit,1,1,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,6457944)
	e1:SetCondition(c6457944.tgcon)
	e1:SetTarget(c6457944.tgtg)
	e1:SetOperation(c6457944.tgop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,6457945)
	e2:SetCost(c6457944.spco)
	e2:SetTarget(c6457944.sptg)
	e2:SetOperation(c6457944.spop)
	c:RegisterEffect(e2)
end
function c6457944.splimit(c)
	return c:IsSetCard(0xaa9,0x1093) and c:IsCanBeLinkMaterial(nil) and not c:IsCode(6457944)
end
function c6457944.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c6457944.tgfi(c)
	return c:IsSetCard(0xaa9) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c6457944.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6457944.tgfi,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c6457944.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c6457944.tgfi,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c6457944.cofi(c)
	return c:IsSetCard(0xaa9) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c6457944.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6457944.cofi,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c6457944.cofi,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Release(g,REASON_COST)
	end
end
function c6457944.spfi(c,e,tp)
	return c:IsSetCard(0xaa9,0x1093) and c:IsCanBeSpecialSummoned(e,0,tp,0,0)
end
function c6457944.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6457944.spfi,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c6457944.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c6457944.spfi,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,0,0,POS_FACEUP)
	end
end
