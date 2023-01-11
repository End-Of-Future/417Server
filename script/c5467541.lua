--原子对撞技术
function c5467541.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,5467541)
	e1:SetTarget(c5467541.destg)
	e1:SetOperation(c5467541.desact)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,5467541)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c5467541.drtg)
	e2:SetOperation(c5467541.dract)
	c:RegisterEffect(e2)
end
function c5467541.cofi1(c)
	return c:IsCode(1543673)
end
function c5467541.cofi2(c)
	return c:IsCode(4723591)
end
function c5467541.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
		and Duel.IsExistingMatchingCard(c5467541.cofi1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c5467541.cofi2,tp,LOCATION_DECK,0,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c5467541.desact(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c5467541.cofi1,tp,LOCATION_DECK,0,1,1,nil)
	local kg=Duel.SelectMatchingCard(tp,c5467541.cofi2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and kg:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_COST)
		Duel.SendtoGrave(kg,REASON_COST)
		local sg=Duel.GetMatchingGroup(c5467541.desfi,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c5467541.drfi(c)
	return c:IsSetCard(0x1093,0xaa9)
end
function c5467541.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c5467541.drfi,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1)
end
function c5467541.dract(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDraw(tp,1)==false then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c5467541.drfi,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end