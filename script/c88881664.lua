--雾都纪实 星列入侵
function c88881664.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88881664+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c88881664.activate)
	c:RegisterEffect(e1)	
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c:IsSetCard(0x888) end)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2) 
	--to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_LEAVE_FIELD) 
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)  
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,18881664) 
	e3:SetTarget(c88881664.thtg) 
	e3:SetOperation(c88881664.thop) 
	c:RegisterEffect(e3) 
end
function c88881664.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x888) and c:IsAbleToHand()
end
function c88881664.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c88881664.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(88881664,0)) then
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
function c88881664.xthfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x888) and c:IsType(TYPE_MONSTER) 
end 
function c88881664.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c88881664.xthfil,1,nil) end 
	local g=eg:Filter(c88881664.xthfil,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0) 
end 
function c88881664.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=eg:Filter(c88881664.xthfil,nil) 
	if g:GetCount()>0 then 
		Duel.SendtoHand(g,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,g) 
	end 
end 










