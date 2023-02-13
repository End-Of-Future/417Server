--看好了！这就是小丑的把戏！
function c88880518.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCost(c88880518.accost) 
	e1:SetTarget(c88880518.actg) 
	e1:SetOperation(c88880518.acop) 
	c:RegisterEffect(e1) 
end  
function c88880518.rmfil(c) 
	return c:IsAbleToRemoveAsCost() and c:IsCode(88880516)  
end 
function c88880518.accost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c88880518.rmfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local x=g:GetCount()
	if chk==0 then return x>0 end 
	local sg=g:Select(tp,x,x,nil) 
	local a=Duel.Remove(sg,POS_FACEUP,REASON_COST) 
	e:SetLabel(a) 
	Duel.SetChainLimit(c88880518.chlimit)
end
function c88880518.chlimit(e,ep,tp)
	return tp==ep
end 
function c88880518.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD)
end 
function c88880518.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil) 
	local x=e:GetLabel() 
	if g:GetCount()>0 and x>0 then 
		local sg=g:Select(1-tp,1,x,nil) 
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT+REASON_RULE) 
	end 
end 




