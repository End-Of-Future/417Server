--超级无敌烈火战神
local m=66300002
local cm=_G["c"..m]
function cm.initial_effect(c)
	 c:EnableReviveLimit()
	 local e1=Effect.CreateEffect(c)
	 e1:SetType(EFFECT_TYPE_SINGLE)
	 e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	 e1:SetCode(EFFECT_IMMUNE_EFFECT)
	 e1:SetRange(LOCATION_MZONE)
	 e1:SetCondition(c66300002.imcon)
	 e1:SetValue(c66300002.efilter)
	 c:RegisterEffect(e1)

	 local e2=Effect.CreateEffect(c)
	 e2:SetType(EFFECT_TYPE_SINGLE)
	 e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	 e2:SetCode(EFFECT_UPDATE_ATTACK)
	 e2:SetRange(LOCATION_MZONE)
	 e2:SetValue(c66300002.val)
	 c:RegisterEffect(e2)
	 local e3=e2:Clone()
	 e3:SetCode(EFFECT_UPDATE_DEFENSE)
	 c:RegisterEffect(e3)
	
	 local e4=Effect.CreateEffect(c)
	 e4:SetType(EFFECT_TYPE_FIELD)
	 e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	 e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
	 e4:SetRange(LOCATION_MZONE)
	 e4:SetTargetRange(LOCATION_SZONE,0)
	 e4:SetTarget(c66300002.indtg)
	 e4:SetValue(c66300002.indct)
	 c:RegisterEffect(e4)
end
function c66300002.imcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c66300002.efilter(e,te)
	return te:IsActiveType(TYPE_CONTINUOUS)
end
function c66300002.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xaabb) and c:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD)
end
function c66300002.val(e,c)
	return Duel.GetMatchingGroupCount(c66300002.filter,c:GetControler(),LOCATION_GRAVE+LOCATION_ONFIELD,0,nil,0xaabb)*100
end
function c66300002.indtg(e,c)
	return c:IsFaceup() and c:GetSequence()<5
end
function c66300002.indct(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end