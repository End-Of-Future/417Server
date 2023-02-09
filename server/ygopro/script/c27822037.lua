--响彻激流深渊的哀歌
function c27822037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27822037,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,27822037)
	e1:SetCondition(c27822037.condition)
	e1:SetTarget(c27822037.target)
	e1:SetOperation(c27822037.activate)
	c:RegisterEffect(e1) 
	--set 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,17822037) 
	e2:SetTarget(c27822037.settg) 
	e2:SetOperation(c27822037.setop) 
	c:RegisterEffect(e2) 
end
c27822037.XXSplash=true   
function c27822037.cfilter(c)
	return c:IsFaceup() and c.XXSplash and c:IsType(TYPE_LINK)
end
function c27822037.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c27822037.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	return rp==1-tp 
end
function c27822037.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c27822037.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c27822037.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsSSetable() end 
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0) 
end 
function c27822037.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsSSetable() then 
		Duel.SSet(tp,c) 
	end 
end 











