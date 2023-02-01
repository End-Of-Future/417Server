--圣光爆破
function c27819008.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(c27819008.condition)
	e1:SetTarget(c27819008.target)
	e1:SetOperation(c27819008.activate)
	c:RegisterEffect(e1)
end 
c27819008.SetCard_XXLight=true  
function c27819008.cfilter1(c,tp)
	return c:IsPreviousControler(tp)
end
function c27819008.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27819008.cfilter1,1,nil,tp)
end
function c27819008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	local x=eg:FilterCount(c27819008.cfilter1,nil,tp) 
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,x,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c27819008.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS) 
	local dg=g:Filter(Card.IsRelateToEffect,nil,e) 
	if dg:GetCount()>0 then
	Duel.Destroy(dg,REASON_EFFECT)
	end
end


