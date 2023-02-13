--永欲心魔结合 杂念凭依福音
function c88881680.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c88881680.target)
	e1:SetOperation(c88881680.activate)
	c:RegisterEffect(e1)
end
function c88881680.filter0(c,e,tp)
	return c:IsOnField() and Duel.IsExistingMatchingCard(c88881680.spfilter2,tp,LOCATION_MZONE,0,1,c,e,tp,c)
end
function c88881680.filter1(c,e,tp)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function c88881680.spfilter2(c,e,tp,mc)
	local chkf=tp
	if not c:IsOnField() then return false end
	local e1=nil
	if c:IsSetCard(0x890) then
		--fusion substitute
		e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_FUSION_SUBSTITUTE)
		e1:SetCondition(c88881680.subcon)
		c:RegisterEffect(e1,true)
	end
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
	local res=Duel.IsExistingMatchingCard(c88881680.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	if e1 then e1:Reset() end
	if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c88881680.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
	return res
end
function c88881680.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c88881680.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c88881680.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c88881680.filter0,nil,e,tp)
		return #mg1>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c88881680.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c88881680.filter1,nil,e,tp)
	local mg3=mg1:Filter(Card.IsSetCard,nil,0x890)
	local mg4=Group.CreateGroup()
	local tc=mg3:GetFirst()
	while tc do
		--fusion substitute
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_FUSION_SUBSTITUTE)
		e1:SetCondition(c88881680.subcon)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1,true)
		mg4:AddCard(tc)
		tc=mg3:GetNext()
	end
	mg1:Merge(mg4)
	local sg1=Duel.GetMatchingGroup(c88881680.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c88881680.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(88881680,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c88881680.descon)
		e1:SetOperation(c88881680.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c88881680.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(88881680)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c88881680.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
