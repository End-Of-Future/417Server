--五王-生命圣魂
function c27819086.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,27819086) 
	e1:SetCondition(c27819086.spcon)
	e1:SetCost(c27819086.spcost)
	e1:SetTarget(c27819086.sptg) 
	e1:SetOperation(c27819086.spop) 
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,27819086) 
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c27819086.thtg) 
	e2:SetOperation(c27819086.thop) 
	c:RegisterEffect(e2)  
end
c27819086.SetCard_fiveking=true
function c27819086.cfilter(c)
	return c:IsFacedown() or not c.SetCard_fiveking 
end
function c27819086.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c27819086.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c27819086.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end 
function c27819086.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c.SetCard_fiveking 
end 
function c27819086.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27819086.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end 
function c27819086.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c27819086.spfil,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then  
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c27819086.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c27819086.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c.SetCard_fiveking 
end 
function c27819086.thfil(c) 
	return c:IsAbleToHand() and c.SetCard_fiveking  
end 
function c27819086.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c27819086.thfil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end 
	local g=Duel.SelectTarget(tp,c27819086.thfil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler()) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0) 
end 
function c27819086.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
	Duel.SendtoHand(tc,nil,REASON_EFFECT) 
	end 
end 








