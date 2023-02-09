--光耀无辉之境
function c27819009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c27819009.cost)
	e1:SetTarget(c27819009.target)
	e1:SetOperation(c27819009.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c27819009.reptg)
	e2:SetValue(c27819009.repval)
	e2:SetOperation(c27819009.repop)
	c:RegisterEffect(e2)
end 
c27819009.SetCard_XXLight=true 
function c27819009.ctfil(c) 
	return c.SetCard_XXLight and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() 
end 
function c27819009.cost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c27819009.ctfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c27819009.ctfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_COST)
end 
function c27819009.thfil(c) 
	return c:IsType(TYPE_MONSTER) and c.SetCard_XXLight and c:IsAbleToHand()
end 
function c27819009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,27819034,nil,TYPES_TOKEN_MONSTER,0,0,3,RACE_FAIRY,ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(c27819009.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27819009.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,27819034,nil,TYPES_TOKEN_MONSTER,0,0,3,RACE_FAIRY,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,27819034)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0
		and Duel.IsExistingMatchingCard(c27819009.thfil,tp,LOCATION_DECK,0,1,nil) then
		local sg=Duel.SelectMatchingCard(tp,c27819009.thfil,tp,LOCATION_DECK,0,1,1,nil)
		Duel.BreakEffect()
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c27819009.repfilter(c,tp)
	return c:IsFaceup() and c.SetCard_XXLight and c:IsType(TYPE_MONSTER)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c27819009.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c27819009.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c27819009.repval(e,c)
	return c27819009.repfilter(c,e:GetHandlerPlayer())
end
function c27819009.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end




