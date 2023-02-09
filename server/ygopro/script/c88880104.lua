--恐啡肽狂龙肆虐
function c88880104.initial_effect(c) 
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE) 
	e1:SetCountLimit(1,88880104+EFFECT_COUNT_CODE_OATH) 
	e1:SetCost(c88880104.accost) 
	e1:SetTarget(c88880104.actg)
	e1:SetOperation(c88880104.acop) 
	c:RegisterEffect(e1) 
	--change damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c88880104.cdcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c88880104.cdop)
	c:RegisterEffect(e2)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND) 
	e2:SetCondition(c88880104.ahcon)
	c:RegisterEffect(e2) 
end
function c88880104.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c88880104.desfil(c)  
	return c:IsFaceup() and c:IsSetCard(0x173) 
end 
function c88880104.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880104.desfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE) 
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_ONFIELD)
end 
function c88880104.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(c88880104.desfil,tp,LOCATION_MZONE,0,nil) 
	local g2=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
	if g1:GetCount()<=0 then return end 
	local dg=g1:Select(tp,1,1,nil) 
	if Duel.Destroy(dg,REASON_EFFECT)~=0 and g2:GetCount()>0 then 
		Duel.BreakEffect() 
		local tc=g2:Select(tp,1,1,nil):GetFirst() 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
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
function c88880104.cdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000 and rp==1-tp
end
function c88880104.cdop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c88880104.damval1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c88880104.damval1(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 and rp==1-e:GetOwnerPlayer() then return 0
	else return val end
end
function c88880104.acfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x173)
end
function c88880104.ahcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c88880104.acfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end







