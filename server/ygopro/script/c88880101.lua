--默契交锋
function c88880101.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,88880101+EFFECT_COUNT_CODE_OATH) 
	c:RegisterEffect(e1) 
	--neg
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)  
	e2:SetCondition(c88880101.negcon) 
	e2:SetOperation(c88880101.negop) 
	c:RegisterEffect(e2) 
	--move 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMING_END_PHASE) 
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,18880101) 
	e3:SetTarget(c88880101.mvtg) 
	e3:SetOperation(c88880101.mvop) 
	c:RegisterEffect(e3)
end
function c88880101.negcon(e,tp,eg,ep,ev,re,r,rp) 
	local rc=re:GetHandler() 
	return rc and rc:IsControler(1-tp) and rc:IsOnField() and 4-rc:GetSequence()==e:GetHandler():GetSequence() 
end 
function c88880101.negop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local rc=re:GetHandler() 
	Duel.Hint(HINT_CARD,0,88880101)  
	Duel.NegateEffect(ev)
end 
function c88880101.mvtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToGrave() end 
end  
function c88880101.mvop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then 
	local s=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,0)
	local nseq=math.log(s,2)-8 
	Duel.MoveSequence(c,nseq)
	end 
end 




