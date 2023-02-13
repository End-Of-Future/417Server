--王牌竞赛 飞将
function c88880506.initial_effect(c)
	--to hand 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,88880506) 
	e1:SetCost(c88880506.thcost) 
	e1:SetTarget(c88880506.thtg)
	e1:SetOperation(c88880506.thop) 
	c:RegisterEffect(e1) 
	--sp 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_HAND) 
	e2:SetCountLimit(1,18880506)  
	e2:SetCondition(c88880506.spcon)
	e2:SetTarget(c88880506.sptg) 
	e2:SetOperation(c88880506.spop) 
	c:RegisterEffect(e2)  
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
end
function c88880506.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0xd88) and c:IsType(TYPE_MONSTER) and not c:IsPublic() end,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsSetCard(0xd88) and c:IsType(TYPE_MONSTER) and not c:IsPublic() end,tp,LOCATION_HAND,0,1,1,nil) 
	g:AddCard(e:GetHandler()) 
	Duel.ConfirmCards(1-tp,g) 
end 
function c88880506.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0xd88) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsCode(88880506) end,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c88880506.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(function(c) return c:IsSetCard(0xd88) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsCode(88880506) end,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)  
	end 
end 
function c88880506.spcon(e,tp,eg,ep,ev,re,r,rp)   
	return eg:IsExists(function(c,tp) return c:IsSetCard(0xd88) and c:IsControler(tp) end,1,nil)   
end 
function c88880506.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c88880506.spop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 






