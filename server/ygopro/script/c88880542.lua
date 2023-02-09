--来吧！再猛烈些吧！
function c88880542.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--must attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e1) 
	--to deck and draw 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e2:SetCountLimit(1,88880542) 
	e2:SetTarget(c88880542.tddtg) 
	e2:SetOperation(c88880542.tddop) 
	c:RegisterEffect(e2) 
end
function c88880542.tddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2) 
end 
function c88880542.tddop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,3,nil) 
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,2) then 
			Duel.Draw(tp,2,REASON_EFFECT) 
		end 
	end 
end 










