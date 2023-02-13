--雾都纪实 塔罗兰
function c88881662.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88881662+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c88881662.activate)
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_SZONE) 
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c:IsSetCard(0x888) end) 
	e2:SetValue(function(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsSetCard(0x888) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*200 end) 
	c:RegisterEffect(e2) 
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,18881662)
	e3:SetCondition(c88881662.atkcon) 
	e3:SetOperation(c88881662.atkop)
	c:RegisterEffect(e3)	
end
function c88881662.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x888) and c:IsAbleToHand()
end
function c88881662.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c88881662.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(88881662,0)) then
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
function c88881662.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a,b=Duel.GetBattleMonster(tp)
	return a and a:IsSetCard(0x888) and b and b:GetAttack()>0 
end 
function c88881662.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a,b=Duel.GetBattleMonster(tp)
	if a:IsRelateToBattle() and a:IsFaceup() and b:IsRelateToBattle() and b:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(b:GetAttack())
		c:RegisterEffect(e1)
	end
end








