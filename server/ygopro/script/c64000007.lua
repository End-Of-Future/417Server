--幻星彩河之魔女
function c64000007.initial_effect(c)
		aux.AddLinkProcedure(c,nil,2,3,c64000007.lcheck)
	c:EnableReviveLimit()
--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCondition(c64000007.efcon)
	e1:SetValue(c64000007.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c64000007.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
--P Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(64000007,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,64000013)
	e3:SetCondition(c64000007.pcon)
	e3:SetTarget(c64000007.ptg)
	e3:SetOperation(c64000007.pop)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCondition(c64000007.pcon1)
	e5:SetOperation(c64000007.pop1)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCondition(c64000007.pcon2)
	e6:SetOperation(c64000007.pop2)
	c:RegisterEffect(e6)
--change effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(64000007,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,64000014)
	e4:SetCondition(c64000007.chcon)
	e4:SetTarget(c64000007.chtg)
	e4:SetOperation(c64000007.chop)
	c:RegisterEffect(e4)
end
function c64000007.efcon(e)
	return e:GetHandler():GetSequence()<=7
end
function c64000007.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM)
end
function c64000007.eftg(e,c)
	return (c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_PZONE)) or e:GetHandler():GetLinkedGroup():IsContains(c)
end

function c64000007.efilter(e,te)
	if te:GetHandlerPlayer()==e:GetHandlerPlayer() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local mc=tg:GetCount()
	if mc~=1 then return true end
	return not tg or not tg:IsContains(e:GetHandler())
end
function c64000007.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_PZONE)==0 and Duel.GetFlagEffect(tp,64000007)==0 and e:GetHandler():GetSequence()>4
end
function c64000007.pcon1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local b=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if not b then return false end
	if a+b~=5 then return false end
	return Duel.GetLocationCount(tp,LOCATION_PZONE)==0 and Duel.GetFlagEffect(tp,64000007)==0
end
function c64000007.pcon2(e,tp,eg,ep,ev,re,r,rp)
	local a1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if not b1 then return false end
	if a1+b1<=5 then return false end
	return Duel.GetLocationCount(tp,LOCATION_PZONE)==0 and Duel.GetFlagEffect(tp,64000007)==0 and e:GetHandler():GetSequence()<=4
end
function c64000007.pfilter(c,e,tp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not tc1 or not tc2 then return false end
	local scl1=tc1:GetLeftScale()
	local scl2=tc2:GetRightScale()
	if scl1>scl2 then scl1,scl2=scl2,scl1 end
	local scl1=scl1+1
	local scl2=scl2-1
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
		 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false,POS_FACEUP) and c:IsLevelAbove(scl1) and c:IsLevelBelow(scl2)
		and (c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c64000007.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64000007.pfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c64000007.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fff=0
	local num=Duel.GetLocationCountFromEx(tp,tp,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c64000007.pfilter,tp,LOCATION_EXTRA,0,fff,num,nil,e,tp)
	if g:GetCount()==0 then local fff=1 end
	local num1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local num1=num1-num
	local g1=Duel.SelectMatchingCard(tp,c64000007.pfilter,tp,LOCATION_HAND,0,fff,num1,nil,e,tp)
	Duel.SpecialSummon(g+g1,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
	if c:IsRelateToEffect(e) then
		Duel.RegisterFlagEffect(tp,64000007,RESET_PHASE+PHASE_END,0,2)
	end
end
function c64000007.pop1(e,tp,eg,ep,ev,re,r,rp)
	local fc=e:GetHandler()
	local eee=0
	local num2=Duel.GetLocationCountFromEx(tp,tp,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c64000007.pfilter,tp,LOCATION_EXTRA,0,eee,num2,nil,e,tp)
	if g2:GetCount()==0 then local eee=1 end
	local num3=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local num3=num3-num2+1
	local g3=Duel.SelectMatchingCard(tp,c64000007.pfilter,tp,LOCATION_HAND,0,eee,num3,nil,e,tp)
	Duel.SpecialSummon(g2+g3,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
	if fc:IsRelateToEffect(e) then
		Duel.RegisterFlagEffect(tp,64000007,RESET_PHASE+PHASE_END,0,2)
	end
end
function c64000007.pop2(e,tp,eg,ep,ev,re,r,rp)
	local fc1=e:GetHandler()
	local ddd=0
	local num4=Duel.GetLocationCountFromEx(tp,tp,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g4=Duel.SelectMatchingCard(tp,c64000007.pfilter,tp,LOCATION_EXTRA,0,ddd,num4,nil,e,tp)
	if g4:GetCount()==0 then local ddd=1 end
	local num5=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local num5=num5-num4
	local g5=Duel.SelectMatchingCard(tp,c64000007.pfilter,tp,LOCATION_HAND,0,ddd,num5,nil,e,tp)
	Duel.SpecialSummon(g4+g5,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
	if fc1:IsRelateToEffect(e) then
		Duel.RegisterFlagEffect(tp,64000007,RESET_PHASE+PHASE_END,0,2)
	end
end
function c64000007.chcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function c64000007.chfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c64000007.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64000007.chfilter,tp,LOCATION_EXTRA,0,1,nil,REASON_EFFECT) end
end
function c64000007.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c64000007.repop)
end
function c64000007.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
	local des=Duel.SelectMatchingCard(1-tp,c64000007.chfilter,1-tp,LOCATION_EXTRA,0,1,1,nil)
	if des then
	Duel.Destroy(des,REASON_EFFECT) end
end