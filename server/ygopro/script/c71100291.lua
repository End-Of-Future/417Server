--鼠标宏
function c71100291.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	  --counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71100291,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c71100291.condition)
	e1:SetTarget(c71100291.target)
	e1:SetOperation(c71100291.operation)
	c:RegisterEffect(e1)
end
function c71100291.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c71100291.ctfilter(c)
	return c:IsFaceup()
end
function c71100291.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100291.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x1,99) end
end
function c71100291.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c71100291.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct==0 then return end
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,0x1,99)
	if g:GetCount()==0 then return end
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_COUNTER)
		local tc=g:Select(1-tp,1,1,nil):GetFirst()
		tc:AddCounter(0x1,99)
	end
end