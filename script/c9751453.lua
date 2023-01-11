--死灵世界
function c9751453.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9751453.mtcon)
	e2:SetOperation(c9751453.mtop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c9751453.damval)
	c:RegisterEffect(e3)
	local e4=e3:Clone(c)
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,9751453)
	e5:SetTarget(c9751453.tg)
	e5:SetOperation(c9751453.sset)
	c:RegisterEffect(e5)
end
function c9751453.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9751453.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,500) and Duel.SelectYesNo(tp,aux.Stringid(9751453,0)) then
		Duel.PayLPCost(tp,500)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function c9751453.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 and (re:GetHandler():IsSetCard(0xa9a) or re:GetHandler():IsCode(98139712)) then return 0 end
	return val
end
function c9751453.sfi(c)
	return (c:IsSetCard(0xa9a) or c:IsCode(98139712)) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c9751453.tg(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9751453.sfi,tp,LOCATION_DECK,0,1,nil)
end
function c9751453.sset(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9751453.sfi,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
		Duel.ShuffleDeck(tp)
	end
end