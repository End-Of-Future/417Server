--测试
function c64000031.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetOperation(c64000031.operation)
	c:RegisterEffect(e1)
end
function c64000031.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,nil,LOCATION_EXTRA,LOCATION_EXTRA,1,1,nil)
	Duel.SpecialSummon(g,e,tp,tp,true,true,POS_FACEUP)
end