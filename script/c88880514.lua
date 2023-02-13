--王牌竞赛 银
function c88880514.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,88880514)
	e1:SetCondition(c88880514.spcon)
	e1:SetTarget(c88880514.sptg)
	e1:SetOperation(c88880514.spop)
	c:RegisterEffect(e1)	
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,18880514)
	e2:SetCondition(c88880514.condition2)
	e2:SetCost(c88880514.cost2)
	e2:SetOperation(c88880514.operation2)
	c:RegisterEffect(e2)
end
function c88880514.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0xd88)
end
function c88880514.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c88880514.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c88880514.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c88880514.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c88880514.condition2(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d~=nil and d:IsFaceup() and ((a:IsControler(tp) and a:IsSetCard(0xd88) and a:IsRelateToBattle())
		or (d:IsControler(tp) and d:IsSetCard(0xd88) and d:IsRelateToBattle()))
end
function c88880514.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c88880514.operation2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	if a:IsControler(tp) then
		e1:SetValue(d:GetAttack())
		a:RegisterEffect(e1)
	else
		e1:SetValue(a:GetAttack())
		d:RegisterEffect(e1)
	end
end







