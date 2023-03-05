--幻星集 宝剑
function c66060029.initial_effect(c)
		c:EnableCounterPermit(0x660)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c66060029.ctcon)
	e2:SetOperation(c66060029.ctop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,66060029)
	e3:SetCost(c66060029.cost)
	e3:SetTarget(c66060029.target)
	e3:SetOperation(c66060029.activate)
	c:RegisterEffect(e3)
end
function c66060029.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re and rc:IsSetCard(0x660) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:GetOriginalType()&TYPE_MONSTER~=0
end
function c66060029.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x660,1)
end
function c66060029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x660,10,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x660,10,REASON_COST)
end
function c66060029.filter(c,e,tp)
	return c:IsSetCard(0x660) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c66060029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66060029.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c66060029.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66060029.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		tc:CompleteProcedure()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end end