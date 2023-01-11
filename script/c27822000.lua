--激流之都
function c27822000.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1) 
	--up 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_FZONE) 
	e2:SetTargetRange(LOCATION_MZONE,0) 
	e2:SetTarget(function(e,c) 
	return c.XXSplash end) 
	e2:SetValue(200) 
	c:RegisterEffect(e2) 
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE) 
	e2:SetRange(LOCATION_FZONE)   
	e2:SetTargetRange(LOCATION_ONFIELD,0) 
	e2:SetValue(function(e,re,rp) 
	return rp==e:GetHandlerPlayer() and re:GetHandler().XXSplash end) 
	c:RegisterEffect(e2) 
	--token
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,27822000)
	e3:SetCost(c27822000.tkcost)
	e3:SetTarget(c27822000.tktg)
	e3:SetOperation(c27822000.tkop)
	c:RegisterEffect(e3)
end
c27822000.XXSplash=true 
function c27822000.tkcostfilter(c)
	return c:IsType(TYPE_LINK) and c.XXSplash and c:IsAbleToRemoveAsCost()
end
function c27822000.tkcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c27822000.tkcostfilter,tp,LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c27822000.tkcostfilter,tp,LOCATION_GRAVE,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c27822000.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,27822030,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c27822000.tkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,27822030,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE) then return end
	local token=Duel.CreateToken(tp,27822030)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE) 
end







