--黯壳机 黑翼
function c79099300.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),8,2,nil,nil,99)
	c:EnableReviveLimit()
	--maintain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79099300,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c79099300.mtcon)
	e1:SetOperation(c79099300.mtop)
	c:RegisterEffect(e1)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,c)
	return c:GetOverlayCount()*800 end)
	c:RegisterEffect(e1)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetValue(function(e,c)
	return e:GetHandler():GetOverlayCount() end)
	c:RegisterEffect(e2) 
	--damage reduce 
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(79099300,1))
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,79099300) 
	e3:SetCost(c79099300.drecost)  
	e3:SetTarget(c79099300.dretg)  
	e3:SetOperation(c79099300.dreop) 
	c:RegisterEffect(e3)
end
function c79099300.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c79099300.mtop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	end
end
function c79099300.drecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local x=c:GetOverlayCount()
	if chk==0 then return x>0 and c:CheckRemoveOverlayCard(tp,x,REASON_COST) and c:IsAbleToRemoveAsCost() end 
	local a=c:RemoveOverlayCard(tp,x,x,REASON_COST) 
	e:SetLabel(a) 
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY) 
		e1:SetLabelObject(c) 
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCountLimit(1) 
		e1:SetCondition(function(e) 
		return Duel.GetTurnCount()~=e:GetLabel() end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) 
		e:Reset()
		Duel.ReturnToField(e:GetLabelObject()) end)
		Duel.RegisterEffect(e1,tp)
	end
end 
function c79099300.dretg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
end 
function c79099300.dreop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=e:GetLabel()  
	if x>0 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1) 
		e1:SetLabel(x)
		e1:SetValue(c79099300.damval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp) 
	end 
end 
function c79099300.damval(e,re,val,r,rp,rc) 
	local x=e:GetLabel()*1000  
	if val>x then return val-x 
	else return 0 end 
end








