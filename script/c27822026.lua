--激流之女神-奥西恩
function c27822026.initial_effect(c) 
	--link summon
	aux.AddLinkProcedure(c,c27822026.mfilter,2,nil,c27822026.lcheck)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c27822026.efilter)
	c:RegisterEffect(e1) 
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetMaterialCount()>0 end) 
	e2:SetOperation(c27822026.atkop) 
	c:RegisterEffect(e2) 
	--Destroy 
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e3:SetCode(EVENT_PHASE+PHASE_END) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1) 
	e3:SetTarget(c27822026.destg) 
	e3:SetOperation(c27822026.desop) 
	c:RegisterEffect(e3) 
	--atklimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_ATTACK) 
	c:RegisterEffect(e4)
end 
c27822026.XXSplash=true 
function c27822026.mfilter(c) 
	return c.XXSplash  
end 
function c27822026.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function c27822026.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer() and te:IsActiveType(TYPE_SPELL+TYPE_TRAP) 
end 
function c27822026.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and c:IsFaceup() then 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_SET_BASE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(c:GetMaterialCount()*2000) 
	c:RegisterEffect(e1)
	end 
end 
function c27822026.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end  
function c27822026.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) 
	if c:IsRelateToEffect(e) and c:IsFaceup() then 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(-2000) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1) 
	if g:GetCount()>0 and not c:IsHasEffect(EFFECT_REVERSE_UPDATE) then 
	Duel.Destroy(g,REASON_EFFECT) 
	end 
	end 
	if c:IsAttack(0) then 
	Duel.SendtoGrave(c,REASON_EFFECT) 
	end 
end 










