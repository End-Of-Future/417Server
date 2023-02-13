--雾都纪实 雾都旧址
function c88881666.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88881666+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c88881666.activate)
	c:RegisterEffect(e1) 
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(c88881666.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetValue(c88881666.efilter)
	c:RegisterEffect(e3)
	--neg 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING) 
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,18881666)
	e4:SetCondition(c88881666.negcon)
	e4:SetCost(c88881666.negcost)
	e4:SetTarget(c88881666.negtg)
	e4:SetOperation(c88881666.negop)
	c:RegisterEffect(e4)
end
function c88881666.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x888) and c:IsAbleToHand()
end
function c88881666.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c88881666.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(88881666,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg) 
		if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) then 
			Duel.BreakEffect() 
			local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil) 
			Duel.SendtoDeck(dg,nil,2,REASON_EFFECT) 
		end 
	end
end
function c88881666.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsSetCard(0x888) and bit.band(loc,LOCATION_ONFIELD)~=0 
end
function c88881666.nckfil(c) 
	return c:IsSetCard(0x888) and c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)   
end 
function c88881666.negcon(e,tp,eg,ep,ev,re,r,rp) 
	if not Duel.IsChainNegatable(ev) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return rp==1-tp and tg and tg:IsExists(c88881666.nckfil,1,nil) 
end
function c88881666.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end 
	Duel.SendtoGrave(e:GetHandler(),REASON_COST) 
end 
function c88881666.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c88881666.negop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end






