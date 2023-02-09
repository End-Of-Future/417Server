--走来
function c10000008.initial_effect(c)
	c:SetUniqueOnField(1,0,10000008) 
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1)  
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_SZONE) 
	e1:SetCondition(c10000008.ckcon)
	e1:SetTargetRange(0,LOCATION_MZONE) 
	c:RegisterEffect(e1)
end 
function c10000008.ckfil(c) 
	return c:IsFaceup() and c:IsCode(10000009)  
end 
function c10000008.ckcon(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(c10000008.ckfil,tp,LOCATION_SZONE,0,1,nil)	
end  


