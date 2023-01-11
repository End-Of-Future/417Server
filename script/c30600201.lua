--S·I·N·其二罪·嫉妒
local m=30600201
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--maintain
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1)
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e0:SetCondition(cm.descon)
	e0:SetOperation(cm.desop)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,30600201+EFFECT_COUNT_CODE_OATH)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(cm.immcon)
	e1:SetTarget(cm.immtg)
	e1:SetOperation(cm.immop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	c:RegisterEffect(e2) 
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(30600201,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(cm.spcon)
	c:RegisterEffect(e3)  
	--indestructable effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetTarget(cm.indtg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e6)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(30600201,2))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.operation)
	c:RegisterEffect(e5)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	if Duel.CheckReleaseGroup(tp,nil,1,c) and Duel.SelectYesNo(tp,aux.Stringid(30600201,0)) then
		local g=Duel.SelectReleaseGroup(tp,nil,1,1,c)
		Duel.Release(g,REASON_COST)
	else Duel.Destroy(c,REASON_COST) end
end
function cm.immcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
	local tg=g:GetMaxGroup(Card.GetAttack)
	return tg:IsExists(Card.IsControler,1,nil,1-tp)
end
function cm.immfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc18)
end
function cm.immtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.immfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.immop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.immfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(cm.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function cm.efilter(e,te,c)
	return te:GetOwner()~=c
end
function cm.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xc18) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cm.sdfilter(c)
	return not c:IsCode(30600201)
end
function cm.spcon(e,c)
	return Duel.IsExistingMatchingCard(cm.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.indtg(e,c)
	return c:IsSetCard(0xc18) and not c:IsCode(30600201)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.SetChainLimit(aux.FALSE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,aux.ExceptThisCard(e))
	Duel.Destroy(g,REASON_EFFECT)
end