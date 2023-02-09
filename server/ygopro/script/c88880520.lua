--我！看到你了！
function c88880520.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c88880520.activate)
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_REMOVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetTarget(c88880520.thrtg) 
	e2:SetOperation(c88880520.throp)  
	c:RegisterEffect(e2) 
	--atk 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD) 
	e3:SetCode(EFFECT_UPDATE_ATTACK) 
	e3:SetRange(LOCATION_SZONE) 
	e3:SetTargetRange(LOCATION_MZONE,0) 
	e3:SetTarget(function(e,c) 
	return c:IsSetCard(0xd88) end) 
	e3:SetValue(function(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetClassCount(Card.GetAttribute)*100 end) 
	c:RegisterEffect(e3)
end
function c88880520.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd88) and c:IsAbleToHand()
end
function c88880520.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c88880520.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(88880520,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end 
function c88880520.rmfil(c) 
	return c:IsSetCard(0xd88) and c:IsAbleToRemove()   
end 
function c88880520.thrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re and e:GetHandler():IsAbleToHand() and Duel.IsExistingMatchingCard(c88880520.rmfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)   
end 
function c88880520.throp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88880520.rmfil,tp,LOCATION_DECK,0,nil) 
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)   
	end 
end 








