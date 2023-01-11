--死灵的跟踪
function c1546732.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c1546732.con)
	e1:SetOperation(c1546732.op)
	c:RegisterEffect(e1)
end
function c1546732.con(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5
		or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<5 then return end
	return rp==1-tp
end
function c1546732.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c1546732.cgop)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c1546732.cgop(e,tp,eg,ep,ev,re,r,rp)
	local ga=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local gb=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local ag=ga:RandomSelect(nil,5)
	local bg=gb:RandomSelect(nil,5)
	Duel.SendtoGrave(ag,REASON_EFFECT)
	Duel.SendtoGrave(bg,REASON_EFFECT)
end