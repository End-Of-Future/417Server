--五王同心
function c27819065.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)   
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetCountLimit(1,27819065+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c27819065.actg) 
	e1:SetOperation(c27819065.acop) 
	c:RegisterEffect(e1) 
end  
c27819065.SetCard_fiveking=true 
function c27819065.ckfil(c,e,tp) 
	local flag=0 
	if c:IsType(TYPE_MONSTER) then flag=bit.bor(flag,TYPE_MONSTER) end 
	if c:IsType(TYPE_SPELL) then flag=bit.bor(flag,TYPE_SPELL) end 
	if c:IsType(TYPE_TRAP) then flag=bit.bor(flag,TYPE_TRAP) end	  
	if flag==0 then return false end 
	return not c:IsPublic() and Duel.IsExistingMatchingCard(c27819065.thfil,tp,LOCATION_DECK,0,1,nil,flag) 
end 
function c27819065.thfil(c,flag) 
	return c:IsAbleToHand() and c:IsType(flag) and c.SetCard_fiveking 
end  
function c27819065.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c27819065.ckfil,tp,LOCATION_HAND,0,1,nil,e,tp) end 
	local tc=Duel.SelectMatchingCard(tp,c27819065.ckfil,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()   
	Duel.ConfirmCards(1-tp,tc) 
	e:SetLabelObject(tc) 
	local flag=0 
	if tc:IsType(TYPE_MONSTER) then flag=bit.bor(flag,TYPE_MONSTER) end 
	if tc:IsType(TYPE_SPELL) then flag=bit.bor(flag,TYPE_SPELL) end 
	if tc:IsType(TYPE_TRAP) then flag=bit.bor(flag,TYPE_TRAP) end   
	e:SetLabel(flag) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end  
function c27819065.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local flag=e:GetLabel() 
	local tc=e:GetLabelObject()  
	local g=Duel.GetMatchingGroup(c27819065.thfil,tp,LOCATION_DECK,0,nil,flag) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	if tc:IsLocation(LOCATION_HAND) then 
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end 
	end  
end 










