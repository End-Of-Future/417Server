--圣光天域
function c27819006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(c27819006.efilter)
	c:RegisterEffect(e2)
	--des 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED) 
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c27819006.descon)
	e3:SetOperation(c27819006.desop)
	c:RegisterEffect(e3) 
	--indes 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(c27819006.inval)
	c:RegisterEffect(e4)
end 
c27819006.SetCard_XXLight=true 
function c27819006.actcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and re:IsActiveType(TYPE_MONSTER)
end 
function c27819006.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,27819006)
	Duel.SetChainLimit(c27819006.chainlm)
end
function c27819006.chainlm(e,rp,tp)
	return tp==rp
end
function c27819006.ckfil(c) 
	return c:IsPreviousLocation(LOCATION_ONFIELD)  
end 
function c27819006.descon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c27819006.ckfil,1,nil) 
end 
function c27819006.atkfil(c) 
	return c.SetCard_XXLight and c:IsFaceup() 
end 
function c27819006.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,27819006) 
	local g=Duel.GetMatchingGroup(c27819006.atkfil,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then 
	local tc=g:GetFirst() 
	while tc do 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(100)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	tc:RegisterEffect(e1) 
	tc=g:GetNext() 
	end 
	end 
	local x=Duel.GetMatchingGroupCount(c27819006.atkfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
	if x>0 then 
	Duel.Recover(tp,x*100,REASON_EFFECT) 
	end 
end 
function c27819006.inval(e,re,rp) 
	local tp=e:GetHandlerPlayer()
	return re:IsActiveType(TYPE_MONSTER) and rp==tp and re:GetHandler().SetCard_XXLight 
end 
function c27819006.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:GetHandler().SetCard_XXLight and te:IsActiveType(TYPE_MONSTER) and Duel.GetTurnPlayer()==p   
end

