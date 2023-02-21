--墟梦塌落的轮舞
function c64000017.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE+TIMING_SSET)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCountLimit(1,64000017+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c64000017.cost)
	e1:SetTarget(c64000017.target)
	e1:SetOperation(c64000017.activate)
	c:RegisterEffect(e1)
end
function c64000017.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) or (c:IsType(TYPE_MONSTER) and c:IsReleasable())
end
function c64000017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,5)
	if chk==0 then return Duel.CheckLPCost(tp,2000) and Duel.IsExistingMatchingCard(c64000017.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,e:GetHandler()) and g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==5 end
	local fg=Duel.GetMatchingGroup(c64000017.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,e:GetHandler())
	if fg:GetCount()<2 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local og=fg:Select(tp,2,2,nil)
	Duel.HintSelection(og)
	Duel.Release(og,REASON_COST)
	Duel.PayLPCost(tp,2000)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c64000017.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c64000017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64000017.filter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE) end
end
function c64000017.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c64000017.filter1,tp,0,LOCATION_ONFIELD,1,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end