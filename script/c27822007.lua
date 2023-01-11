--激流之术灵
function c27822007.initial_effect(c) 
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c27822007.mfilter,2,2) 
	--battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.imval1) 
	e1:SetCondition(function(e) 
	return e:GetHandler():GetMutualLinkedGroupCount()>0 end)
	c:RegisterEffect(e1) 
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval) 
	e1:SetCondition(function(e) 
	return e:GetHandler():GetMutualLinkedGroupCount()>0 end)
	c:RegisterEffect(e1) 
	--indes 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTargetRange(LOCATION_SZONE,0) 
	e2:SetTarget(function(e,c) 
	return c.XXSplash and c:IsFaceup() end) 
	e2:SetValue(1) 
	c:RegisterEffect(e2) 
	--down 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE) 
	e2:SetValue(c27822007.atkval) 
	c:RegisterEffect(e2)
end
c27822007.XXSplash=true 
function c27822007.mfilter(c) 
	return c.XXSplash 
end 
function c27822007.ckfil(c) 
	return c:IsFaceup() and c.XXSplash  
end
function c27822007.atkval(e) 
	local tp=e:GetHandlerPlayer()
	return -100*Duel.GetMatchingGroupCount(c27822007.ckfil,tp,LOCATION_MZONE,0,nil)
end 










