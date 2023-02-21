--贝利尔 世荒的天灾[R]
function c88881800.initial_effect(c) 
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION) 
	c:RegisterEffect(e0)	
	--disable field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(c88881800.disval)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c88881800.reptg)
	c:RegisterEffect(e2)
end
function c88881800.zonelimit(e)
	local tp=e:GetHandlerPlayer()
	local zone=0 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsCode(88881798) and c:GetSequence()<5 end,tp,LOCATION_MZONE,0,nil) 
	local tc=g:GetFirst() 
	while tc do 
		local seq=tc:GetSequence()
		if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,(1<<(seq+1)))>0 then  
			if seq==1 then bit.bor(zone,4) end 
			if seq==2 then bit.bor(zone,8) end 
			if seq==3 then bit.bor(zone,16) end  
		end
	tc=g:GetNext()
	end 
	return zone
end
function c88881800.disval(e)
	local c=e:GetHandler() 
	local tp=e:GetHandlerPlayer()
	local seq=c:GetSequence()
	local zone=0
	local val1=aux.SequenceToGlobal(1-tp,LOCATION_SZONE,4-seq)
	local val2=aux.SequenceToGlobal(1-tp,LOCATION_MZONE,4-seq)
	zone=bit.bor(zone,val1)
	zone=bit.bor(zone,val2)  
	if seq==1 then zone=bit.bor(zone,4194336) end 
	if seq==3 then zone=bit.bor(zone,2097216) end 
	return zone  
end
function c88881800.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end








