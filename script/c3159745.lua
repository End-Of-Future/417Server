--死灵的争夺
function c3159745.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,3159745+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c3159745.con)
	e1:SetTarget(c3159745.tg)
	e1:SetOperation(c3159745.act)
	c:RegisterEffect(e1)
end
function c3159745.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=4
end
function c3159745.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if e:GetHandler():IsLocation(LOCATION_HAND) then h1=h1-1 end
		local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		return (h1+h2>0) and Duel.IsPlayerCanDraw(tp,5) and Duel.IsPlayerCanDraw(1-tp,5)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,5,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,5,PLAYER_ALL,1)
end
function c3159745.act(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.Draw(tp,5,REASON_EFFECT)
	Duel.Draw(1-tp,5,REASON_EFFECT)
end