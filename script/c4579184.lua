--死灵的陷阱
function c4579184.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c4579184.op)
	c:RegisterEffect(e2)
end
function c4579184.op(e,tp,eg,ep,ev,re,r,rp)
	local ap=Duel.GetTurnPlayer()
	local ag=Duel.GetFieldGroupCount(ap,LOCATION_GRAVE,0)
	local dm=ag*100
	Duel.Damage(ap,dm,REASON_EFFECT)
end
