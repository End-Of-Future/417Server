--死灵的诱骗
function c4815467.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c4815467.con)
	e2:SetOperation(c4815467.act)
	c:RegisterEffect(e2)
end
function c4815467.con(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_GRAVE
end
function c4815467.act(e,tp,eg,ep,ev,re,r,rp)
	local ap=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER)
	Duel.Damage(ap,300,REASON_EFFECT)
end