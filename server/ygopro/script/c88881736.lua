--废墟兵械 梁龙
function c88881736.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,88881736)
	e1:SetTarget(c88881736.tg)
	e1:SetOperation(c88881736.op)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c88881736.con)
	e3:SetTarget(c88881736.imtg)
	e3:SetValue(c88881736.efilter)
	c:RegisterEffect(e3)
end
function c88881736.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c88881736.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(88881736,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end
function c88881736.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(88881736)~=0
end
function c88881736.filter(c)
	return c:IsRace(RACE_MACHINE) and c:GetAttribute()==ATTRIBUTE_WIND
end
function c88881736.imtg(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(c88881736.filter,tp,LOCATION_MZONE,0,nil)
end
function c88881736.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end