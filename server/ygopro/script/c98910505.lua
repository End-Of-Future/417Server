--独步天下
function c98910505.initial_effect(c)
	c:SetUniqueOnField(1,0,98910505)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98910510)
	e2:SetCondition(c98910505.discon)
	e2:SetCost(c98910505.discost)
	e2:SetTarget(c98910505.distg)
	e2:SetOperation(c98910505.disop)
	c:RegisterEffect(e2)
--destory
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,98910505)
	e4:SetCost(c98910505.descost)
	e4:SetTarget(c98910505.destg)
	e4:SetOperation(c98910505.desop)
	c:RegisterEffect(e4)
end
function c98910505.desfilter(c)
	return c:IsSetCard(0x980) and c:IsFaceup()
end
function c98910505.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev) and Duel.GetMatchingGroupCount(c98910505.desfilter,tp,LOCATION_MZONE,0,nil)>0
end
function c98910505.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	Duel.Remove(e:GetHandler(),nil,REASON_COST)
end
function c98910505.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98910505.disop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			if Duel.Destroy(eg,REASON_EFFECT)~=0 then
	local tc=eg:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1) end end
end
function c98910505.desfilter(c)
	return c:IsCode(98910501) and c:IsFaceup()
end
function c98910505.desfilter1(c)
	return c:IsCode(98910507) and c:IsFaceup() and not c:IsDisabled()
end
function c98910505.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=0
	if Duel.IsExistingMatchingCard(c98910505.desfilter1,tp,LOCATION_ONFIELD,0,1,nil) then b=b+1 end
	local a=0
	local g=Duel.GetMatchingGroup(c98910505.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
	local tg=g:GetFirst()
	while tg do
	if tg:IsAbleToGraveAsCost() then a=a+1 end
	tg=g:GetNext()
	end
	if chk==0 then return (Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) or (a>0 and b>0) ) and e:GetHandler():IsAbleToGrave() end
	if a>0 and b>0 then
	if Duel.SelectYesNo(tp,aux.Stringid(98910505,0)) then
	   local sg=g:Select(tp,1,1,nil)
	   Duel.SendtoGrave(e:GetHandler()+sg,REASON_COST)
	else
	   Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	   Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	end
	else
	   Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	   Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	end
end
function c98910505.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function c98910505.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1) end
	end
end