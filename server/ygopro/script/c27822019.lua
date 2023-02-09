--激流飞龙-裂变
function c27822019.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()   
	--Destroy 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end) 
	e1:SetTarget(c27822019.destg) 
	e1:SetOperation(c27822019.desop) 
	c:RegisterEffect(e1) 
	--up 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetValue(function(e) 
	local tp=e:GetHandlerPlayer() 
	return 150*Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_WATER) end)  
	c:RegisterEffect(e2)
end
c27822019.XXSplash=true 
function c27822019.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end 
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end 
function c27822019.mckfil(c) 
	return c:IsType(TYPE_LINK) and c.XXSplash  
end 
function c27822019.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())  
	local mg=c:GetMaterial() 
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 and mg:IsExists(c27822019.mckfil,1,nil) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_SZONE,LOCATION_SZONE,nil,1,TYPE_SPELL+TYPE_TRAP) then 
	local dg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.Destroy(dg,REASON_EFFECT) 
	g:Merge(dg)  
	end 
	g:KeepAlive() 
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e1:SetTargetRange(0,1) 
	e1:SetValue(c27822019.actlimit) 
	e1:SetLabelObject(g) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)
end 
function c27822019.actlimit(e,re,tp) 
	local g=e:GetLabelObject() 
	return g:IsContains(e:GetHandler()) 
end













