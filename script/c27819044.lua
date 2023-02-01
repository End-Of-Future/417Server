--圣光飞龙的言灵
function c27819044.initial_effect(c) 
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27819044,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCountLimit(1,27819044) 
	e1:SetCondition(c27819044.spcon) 
	e1:SetTarget(c27819044.sptg)
	e1:SetOperation(c27819044.spop)
	c:RegisterEffect(e1)	
end 
c27819044.SetCard_XXLight=true   
c27819044.SetCard_XXLightDragon=true 
function c27819044.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c27819044.spfil1(c)
	return c:IsLevelBelow(8) and c.SetCard_XXLight and c:IsType(TYPE_TUNER)
end 
function c27819044.spfil2(c)
	return c:IsLevelBelow(8) and c.SetCard_XXLight and not c:IsType(TYPE_TUNER)
end
function c27819044.spgck(g) 
	return g:FilterCount(c27819044.spfil1,nil)==1 
	   and g:FilterCount(c27819044.spfil2,nil)==1   
end  
function c27819044.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,0,tp,false,false,POS_FACEUP_DEFENSE) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 
		and g:CheckSubGroup(c27819044.spgck,2,2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c27819044.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,0,tp,false,false,POS_FACEUP_DEFENSE)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and g:CheckSubGroup(c27819044.spgck,2,2) then 
	local sg=g:SelectSubGroup(tp,c27819044.spgck,false,2,2) 
	local tc=sg:GetFirst() 
	while tc do 
	Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	tc=sg:GetNext() 
	end 
	Duel.SpecialSummonComplete() 
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c27819044.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c27819044.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_SYNCHRO)
end







