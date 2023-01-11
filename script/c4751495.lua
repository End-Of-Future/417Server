--聚变龙
function c4751495.initial_effect(c)
	c:SetUniqueOnField(1,1,4751495)
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,c4751495.matfi,1,63,1543673,4723591,70095154)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c4751495.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c4751495.rmcon)
	e2:SetOperation(c4751495.rmop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCondition(c4751495.spcon)
	e3:SetOperation(c4751495.spop)
	c:RegisterEffect(e3)
end
--不会写额外参数
function c4751495.bfi(c)
	return c:IsCode(1543673)
end
function c4751495.cfi(c)
	return c:IsCode(4723591)
end
function c4751495.afi(c)
	return c:IsCode(70095154)
end
function c4751495.abcfi(c)
	return (c:IsCode(1543673) or c:IsCode(4723591) or c:IsCode(70095154)) and c:IsAbleToDeck()
end
function c4751495.matfi(c)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeFusionMaterial()
end
function c4751495.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsCode(4751495)
end
function c4751495.rmfi(c)
	return c:IsAbleToRemove()
end
function c4751495.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c4751495.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c4751495.rmfi,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c4751495.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c4751495.afi,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c4751495.bfi,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c4751495.cfi,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c4751495.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local g=Duel.GetMatchingGroup(c4751495.abcfi,tp,LOCATION_GRAVE,0,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,0,0,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(8000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end