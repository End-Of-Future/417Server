--大师之作！匠心的制作！
local m=30600100
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xc12) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.fcheck(tp,sg,fc)
	return sg:GetCount()>=3
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
		local mg2=Duel.GetMatchingGroup(cm.filter0,tp,0,LOCATION_MZONE,nil)
		mg1:Merge(mg2)
		aux.FGoalCheckAdditional=cm.fcheck
		local res1=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res1 then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res1=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		aux.FGoalCheckAdditional=nil
		return res1
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_MONSTER)
end
function cm.filter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function cm.mfilter1(c,e)
	return c:IsLocation(LOCATION_HAND) and not c:IsImmuneToEffect(e)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg=Duel.GetFusionMaterial(tp)
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
	local mg2=Duel.GetMatchingGroup(cm.filter0,tp,0,LOCATION_MZONE,nil)
	local mg3=mg:Filter(cm.mfilter1,nil,e)
		mg1:Merge(mg2)
		mg1:Merge(mg3)
	aux.FGoalCheckAdditional=cm.fcheck
	local sg1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local res=false
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			res=true
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
			res=true
		end
		tc:CompleteProcedure()
		   --攻击力·守备力上升
		local g=tc:GetMaterial()
		local s=0
		local d=0
		local ttcc=g:GetFirst()
	while ttcc do
		local a=ttcc:GetBaseAttack()
		local b=ttcc:GetBaseDefense()
		s=s+a
		d=d+b
		ttcc=g:GetNext()
	end
	local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(s)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(d)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
		
	end
	aux.FGoalCheckAdditional=nil
end