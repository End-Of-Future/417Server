--时间圣魂
function c27819063.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27819063,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)	 
	e1:SetCountLimit(1,27819063) 
	e1:SetTarget(c27819063.sptg)
	e1:SetOperation(c27819063.spop)
	c:RegisterEffect(e1)	
end
c27819063.SetCard_fiveking=true  
function c27819063.spfilter(c,e,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
		and (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp or c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp))
		and c.SetCard_fiveking and c:IsControler(tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,c:GetPreviousPosition())
end
function c27819063.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and eg:IsExists(c27819063.spfilter,1,nil,e,tp) end
	local g=eg:Filter(c27819063.spfilter,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
end
function c27819063.filter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,c:GetPreviousPosition())
end
function c27819063.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c27819063.filter,nil,e,tp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) and c:IsRelateToEffect(e) then
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			if ft>0 and g:GetCount()>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
				if g:GetCount()>ft then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					g=g:Select(tp,ft,ft,nil)
				end
				local tc=g:GetFirst()
				while tc do
					Duel.SpecialSummonStep(tc,0,tp,tp,false,false,tc:GetPreviousPosition())
					tc=g:GetNext()
				end
			end
		end
		Duel.SpecialSummonComplete()
	end
end









