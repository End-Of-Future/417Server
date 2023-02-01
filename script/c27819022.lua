--圣光救赎天使
function c27819022.initial_effect(c) 
	--link summon
	aux.AddLinkProcedure(c,c27819022.mfilter,2,99)
	c:EnableReviveLimit()   
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27819022,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,27819022)
	e1:SetCondition(c27819022.spcon)
	e1:SetTarget(c27819022.sptg)
	e1:SetOperation(c27819022.spop) 
end  
c27819022.SetCard_XXLight=true  
function c27819022.mfilter(c)
	return c.SetCard_XXLight 
end
function c27819022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c27819022.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x27) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c27819022.spcheck(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetLocation)==#sg and sg:GetClassCount(Card.GetLevel)==sg:GetCount() 
end
function c27819022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
		return ct>2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.IsExistingMatchingCard(c27819022.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,zone)
			and Duel.IsExistingMatchingCard(c27819022.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone)
			and Duel.IsExistingMatchingCard(c27819022.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c27819022.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		local zone=c:GetLinkedZone(tp)&0x1f
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
		if ct>=3 then
			local g1=Duel.GetMatchingGroup(c27819022.spfilter,tp,LOCATION_HAND,0,nil,e,tp,zone)
			local g2=Duel.GetMatchingGroup(c27819022.spfilter,tp,LOCATION_DECK,0,nil,e,tp,zone)
			local g3=Duel.GetMatchingGroup(aux.NecroValleyFilter(c27819022.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp,zone)
			if #g1>0 and #g2>0 and #g3>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg1=g1:Select(tp,1,1,nil)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg2=g2:Select(tp,1,1,nil)
				sg1:Merge(sg2)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg3=g3:Select(tp,1,1,nil)
				sg1:Merge(sg3)
				Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
				local tc=sg1:GetFirst()
				while tc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
				e2:SetValue(0)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_DISABLE_EFFECT)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e4)
				tc=sg1:GetNext()
				end
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c27819022.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c27819022.splimit(e,c)
	return not c.SetCard_XXLight  
end










