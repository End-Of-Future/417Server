--走去
function c10000009.initial_effect(c)
	c:SetUniqueOnField(1,0,10000009)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1)  
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c10000009.ckcon)
	e2:SetValue(c10000009.aclimit)
	c:RegisterEffect(e2)
end
function c10000009.ckfil(c) 
	return c:IsFaceup() and c:IsCode(10000008)  
end 
function c10000009.ckcon(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(c10000009.ckfil,tp,LOCATION_SZONE,0,1,nil)   
end  
function c10000009.aclimit(e,re,tp) 
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsLocation(LOCATION_SZONE) and re:GetHandler():IsFacedown() 
end











