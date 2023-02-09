--圣光能转换
function c27819048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetCountLimit(1,27819048+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c27819048.target)
	e1:SetOperation(c27819048.activate)
	c:RegisterEffect(e1)
end 
c27819048.SetCard_XXLight=true  
function c27819048.tgfilter(c)
	return c.SetCard_XXLight and c:IsAbleToGrave()
end
function c27819048.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27819048.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)   
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c27819048.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c27819048.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
	Duel.Recover(tp,1000,REASON_EFFECT) 
	end
end

