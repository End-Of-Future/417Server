--五王圣魂
function c27819056.initial_effect(c)
	 aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,27819056)
	e1:SetCondition(c27819056.discon)
	e1:SetCost(c27819056.discost)
	e1:SetTarget(c27819056.distg)
	e1:SetOperation(c27819056.disop)
	c:RegisterEffect(e1)
end
c27819056.SetCard_fiveking=true
c27819056.SetCard_fivekingtmx=true
function c27819056.discon(e,tp,eg,ep,ev,re,r,rp)
	local ex4=re:IsHasCategory(CATEGORY_TOGRAVE)
	return ex4 and Duel.IsChainDisablable(ev)
end

function c27819056.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c27819056.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsDisabled() end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function c27819056.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end