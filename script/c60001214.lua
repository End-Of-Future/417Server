--空绝的残光
local m=60001214
local cm=_G["c"..m]
cm.name="空绝的残光"
function cm.initial_effect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_HAND) 
	e4:SetCountLimit(1)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.damtg)
	e1:SetOperation(cm.damop)
	c:RegisterEffect(e1)
end
function cm.thfilter(c)
	return c.named_with_treasure and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND,0,1,0x6a6) end
	Duel.DiscardHand(tp,Card.IsSetCard,1,1,REASON_DISCARD,0x6a6)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECKLOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,nil)
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.RegisterFlagEffect(tp,60001211,RESET_PHASE+PHASE_END,0,1000)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1000)
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFlagEffect(tp,m)<=3 then  
		if chk==0 then return true end
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(1600)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1600)
	else
		if chk==0 then return true end
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(3200)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,3200)
	end
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(cm.filter2))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end