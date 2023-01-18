--废墟之兴起/
function c100666995.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100666995+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100666995.thcost)
	e1:SetTarget(c100666995.thtg)
	e1:SetOperation(c100666995.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100666995.sstg)
	e2:SetOperation(c100666995.ssop)
	c:RegisterEffect(e2)
end
function c100666995.costfi(c)
	return c:GetType()==TYPE_TRAP and c:IsAbleToRemoveAsCost()
end
function c100666995.thfi(c)
	return c:IsSetCard(0xaaa) and c:GetType()==TYPE_TRAP and c:IsAbleToHand() and not c:IsCode(100666995)
end
function c100666995.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c100666995.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c100666995.costfi,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(c100666995.thfi,tp,LOCATION_HAND,0,1,nil)
	end
	e:SetLabel(0)
	local gg=Duel.GetMatchingGroupCount(c100666995.costfi,tp,LOCATION_GRAVE,0,nil)
	local tg=Duel.GetMatchingGroupCount(c100666995.thfi,tp,LOCATION_DECK,0,nil)
	if gg>=tg then
		if tg>=2 then gg=2 end
		if tg<2 then gg=1 end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c100666995.costfi,tp,LOCATION_GRAVE,0,1,gg,nil)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,gg,tp,LOCATION_DECK)
	e:SetLabel(gg)
end
function c100666995.thop(e,tp,eg,ep,ev,re,r,rp)
	local max=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100666995.thfi,tp,LOCATION_DECK,0,1,max,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100666995.ssfi(c)
	return c:IsSetCard(0xaaa) and c:GetType()==TYPE_TRAP and c:IsSSetable() and not c:IsCode(100666995)
end
function c100666995.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c100666995.ssfi,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
end
function c100666995.ssop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local sc=Duel.SelectMatchingCard(tp,c100666995.ssfi,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if sc and Duel.SSet(tp,sc)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e2:SetValue(LOCATION_REMOVED)
			sc:RegisterEffect(e2,true)
		end
	end
end
