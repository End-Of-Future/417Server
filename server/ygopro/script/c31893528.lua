--死のメッセージ「E」
function c31893528.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_COST)
	e2:SetCost(c31893528.spcost)
	c:RegisterEffect(e2)
end
function c31893528.spcost(e,c,tp,sumtype)
	return sumtype==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_DARK_SANCTUARY
end
