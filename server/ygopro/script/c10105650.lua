function c10105650.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xc008),aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),true)
--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10105650,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,10105650)
	e2:SetTarget(c10105650.thtg)
	e2:SetOperation(c10105650.thop)
	c:RegisterEffect(e2)
    --negate attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCountLimit(1)
	e4:SetCondition(c10105650.condition)
	e4:SetCost(c10105650.cost)
	e4:SetOperation(c10105650.operation)
	c:RegisterEffect(e4)
    	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10105650,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
   	e5:SetCountLimit(1,101056500)
	e5:SetCondition(c10105650.spcon)
	e5:SetCost(c10105650.spcost)
	e5:SetTarget(c10105650.sptg)
	e5:SetOperation(c10105650.spop)
	e5:SetValue(c10105650.valcheck)
	c:RegisterEffect(e5)
    end
c10105650.material_setcode=0xc008
function c10105650.thfilter(c)
	return c:IsSetCard(0x46) and c:GetType()==TYPE_SPELL and c:IsAbleToHand()
end
function c10105650.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105650.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10105650.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10105650.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10105650.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c10105650.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x8) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x8)
	Duel.Release(g,REASON_COST)
end
function c10105650.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	end
end
function c10105650.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c10105650.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c10105650.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10105650.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end