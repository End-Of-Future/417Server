function c10105656.initial_effect(c)
	   --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,13171876,aux.FilterBoolFunction(Card.IsSetCard,0x133),1,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_HAND,0,Duel.SendtoGrave,REASON_COST)
     	--code
	aux.EnableChangeCode(c,13171876,LOCATION_MZONE+LOCATION_GRAVE)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10105656)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c10105656.target)
	e1:SetOperation(c10105656.operation)
	c:RegisterEffect(e1)
    	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10105656.sumtg)
	e2:SetOperation(c10105656.sumop)
	c:RegisterEffect(e2)
    end
function c10105656.filter1(c,tp,satk)
	local atk1=c:GetAttack()
	return c:IsFaceup() and c:IsSetCard(0x133) 
		and Duel.IsExistingTarget(c10105656.filter2,tp,0,LOCATION_MZONE,1,nil,atk1,satk)
end
function c10105656.filter2(c,atk1,satk)
	local atk2=c:GetAttack()
	return c:IsFaceup()  and atk1+atk2>=satk
end
function c10105656.spfilter(c,e,tp,atk)
	return c:IsSetCard(0x133) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not atk or c:IsAttackBelow(atk))
end
function c10105656.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local sg=Duel.GetMatchingGroup(c10105656.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then
		if sg:GetCount()==0 then return false end
		local mg,matk=sg:GetMinGroup(Card.GetAttack)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingTarget(c10105656.filter1,tp,LOCATION_MZONE,0,1,nil,tp,matk)
	end
	local mg,matk=sg:GetMinGroup(Card.GetAttack)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c10105656.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp,matk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,c10105656.filter2,tp,0,LOCATION_MZONE,1,1,nil,g1:GetFirst():GetLevel(),matk)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10105656.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==0 then return end
	Duel.SendtoGrave(tg,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=tg:GetFirst()
	local atk=0
	if tc:IsLocation(LOCATION_GRAVE) then atk=atk+tc:GetAttack() end
	tc=tg:GetNext()
	if tc and tc:IsLocation(LOCATION_GRAVE) then atk=atk+tc:GetAttack() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10105656.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,atk)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.BreakEffect()
		c:SetCardTarget(tc)
	end
	Duel.SpecialSummonComplete()
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(10105656,0))
end
function c10105656.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) and Duel.GetFlagEffect(tp,10105656)==0 end
end
function c10105656.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,10105656)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(10105656,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x133))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,10105656,RESET_PHASE+PHASE_END,0,1)
end