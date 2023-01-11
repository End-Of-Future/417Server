--自律部队·空降部队
local m=30678475
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)	
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.negcon)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xc13) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.fselect(g,tp)
	return g:GetClassCount(Card.GetLocation)==#g and Duel.IsExistingMatchingCard(cm.synfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function cm.synfilter(c,g)
	return c:IsSetCard(0xc13) and c:IsSynchroSummonable(nil,g)
end
function cm.chkfilter(c,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xc13) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return false end
		local cg=Duel.GetMatchingGroup(cm.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg==0 then return false end
		local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp)
		return g:CheckSubGroup(cm.fselect,2,2,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanSpecialSummonCount(tp,2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		local cg=Duel.GetMatchingGroup(cm.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg>0 then
			local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:SelectSubGroup(tp,cm.fselect,false,2,2,tp)
			if sg then
				local tc=sg:GetFirst()
				while tc do
					Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					tc:RegisterEffect(e2)
					tc=sg:GetNext()
				end
				Duel.SpecialSummonComplete()
				local og=Duel.GetOperatedGroup()
				Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
				if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
				local tg=Duel.GetMatchingGroup(cm.synfilter,tp,LOCATION_EXTRA,0,nil,og)
				if og:GetCount()==sg:GetCount() and tg:GetCount()>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local rg=tg:Select(tp,1,1,nil)
					Duel.SynchroSummon(tp,rg:GetFirst(),nil,og)
				end
			end
		end
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.splimit(e,c)
	return not c:IsSetCard(0xc13)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
		and e:GetHandler():GetFlagEffect(m)==0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end

