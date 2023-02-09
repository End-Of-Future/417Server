--厄龙剑士 利托斯阿齐姆·灾祸
function c88881106.initial_effect(c)
	 --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xc7),2,99)
 --atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c88881106.atkcon)
	e3:SetTarget(c88881106.atktg)
	e3:SetValue(-1000)
	c:RegisterEffect(e3)
 --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88881106,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,88881106)
	e1:SetCondition(c88881106.thcon)
	e1:SetTarget(c88881106.thtg)
	e1:SetOperation(c88881106.thop)
	c:RegisterEffect(e1)
 --to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88881106,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,888811060)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c88881106.thcost)
	e1:SetTarget(c88881106.thtg2)
	e1:SetOperation(c88881106.thop2)
	c:RegisterEffect(e1)
end
function c88881106.atkcon(e)
	local tp=e:GetHandlerPlayer()
	local a,d=Duel.GetBattleMonster(tp)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and a and d and a:IsSetCard(0xc7)
end
function c88881106.atktg(e,c)
	local tp=e:GetHandlerPlayer()
	local a,d=Duel.GetBattleMonster(tp)
	return c==d
end
function c88881106.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c88881106.thfilter(c)
	return c:IsSetCard(0xc7) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c88881106.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88881106.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88881106.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88881106.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c88881106.thcfilter(c,tp)
	return c:IsSetCard(0xc7) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c88881106.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c88881106.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c88881106.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c88881106.thcfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c88881106.thcfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c88881106.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
end
function c88881106.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c88881106.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end