--超高校级的解救突围
function c88882116.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_CHAIN_DISABLED) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,88882116+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c88882116.actg) 
	e1:SetOperation(c88882116.acop) 
	c:RegisterEffect(e1)  
end 
c88882116.ACGXJre=true 
function c88882116.ckfil(c,e,tp) 
	return c.ACGXJre and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER) 
end 
function c88882116.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end  
end 
function c88882116.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetValue(aux.tgoval) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetValue(1)  
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)
end 






