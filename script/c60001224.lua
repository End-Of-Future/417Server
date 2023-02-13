--黄金匕首
local m=60001224
local cm=_G["c"..m]
cm.name="黄金匕首"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.actg)
	e1:SetOperation(cm.acop)
	c:RegisterEffect(e1)
end
function cm.filter2(c)
	return c.named_with_treasure 
end
function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) and Duel.IsPlayerCanSummon(tp) end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) and Duel.GetTurnPlayer()~=tp then
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	end
	local sg=Duel.GetMatchingGroup(Card.IsAttackBelow,tp,0,LOCATION_MZONE,nil,500)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil),0,0)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil) 
	local tc=g:GetFirst()
	while tc do 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)   
	tc=g:GetNext()
	end 
	local dg=Duel.GetMatchingGroup(Card.IsAttack,tp,LOCATION_MZONE,LOCATION_MZONE,nil,0)
	Duel.Destroy(dg,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(cm.filter2))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end