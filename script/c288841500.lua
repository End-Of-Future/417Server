--德拉科尼亚·王子
function c288841500.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_NORMAL),2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,288841500)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c288841500.descon)
	e1:SetTarget(c288841500.destg)
	e1:SetOperation(c288841500.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,288841501)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c288841500.spcon)
	e2:SetTarget(c288841500.sptg)
	e2:SetOperation(c288841500.spop)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
	e0:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e0)
end
function c288841500.desfi(c)
	return c:IsOnField() and not c:IsType(TYPE_EFFECT)
end
function c288841500.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c288841500.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(c288841500.desfi,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c288841500.desfi,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c288841500.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,c288841500.desfi,tp,LOCATION_MZONE,0,1,1,nil)
	if dg:GetCount()>0 then
		Duel.Destroy(dg,REASON_EFFECT)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function c288841500.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c288841500.spfi(c,e,tp)
	return c:IsCode(289316427) and c:IsCanBeSpecialSummoned(e,0,tp,0,0)
		and Duel.GetLocationCountFromEx(tp,tp,cil,c)>0
end
function c288841500.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c288841500.spfi,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c288841500.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local gc=Duel.SelectMatchingCard(tp,c288841500.spfi,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if gc then
		Duel.SpecialSummonStep(gc,0,tp,tp,false,false,POS_FACEUP)
		gc:RegisterFlagEffect(288841500,RESET_EVENT+RESETS_STANDARD,0,1)
		Duel.SpecialSummonComplete()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c288841500.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c288841500.splimit(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsType(TYPE_MONSTER)
end
