--王牌竞赛 镭射
function c88880508.initial_effect(c)
	--to grave 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,88880508)  
	e1:SetCost(c88880508.tgcost)
	e1:SetTarget(c88880508.tgtg)
	e1:SetOperation(c88880508.tgop)
	c:RegisterEffect(e1)  
	--sp 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,18880508)  
	e2:SetCondition(c88880508.spcon)
	e2:SetTarget(c88880508.sptg) 
	e2:SetOperation(c88880508.spop) 
	c:RegisterEffect(e2)  
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
	--search
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,28880508)
	e4:SetTarget(c88880508.thtg)
	e4:SetOperation(c88880508.thop)
	c:RegisterEffect(e4)  
end
function c88880508.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c88880508.tgfil(c)
	return c:IsSetCard(0xd88) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() 
end
function c88880508.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880508.tgfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c88880508.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c88880508.tgfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT) 
	end
end
function c88880508.spcon(e,tp,eg,ep,ev,re,r,rp)   
	return eg:IsExists(function(c,tp) return c:IsSetCard(0xd88) and c:IsControler(tp) end,1,nil)   
end 
function c88880508.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c88880508.spop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 
function c88880508.thfilter(c)
	return c:IsSetCard(0xd88) and c:IsAbleToHand()
end
function c88880508.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re and not re:GetHandler():IsCode(88880508) and Duel.IsExistingMatchingCard(c88880508.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88880508.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88880508.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end







