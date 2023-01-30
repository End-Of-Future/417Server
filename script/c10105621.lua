function c10105621.initial_effect(c)
	--arm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105621,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c10105621.armtg)
	e1:SetOperation(c10105621.armop)
	c:RegisterEffect(e1)
    	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10105621,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,10105621)
	e2:SetCost(c10105621.cost)
	e2:SetTarget(c10105621.target)
	e2:SetOperation(c10105621.operation)
	c:RegisterEffect(e2)
end
function c10105621.armtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local rc=Duel.AnnounceRace(tp,1,RACE_ALL)
	e:SetLabel(rc)
end
function c10105621.armop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local rc=e:GetLabel()
		e:GetHandler():SetHint(CHINT_RACE,rc)
		--atk up
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(10105621,1))
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
		e1:SetCondition(c10105621.upcon)
		e1:SetOperation(c10105621.upop)
		e1:SetLabel(rc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c10105621.upcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsRace(e:GetLabel())
end
function c10105621.upop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(2500)
		c:RegisterEffect(e1)
	end
end
function c10105621.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c10105621.filter(c)
	return c:IsFaceup()
end
function c10105621.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105621.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c10105621.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local race=0
	while tc do
		race=bit.bor(race,tc:GetRace())
		tc=g:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local arc=Duel.AnnounceRace(tp,1,race)
	e:SetLabel(arc)
	local dg=g:Filter(Card.IsRace,nil,arc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c10105621.filter2(c,rc)
	return c:IsFaceup() and c:IsRace(rc)
end
function c10105621.operation(e,tp,eg,ep,ev,re,r,rp)
	local arc=e:GetLabel()
	local g=Duel.GetMatchingGroup(c10105621.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,arc)
	Duel.Destroy(g,REASON_EFFECT)
end