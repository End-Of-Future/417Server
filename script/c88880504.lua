--王牌竞赛 迷雾
function c88880504.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c88880504.spcon)   
	e1:SetCountLimit(1,88880504+EFFECT_COUNT_CODE_OATH) 
	c:RegisterEffect(e1)	
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c:IsSetCard(0xd88) end)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function c88880504.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd88) 
end
function c88880504.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c88880504.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end







