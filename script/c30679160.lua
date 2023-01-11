--自律部队·支援部队
local m=30679160
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,1,1,cm.lcheck)
	c:EnableReviveLimit() 
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLinkState))
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(cm.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_TOKEN)
end
function cm.indcon(e)
	return e:GetHandler():IsLinkState()
end


