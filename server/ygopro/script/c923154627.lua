--通常融合
function c923154627.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,923154627+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c923154627.target)
	e1:SetOperation(c923154627.activate)
	c:RegisterEffect(e1)
end
function c923154627.filter0(c)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c923154627.filter1(c,e)
	return not c:IsImmuneToEffect(e) and c:IsOnField() and c:IsType(TYPE_NORMAL)
end
function c923154627.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c923154627.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c923154627.filter0,tp,LOCATION_DECK,0,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c923154627.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c923154627.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c923154627.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp)
	local mg3=Duel.GetMatchingGroup(c923154627.filter0,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg3)
	local sg1=Duel.GetMatchingGroup(c923154627.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c923154627.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		if not tc:IsType(TYPE_NORMAL) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCountLimit(1)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetValue(TYPE_NORMAL)
			tc:RegisterEffect(e1)
			if tc:IsType(TYPE_EFFECT) then
				local e2=e1:Clone()
				e2:SetCode(EFFECT_REMOVE_TYPE)
				e2:SetCountLimit(1)
				e2:SetValue(TYPE_EFFECT)
				tc:RegisterEffect(e2)
			end
		end
	end
end
