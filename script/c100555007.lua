--智慧与狂妄之龙
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),1,2,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,id+o+o+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(s.exspcon)
	e3:SetTarget(s.exsptg)
	e3:SetOperation(s.exspop)
	c:RegisterEffect(e3)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.tgfi(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function s.thfi(c)
	return c:IsRace(RACE_DRAGON) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.tgfi(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thgi,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(s.thfi,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,s.tgfi,tp,LOCATION_MZONE,0,1,1,e:GetHandler()):GetFirst()
	if tc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local a=1
	if tc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) then a=2 end
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,s.thfi,tp,LOCATION_DECK,0,1,a,nil)
	if #tg>0 then 
		if Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,tg)
			if a==2 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return true end
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
	if e:GetHandler():GetMaterialCount()==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.actlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.actlimit(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsRace(RACE_DRAGON)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.filter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,0,0)
end
function s.subfi(sg,e,tp)
	return sg:Filter(s.filter,nil,e,tp):GetCount()==#sg and sg:GetClassCount(Card.GetLocation)==2
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local hgg=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_GRAVE,0)
	if chk==0 then return hgg:CheckSubGroup(s.subfi,2,2,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local hgg=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_GRAVE,0)
	local sg=hgg:SelectSubGroup(tp,s.subfi,false,2,2,e,tp)
	if #sg>0 then
		local sc=sg:GetFirst()
		while sc do
			Duel.SpecialSummonStep(sc,0,tp,tp,0,0,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			sc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
	if e:GetHandler():GetMaterialCount()==1 then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetValue(s.actlimit)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.exspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsExtraLinkState,tp,LOCATION_MZONE,0,1,nil)
end
function s.exfi(c,e,tp)
	local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0):Filter(Card.IsAbleToGrave,nil)
	local dg2=Duel.GetFieldGroup(tp,LOCATION_DECK,0):Filter(Card.IsCanBeXyzMaterial,nil,nil)
	return c:IsRace(RACE_DRAGON)
		and (c:IsType(TYPE_FUSION) and c:CheckFusionMaterial(dg,nil) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,0,0)) or (c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(nil,dg)) or (c:IsType(TYPE_XYZ) and c:IsXyzSummonable(dg2)) or (c:IsType(TYPE_LINK) and c:IsLinkSummonable(dg))
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.exsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.exfi,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.exspop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0):Filter(Card.IsAbleToGrave,nil)
	local dg2=Duel.GetFieldGroup(tp,LOCATION_DECK,0):Filter(Card.IsCanBeXyzMaterial,nil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ec=Duel.SelectMatchingCard(tp,s.exfi,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if ec then
		if ec:IsType(TYPE_FUSION) then
			local fg=Duel.SelectFusionMaterial(tp,ec,dg)
			if #fg>0 then
				Duel.SendtoGrave(fg,REASON_EFFECT)
				Duel.SpecialSummon(ec,SUMMON_TYPE_FUSION,tp,tp,0,0,POS_FACEUP)
				ec:CompleteProcedure()
			end
		end
		if ec:IsType(TYPE_SYNCHRO) then 
			Duel.SynchroSummon(tp,ec,nil,dg,1,99)
		end
		if ec:IsType(TYPE_XYZ) then 
			Duel.XyzSummon(tp,ec,dg2,1,99)
		end
		if ec:IsType(TYPE_LINK) then 
			Duel.LinkSummon(tp,ec,dg,nil,1,99)
		end
	end
	if e:GetHandler():GetMaterialCount()==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.actlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
