--超高校级•侦探
function c88882109.initial_effect(c)
	c:SetSPSummonOnce(88882109)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c88882109.lcheck)
	c:EnableReviveLimit()   
	--code 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)  
	e1:SetTarget(c88882109.cdtg) 
	e1:SetOperation(c88882109.cdop)  
	c:RegisterEffect(e1)  
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c88882109.tgtg)
	e2:SetValue(1)
	c:RegisterEffect(e2) 
	--atk up 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD) 
	e3:SetCode(EFFECT_UPDATE_ATTACK) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c88882109.tgtg)
	e3:SetValue(500)
	c:RegisterEffect(e3)  
end
c88882109.ACGXJre=true  
function c88882109.lcckfil(c) 
	return c.ACGXJre   
end 
function c88882109.lcheck(g)
	return g:IsExists(c88882109.lcckfil,1,nil)
end  
function c88882109.cdfil(c) 
	return c:IsFaceup() and not c:IsCode(88882109) 
end 
function c88882109.cdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(c88882109.cdfil,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c88882109.cdfil,tp,LOCATION_MZONE,0,1,1,nil)
end 
function c88882109.cdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_CHANGE_CODE) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(88882109) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
	tc:RegisterEffect(e1) 
	end 
end 
function c88882109.tgtg(e,c)
	return c:GetMutualLinkedGroupCount()>0 
end










