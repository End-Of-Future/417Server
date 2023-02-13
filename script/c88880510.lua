--王牌竞赛 老兵
function c88880510.initial_effect(c)
	--sp 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,88880510)  
	e1:SetCost(c88880510.spcost)
	e1:SetTarget(c88880510.sptg) 
	e1:SetOperation(c88880510.spop) 
	c:RegisterEffect(e1) 
	--remove  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE) 
	e2:SetCountLimit(1,18880510)  
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c88880510.rmtg)
	e2:SetOperation(c88880510.rmop)
	c:RegisterEffect(e2)
end 
function c88880510.sctfil(c) 
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0xd88) and not c:IsCode(88880510)  
end 
function c88880510.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c88880510.sctfil,tp,LOCATION_DECK,0,1,nil) end  
	local g=Duel.SelectMatchingCard(tp,c88880510.sctfil,tp,LOCATION_DECK,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_EFFECT) 
end 
function c88880510.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c88880510.spop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c88880510.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c88880510.splimit(e,c)
	return not c:IsSetCard(0xd88) 
end
function c88880510.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end 
function c88880510.rmop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
		local rg=g:Select(tp,1,1,nil) 
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) 
	end 
end 










