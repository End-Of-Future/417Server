--圣光之源石
function c27822031.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c27822031.mfilter,1,1)
	c:EnableReviveLimit()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c27822031.regcon)
	e1:SetOperation(c27822031.regop)
	c:RegisterEffect(e1)
	--to hand 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,27822031) 
	e1:SetCost(c27822031.thcost)
	e1:SetTarget(c27822031.thtg) 
	e1:SetOperation(c27822031.thop) 
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,27822031) 
	e2:SetCost(aux.bfgcost) 
	e2:SetTarget(c27822031.sptg) 
	e2:SetOperation(c27822031.spop) 
	c:RegisterEffect(e2) 
end
c27822031.SetCard_XXLight=true 
function c27822031.mfilter(c)
	return c:IsLevelBelow(4) and c.SetCard_XXLight
end
function c27822031.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c27822031.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c27822031.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c27822031.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(27822031) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c27822031.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsReleasable() end 
	Duel.Release(e:GetHandler(),REASON_COST) 
end 
function c27822031.thfil(c) 
	return c.SetCard_XXLight and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsAbleToHand()   
end 
function c27822031.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c27822031.thfil,tp,LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c27822031.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
end 
function c27822031.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
	Duel.SendtoHand(tc,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,tc) 
	end 
end  
function c27822031.spfil(c,e,tp) 
	return c.SetCard_XXLight and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end 
function c27822031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c27822031.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end 
function c27822031.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c27822031.spfil,tp,LOCATION_HAND,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
end 












