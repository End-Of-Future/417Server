--血咒的魔女
function c64000050.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,64000050) 
	e1:SetCost(c64000050.xxcost) 
	e1:SetTarget(c64000050.xxtg) 
	e1:SetOperation(c64000050.xxop) 
	c:RegisterEffect(e1)  
end
function c64000050.xxcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,1500) and e:GetHandler():IsReleasable() end 
	Duel.PayLPCost(tp,1500) 
	Duel.Release(e:GetHandler(),REASON_COST) 
end 
function c64000050.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c64000050.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetCondition(c64000050.dacon) 
	e1:SetOperation(c64000050.daop) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	Duel.RegisterEffect(e2,tp) 
end 
function c64000050.dacfil(c,tp) 
	return c:IsSummonPlayer(1-tp) 
end 
function c64000050.dacon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c64000050.dacfil,1,nil,tp) 
end 
function c64000050.daop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=eg:Filter(c64000050.dacfil,nil,tp) 
	local atk=0 
	local tc=g:GetFirst() 
	while tc do 
		local a=tc:GetAttack()
		local b=tc:GetDefense()
		if b>a then a=b end
		if a<0 then a=0 end  
		atk=atk+a 
	tc=g:GetNext() 
	end 
	if atk>0 then 
		Duel.Hint(HINT_CARD,0,64000050) 
		Duel.Damage(1-tp,atk/2,REASON_EFFECT) 
	end 
end 




