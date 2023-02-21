--诡戏的双子恶魔
function c64000027.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,64000027+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c64000027.target)
	e1:SetOperation(c64000027.activate)
	c:RegisterEffect(e1)
end
function c64000027.filter(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c64000027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64000027.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c64000027.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if a==0 then return end
	if a>2 then a=2 end
	local g=Duel.SelectMatchingCard(tp,c64000027.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,a,nil,e,tp) 
	if g:GetCount()>a or g:GetCount()<1 then return end
	local tc=g:GetFirst()
	while tc do
	Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_TRIGGER)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end