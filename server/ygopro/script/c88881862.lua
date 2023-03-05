--秘技 燕返
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,88881844)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(cm.cos1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(cm.cos2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
--e1
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x18a0,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x18a0,1,REASON_COST)
end
function cm.tgf1(c,chk)
	if not c:IsCode(88881844) then return false end
	return ((chk==0 and c:IsFaceup()) or c:IsPosition(POS_FACEUP_ATTACK))
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b=Duel.GetMatchingGroupCount(cm.tgf1,tp,LOCATION_MZONE,0,nil,1)>0
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and (b or chkc:IsPosition(POS_FACEUP_ATTACK)) end
	if chk==0 then return Duel.IsExistingTarget(b and aux.TRUE or Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK) 
		and Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_MZONE,0,1,nil,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	Duel.SelectTarget(tp,b and aux.TRUE or Card.IsPosition,tp,0,LOCATION_MZONE,1,1,nil,POS_FACEUP_ATTACK)
end
function cm.opf1(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x18a0,1) and c:IsCode(88881844)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local g=Duel.GetMatchingGroup(cm.tgf1,tp,LOCATION_MZONE,0,nil,0):Filter(tc:IsPosition(POS_FACEUP_ATTACK) and aux.TRUE or Card.IsPosition,nil,POS_FACEUP_ATTACK)
		while #g>0 and tc:IsLocation(LOCATION_MZONE) do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local c
			if #g==1 then c=g:GetFirst() 
			else c=g:Select(tp,1,1,nil):GetFirst() end
			Duel.CalculateDamage(c,tc)
			g:RemoveCard(c)
		end
		local chk=false
		local n=Duel.GetCurrentChain()
		for i=1,n do
			if i~=n then
				local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
				if te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:GetHandler():IsCode(88881864) then
					chk=true	
				end
			end
		end
		if not (chk and e:IsHasType(EFFECT_TYPE_ACTIVATE)) then return end
		local te=Duel.IsPlayerAffectedByEffect(tp,88881870)
		if te and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup()
			and Duel.SelectYesNo(tp,aux.Stringid(88881870,0)) then
			Duel.Hint(HINT_CARD,0,88881870)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local g=Duel.SelectMatchingCard(tp,cm.opf1,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.HintSelection(g)
			g:GetFirst():AddCounter(0x18a0,1)
			te:UseCountLimit(tp)
		end
	end
end
--e2
function cm.cos2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.opf2(c)
	return c:IsCode(88881844) and c:IsAbleToHand()
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.opf2),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,1190) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			g=g:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end