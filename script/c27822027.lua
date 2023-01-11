--通往深渊的激流之路
function c27822027.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetOperation(c27822027.acop)  
	c:RegisterEffect(e1) 
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT) 
	e2:SetRange(LOCATION_SZONE)   
	e2:SetTargetRange(LOCATION_MZONE,0) 
	e2:SetTarget(function(e,c) 
	return c:IsType(TYPE_LINK) end)
	e2:SetValue(function(e,te) 
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer() end) 
	e2:SetCondition(c27822027.xxcon)
	c:RegisterEffect(e2)
	--atk  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_SZONE)   
	e2:SetTargetRange(LOCATION_MZONE,0) 
	e2:SetTarget(function(e,c) 
	return c:IsType(TYPE_LINK) end)
	e2:SetValue(1000) 
	e2:SetCondition(c27822027.xxcon)
	c:RegisterEffect(e2)	 
end 
c27822027.XXSplash=true 
function c27822027.acfil(c,tp)
	return c:IsCode(27822000) and c:GetActivateEffect():IsActivatable(tp) 
end
function c27822027.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c27822027.acfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(27822027,0)) then 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	local te=tc:GetActivateEffect()
	local tep=tc:GetControler()
	local cost=te:GetCost()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end   
end 
function c27822027.ckfil(c) 
	return c:IsFaceup() and c:IsCode(27822000) 
end 
function c27822027.xxcon(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(c27822027.ckfil,tp,LOCATION_FZONE,0,1,nil) 
end 






 