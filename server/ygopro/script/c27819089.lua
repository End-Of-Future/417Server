--五王-启元极
function c27819089.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c27819089.mfilter,7,2)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(27819089,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,27819089) 
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST) end) 
	e1:SetTarget(c27819089.negtg)
	e1:SetOperation(c27819089.negop)
	c:RegisterEffect(e1) 
	--ov 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_DESTROYED) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,17819089) 
	e2:SetTarget(c27819089.ovtg) 
	e2:SetOperation(c27819089.ovop) 
	c:RegisterEffect(e2) 
	--Destroy
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(27819089,1))
	e3:SetCategory(CATEGORY_DESTROY) 
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCondition(c27819089.descon)
	e3:SetTarget(c27819089.destg) 
	e3:SetOperation(c27819089.desop) 
	c:RegisterEffect(e3)  
end 
c27819089.SetCard_fiveking=true
function c27819089.mfilter(c) 
	return c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_LIGHT) 
end  
function c27819089.negtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c27819089.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY)
		end
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end
end
function c27819089.ovfil(c,e,tp) 
	return c:IsCanOverlay() and c:IsCanBeEffectTarget(e) and c:IsPreviousControler(1-tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) 
end 
function c27819089.ovtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return eg:IsExists(c27819089.ovfil,1,nil,e,tp) end 
	local g=eg:Filter(c27819089.ovfil,nil,e,tp) 
	Duel.SetTargetCard(g)
end 
function c27819089.ovop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()>0 and c:IsRelateToEffect(e) then 
	Duel.Overlay(c,g) 
	end 
end 
function c27819089.dckfil(c) 
	return c.SetCard_fiveking  
end 
function c27819089.descon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():GetOverlayGroup():IsExists(c27819089.dckfil,1,nil)
end 
function c27819089.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end 
function c27819089.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
	Duel.Destroy(tc,REASON_EFFECT) 
	end 
end 








