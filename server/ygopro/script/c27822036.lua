--激流-冰流帝
function c27822036.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--negate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,27822036)
	e1:SetCondition(c27822036.discon) 
	e1:SetTarget(c27822036.distg)
	e1:SetOperation(c27822036.disop)
	c:RegisterEffect(e1) 
	--dis and des 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,17822036) 
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) end)
	e2:SetTarget(c27822036.ddtg) 
	e2:SetOperation(c27822036.ddop) 
	c:RegisterEffect(e2)
end
c27822036.XXSplash=true  
function c27822036.discon(e,tp,eg,ep,ev,re,r,rp) 
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_REMOVE) 
	local ex3,g3,gc3,dp3,dv3=Duel.GetOperationInfo(ev,CATEGORY_RELEASE) 
	local ex4,g4,gc4,dp4,dv4=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE) 
	local ex5,g5,gc5,dp5,dv5=Duel.GetOperationInfo(ev,CATEGORY_TOHAND) 
	local ex6,g6,gc6,dp6,dv6=Duel.GetOperationInfo(ev,CATEGORY_TODECK)  
	local ex7,g7,gc7,dp7,dv7=Duel.GetOperationInfo(ev,CATEGORY_TOEXTRA) 
	local b1=ex1 and (bit.band(dv1,LOCATION_ONFIELD)~=0 or (g1 and g1:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD))) 
	local b2=ex2 and (bit.band(dv2,LOCATION_ONFIELD)~=0 or (g2 and g2:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD))) 
	local b3=ex3 and (bit.band(dv3,LOCATION_ONFIELD)~=0 or (g3 and g3:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD))) 
	local b4=ex4 and (bit.band(dv4,LOCATION_ONFIELD)~=0 or (g4 and g4:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD))) 
	local b5=ex5 and (bit.band(dv5,LOCATION_ONFIELD)~=0 or (g5 and g5:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD))) 
	local b6=ex6 and (bit.band(dv6,LOCATION_ONFIELD)~=0 or (g6 and g6:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD))) 
	local b7=ex7 and (bit.band(dv7,LOCATION_ONFIELD)~=0 or (g7 and g7:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD))) 
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and (b1 or b2 or b3 or b4 or b5 or b6 or b7)
end 
function c27822036.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if rp==1-tp and re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c27822036.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateEffect(ev) and rp==1-tp and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c27822036.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local bc=Duel.GetAttacker() 
	if chk==0 then return aux.NegateEffectMonsterFilter(bc) and bc and bc:IsCanBeEffectTarget(e) end 
	Duel.SetTargetCard(bc) 
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,bc,1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0) 
end 
function c27822036.ddop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()   
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Destroy(tc,REASON_EFFECT) 
	end 
end 






