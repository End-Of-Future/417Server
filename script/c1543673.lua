--原子龙
function c1543673.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1543673.spcon)
	c:RegisterEffect(e1)
end
function c1543673.spfi(c)
	return c:IsCode(70095154) and c:IsFaceup()
end
function c1543673.spcon(e,c)
	if c==nil then return true end
	return (Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)==0 and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)>0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0)
		or (Duel.IsExistingMatchingCard(c1543673.spfi,c:GetControler(),LOCATION_ONFIELD,0,1,nil) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0)
end