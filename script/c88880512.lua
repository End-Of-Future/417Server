--王牌竞赛 枭
function c88880512.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,88880512)
	e1:SetCondition(c88880512.discon)
	e1:SetCost(c88880512.discost)
	e1:SetTarget(c88880512.distg)
	e1:SetOperation(c88880512.disop)
	c:RegisterEffect(e1) 
	--sp 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,18880512)
	e2:SetTarget(c88880512.sptg) 
	e2:SetOperation(c88880512.spop) 
	c:RegisterEffect(e2) 
end
function c88880512.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c88880512.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST) 
end 
function c88880512.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0xd88) and c:IsSummonLocation(LOCATION_EXTRA+LOCATION_GRAVE)  
end 
function c88880512.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c88880512.thfil,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c88880512.thfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c88880512.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if Duel.NegateActivation(ev) and tc:IsRelateToEffect(e) then 
		Duel.SendtoHand(tc,nil,REASON_EFFECT) 
	end 
end 
function c88880512.spfil(c,e,tp,eg) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xd88) and eg:IsExists(Card.IsCode,1,nil,c:GetCode()) 
end 
function c88880512.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880512.spfil,tp,LOCATION_DECK,0,1,nil,e,tp,eg) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end 
function c88880512.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88880512.spfil,tp,LOCATION_DECK,0,nil,e,tp,eg) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
end 














