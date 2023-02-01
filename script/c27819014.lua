--圣光普照大地
function c27819014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,27819014+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c27819014.cost)
	e1:SetTarget(c27819014.target)
	e1:SetOperation(c27819014.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(27819014,ACTIVITY_SPSUMMON,c27819014.counterfilter)
end 
c27819014.SetCard_XXLight=true 
function c27819014.counterfilter(c)
	return c.SetCard_XXLight 
end
function c27819014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(27819014,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c27819014.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c27819014.splimit(e,c) 
	return not c.SetCard_XXLight and not c:IsCode(27819034)
end
function c27819014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,27819034,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE)  and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c27819014.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) or not Duel.IsPlayerCanSpecialSummonMonster(tp,27819034,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,27819034)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end 
	Duel.SpecialSummonComplete()
end



