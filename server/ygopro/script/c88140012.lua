--无言神殇
function c88140012.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c88140012.matfilter1,nil,nil,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_REMOVED)
	e1:SetTarget(c88140012.disable)
	e1:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88140012,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,88140012)
	e3:SetCondition(c88140012.remcon)
	e3:SetTarget(c88140012.remtg)
	e3:SetOperation(c88140012.remop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(88140012,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1,88141012)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCondition(c88140012.spcon)
	e4:SetCost(c88140012.spcost)
	e4:SetTarget(c88140012.sptg)
	e4:SetOperation(c88140012.spop)
	c:RegisterEffect(e4)
end
function c88140012.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsRace(RACE_WYRM)
end
function c88140012.disable(e,c)
	return not c:IsType(TYPE_NORMAL) or (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c88140012.remfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c88140012.remcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c88140012.remfilter,1,nil)
end
function c88140012.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c88140012.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c88140012.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetHandler():GetTurnID()+1
end
function c88140012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),tp,SEQ_DECKSHUFFLE,REASON_COST)
end
function c88140012.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88140012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c88140012.spfilter,tp,LOCATION_REMOVED,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_REMOVED)
end
function c88140012.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c88140012.spfilter,tp,LOCATION_REMOVED,0,2,2,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end