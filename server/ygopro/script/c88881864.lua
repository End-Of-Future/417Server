--秘技 拔刀斩
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,88881844)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(aux.dscon)
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
function cm.tgf1(c,e)
	return c:IsFaceup() and c:IsCode(88881844) and not (e and c:IsImmuneToEffect(e))
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tgf1,tp,LOCATION_MZONE,0,nil,e)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetValue(aux.tgoval)
		tc:RegisterEffect(e3)
	end
	local chk=false
	local n=Duel.GetCurrentChain()
	for i=1,n do
		if i~=n then
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:GetHandler():IsCode(88881862) then
				chk=true	
			end
		end
	end
	if not (chk and e:IsHasType(EFFECT_TYPE_ACTIVATE)) then return end
	local te=Duel.IsPlayerAffectedByEffect(tp,88881870+100)
	if te and Duel.SelectYesNo(tp,aux.Stringid(88881870,1)) then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_INVOLVING_BATTLE_DAMAGE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
			tc:RegisterEffect(e1)
		end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,cm.opf1,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(g)
		g:GetFirst():AddCounter(0x18a0,1)
		te:UseCountLimit(tp)
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