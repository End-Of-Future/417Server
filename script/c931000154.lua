--起义
function c931000154.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,931000154+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c931000154.con)
	e1:SetTarget(c931000154.tg)
	e1:SetOperation(c931000154.op)
	c:RegisterEffect(e1)
end
function c931000154.fi1(c)
	return c:IsType(TYPE_NORMAL) and c:IsFaceup()
end
function c931000154.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c931000154.fi1,tp,LOCATION_MZONE,0,5,nil)
end
function c931000154.tgfi(c)
	return c:IsAbleToGrave() and c:IsOnField()
end
function c931000154.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroupCount(c931000154.tgfi,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g*500)
end
function c931000154.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SendtoGrave(g,REASON_EFFECT)
	local tg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if tg:GetCount()>0 then
		Duel.BreakEffect()
		local dam=tg:GetCount()*500
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
