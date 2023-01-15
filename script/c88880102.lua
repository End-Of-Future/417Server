--白鹤梁神女
function c88880102.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,88880102+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c88880102.acop) 
	c:RegisterEffect(e1) 
	--to hand and to deck 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(1,18880102)
	e2:SetTarget(c88880102.thdtg) 
	e2:SetOperation(c88880102.thdop) 
	c:RegisterEffect(e2) 
end
function c88880102.athfil(c) 
	return c:IsAbleToHand() and c:IsLevelAbove(7) and c:IsRace(RACE_WYRM)  
end 
function c88880102.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88880102.athfil,tp,LOCATION_DECK,0,1,nil) 
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(88880102,0)) then 
		local sg=g:Select(tp,1,1,nil) 
		if Duel.SendtoHand(sg,tp,REASON_EFFECT)~=0 then  
		Duel.ConfirmCards(1-tp,sg) 
		Duel.BreakEffect() 
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end 
	end 
end 
function c88880102.thdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880102.rhfil,tp,LOCATION_MZONE,0,1,nil) and g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
end 
function c88880102.thdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil) 
	if Duel.IsExistingMatchingCard(c88880102.rhfil,tp,LOCATION_MZONE,0,1,nil) then 
		local sg=Duel.SelectMatchingCard(tp,c88880102.rhfil,tp,LOCATION_MZONE,0,1,1,nil) 
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT) 
		end 
	end 
end 












