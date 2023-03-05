--超魔导的秘仪
function c98910555.initial_effect(c)
	aux.AddCodeList(c,46986414)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98910555,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98910555)
	e1:SetCost(c98910555.cost)
	e1:SetTarget(c98910555.target)
	e1:SetOperation(c98910555.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98910555,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,98910555)
	e2:SetCost(c98910555.cost)
	e2:SetTarget(c98910555.rtarget)
	e2:SetOperation(c98910555.ractivate)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(98910555,ACTIVITY_SPSUMMON,c98910555.counterfilter)
end
function c98910555.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_FUSION)
end
function c98910555.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(98910555,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98910555.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c98910555.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION)
end
function c98910555.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c98910555.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c98910555.filter2(c,e,tp,m,f,chkf)
	if not (c:IsType(TYPE_FUSION) and (aux.IsMaterialListCode(c,46986414) or aux.IsMaterialListCode(c,38033121)) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	aux.FCheckAdditional=c.branded_fusion_check or c98910555.fcheck
	local res=c:CheckFusionMaterial(m,nil,chkf)
	aux.FCheckAdditional=nil
	return res
end
function c98910555.fcheck(tp,sg,fc)
	return sg:GetCount()<=2 and (sg:IsExists(Card.IsFusionCode,1,nil,46986414) or sg:IsExists(Card.IsFusionCode,1,nil,38033121))
end
function c98910555.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c98910555.filter0,tp,LOCATION_DECK,0,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c98910555.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c98910555.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98910555.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c98910555.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c98910555.filter0,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c98910555.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c98910555.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			aux.FCheckAdditional=tc.branded_fusion_check or c98910555.fcheck
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c98910555.rfilter(c,lv,e,tp)
	return  aux.IsCodeListed(c,46986414) and c:IsType(TYPE_RITUAL) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c98910555.rfilter1(c,lv)
	return c:IsLevelAbove(lv) and c:IsReleasableByEffect() and c:IsCanBeRitualMaterial(nil) and not c:IsType(TYPE_RITUAL)
end
function c98910555.rfilter2(c)
	return c:IsCode(38033121,46986414) and c:IsAbleToGrave()
end
function c98910555.rtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=13
	local y=0
	local a=Duel.GetMatchingGroup(c98910555.rfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,13,e,tp)
	if a:GetCount()~=0 then
	local a1=a:GetFirst()
	while a1 do
	if a1:IsLevelBelow(lv) then lv=a1:GetLevel() end
	a1=a:GetNext()
	end end
	local b=Duel.GetMatchingGroup(c98910555.rfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,0)
	if b:GetCount()~=0 then
	local b1=b:GetFirst()
	while b1 do
	if b1:IsLevelAbove(lv) then y=y+1 end
	b1=b:GetNext()
	end end
	if chk==0 then return y>0 or (Duel.IsExistingMatchingCard(c98910555.rfilter2,tp,LOCATION_DECK,0,1,nil) and a) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c98910555.ractivate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c98910555.rfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,13,e,tp) then return end
	local lv=13
	local y=0
	local a=Duel.GetMatchingGroup(c98910555.rfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,lv,e,tp)
	if a:GetCount()~=0 then
	local a1=a:GetFirst()
	while a1 do
	if a1:IsLevelBelow(lv) then lv=a1:GetLevel() end
	a1=a:GetNext()
	end end
	local b=Duel.GetMatchingGroup(c98910555.rfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,0)
	if b:GetCount()~=0 then
	local b1=b:GetFirst()
	while b1 do
	if b1:IsLevelAbove(lv) then y=y+1 end
	b1=b:GetNext()
	end end
	local f=0
	if Duel.IsExistingMatchingCard(c98910555.rfilter2,tp,LOCATION_DECK,0,1,nil) and y==0 then f=0 end
	if not Duel.IsExistingMatchingCard(c98910555.rfilter2,tp,LOCATION_DECK,0,1,nil) and y>0 then f=1 end
	if Duel.IsExistingMatchingCard(c98910555.rfilter2,tp,LOCATION_DECK,0,1,nil) and y>0 then f=2 end
	if f==2 then f=Duel.SelectOption(tp,aux.Stringid(98910555,3),aux.Stringid(98910555,2)) end
	if f==0 then
		local g=Duel.SelectMatchingCard(tp,c98910555.rfilter2,tp,LOCATION_DECK,0,1,1,nil) 
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			local sg=Duel.SelectMatchingCard(tp,c98910555.rfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,13,e,tp)
			Duel.SpecialSummon(sg,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			sg:GetFirst():CompleteProcedure()
		end
	end
	if f==1 then
		local g=Duel.SelectMatchingCard(tp,c98910555.rfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,lv) 
		if Duel.ReleaseRitualMaterial(g)~=0 then
			local sg=Duel.SelectMatchingCard(tp,c98910555.rfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,g:GetFirst():GetLevel(),e,tp)
			Duel.SpecialSummon(sg,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			sg:GetFirst():CompleteProcedure()
		end
	end
end

